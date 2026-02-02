package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"orders-service/handlers"
	"orders-service/middleware"
	"orders-service/models"
	"orders-service/queues"
	"orders-service/cache"
)

func main() {
	// Carregar variáveis de ambiente
	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: .env file not found")
	}

	// Inicializar logger
	logger := log.New(os.Stdout, "ORDERS-SERVICE: ", log.LstdFlags|log.Lshortfile)

	// Conectar ao PostgreSQL
	dsn := os.Getenv("DB_CONNECTION")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		logger.Fatal("Failed to connect to database:", err)
	}

	// Executar migrações automáticas
	if err := db.AutoMigrate(
		&models.Order{},
		&models.OrderItem{},
		&models.OrderStatusHistory{},
		&models.Payment{},
	); err != nil {
		logger.Fatal("Failed to migrate database:", err)
	}

	// Inicializar Redis
	redisClient := cache.NewRedisClient(
		os.Getenv("REDIS_HOST"),
		os.Getenv("REDIS_PORT"),
		os.Getenv("REDIS_PASSWORD"),
	)

	// Testar conexão Redis
	if err := redisClient.Ping(); err != nil {
		logger.Printf("Warning: Redis connection failed: %v", err)
	}

	// Conectar ao RabbitMQ
	rabbitMQ, err := queues.NewRabbitMQConnection(
		os.Getenv("RABBITMQ_HOST"),
		os.Getenv("RABBITMQ_PORT"),
		os.Getenv("RABBITMQ_USER"),
		os.Getenv("RABBITMQ_PASSWORD"),
	)
	if err != nil {
		logger.Printf("Warning: RabbitMQ connection failed: %v", err)
	} else {
		defer rabbitMQ.Close()
	}

	// Configurar Gin
	if os.Getenv("ENVIRONMENT") == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	router := gin.Default()

	// Middlewares globais
	router.Use(middleware.LoggerMiddleware(logger))
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.RecoveryMiddleware())
	router.Use(middleware.RateLimitMiddleware(100, time.Minute))

	// Health check
	router.GET("/health", func(c *gin.Context) {
		health := gin.H{
			"status":    "healthy",
			"service":   "orders-service",
			"timestamp": time.Now().UTC(),
			"version":   "1.0.0",
		}

		// Verificar conexões
		sqlDB, err := db.DB()
		if err == nil {
			if err := sqlDB.Ping(); err != nil {
				health["database"] = "unhealthy"
			} else {
				health["database"] = "healthy"
			}
		}

		if redisClient.Ping() == nil {
			health["redis"] = "healthy"
		} else {
			health["redis"] = "unhealthy"
		}

		c.JSON(http.StatusOK, health)
	})

	// Grupo de rotas da API
	api := router.Group("/api")
	{
		// Middleware de autenticação
		api.Use(middleware.AuthMiddleware())

		// Rotas de pedidos
		orders := api.Group("/orders")
		{
			orderHandler := handlers.NewOrderHandler(db, redisClient, rabbitMQ, logger)

			orders.GET("", orderHandler.GetOrders)
			orders.GET("/:id", orderHandler.GetOrder)
			orders.POST("", orderHandler.CreateOrder)
			orders.PUT("/:id", orderHandler.UpdateOrder)
			orders.DELETE("/:id", orderHandler.CancelOrder)
			orders.POST("/:id/process", orderHandler.ProcessOrder)
			orders.POST("/:id/ship", orderHandler.ShipOrder)
			orders.POST("/:id/complete", orderHandler.CompleteOrder)
		}

		// Rotas de pagamentos
		payments := api.Group("/payments")
		{
			paymentHandler := handlers.NewPaymentHandler(db, redisClient, logger)

			payments.GET("/order/:order_id", paymentHandler.GetOrderPayments)
			payments.POST("", paymentHandler.CreatePayment)
			payments.POST("/webhook/:gateway", paymentHandler.HandleWebhook)
		}

		// Rotas administrativas
		admin := api.Group("/admin")
		admin.Use(middleware.AdminMiddleware())
		{
			admin.GET("/orders", handlers.GetAllOrders)
			admin.GET("/stats", handlers.GetOrderStats)
			admin.POST("/orders/:id/refund", handlers.RefundOrder)
		}
	}

	// Iniciar servidor
	port := os.Getenv("PORT")
	if port == "" {
		port = "8003"
	}

	logger.Printf("Starting Orders Service on port %s", port)
	if err := router.Run(":" + port); err != nil {
		logger.Fatal("Failed to start server:", err)
	}
}