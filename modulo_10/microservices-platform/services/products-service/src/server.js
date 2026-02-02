const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const { Pool } = require('pg');
const Redis = require('redis');
const amqp = require('amqplib');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');
const winston = require('winston');

// Configurações
const config = require('./config/config');
const productRoutes = require('./routes/product.routes');
const categoryRoutes = require('./routes/category.routes');
const searchRoutes = require('./routes/search.routes');
const { errorHandler, notFoundHandler } = require('./middleware/error.middleware');
const { cacheMiddleware, rateLimiter } = require('./middleware/cache.middleware');
const { validateAPIKey } = require('./middleware/auth.middleware');

// Configurar logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/combined.log' }),
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    })
  ]
});

// Inicializar Express
const app = express();
const PORT = process.env.PORT || 8002;

// Conexão com PostgreSQL
const dbPool = new Pool({
  host: config.db.host,
  port: config.db.port,
  database: config.db.database,
  user: config.db.user,
  password: config.db.password,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Testar conexão com banco
dbPool.connect((err, client, release) => {
  if (err) {
    logger.error('Error connecting to PostgreSQL:', err);
  } else {
    logger.info('Connected to PostgreSQL database');
    release();
  }
});

// Conexão com Redis
const redisClient = Redis.createClient({
  url: `redis://:${config.redis.password}@${config.redis.host}:${config.redis.port}`
});

redisClient.on('error', (err) => logger.error('Redis Client Error:', err));
redisClient.on('connect', () => logger.info('Connected to Redis'));

// Conectar Redis
(async () => {
  try {
    await redisClient.connect();
  } catch (err) {
    logger.error('Redis connection failed:', err);
  }
})();

// Conexão com RabbitMQ
let rabbitmqChannel = null;
async function connectRabbitMQ() {
  try {
    const connection = await amqp.connect({
      hostname: config.rabbitmq.host,
      port: config.rabbitmq.port,
      username: config.rabbitmq.user,
      password: config.rabbitmq.password,
    });

    rabbitmqChannel = await connection.createChannel();

    // Declarar exchanges
    await rabbitmqChannel.assertExchange('product_events', 'topic', { durable: true });
    await rabbitmqChannel.assertExchange('search_events', 'topic', { durable: true });

    logger.info('Connected to RabbitMQ');
  } catch (err) {
    logger.error('RabbitMQ connection failed:', err);
  }
}
connectRabbitMQ();

// Middlewares
app.use(helmet());
app.use(cors({
  origin: config.cors.origins,
  credentials: true
}));
app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/health', (req, res) => {
  const healthStatus = {
    status: 'healthy',
    service: 'products-service',
    timestamp: new Date().toISOString(),
    database: dbPool.totalCount > 0 ? 'connected' : 'disconnected',
    redis: redisClient.isOpen ? 'connected' : 'disconnected',
    rabbitmq: rabbitmqChannel ? 'connected' : 'disconnected'
  };

  res.json(healthStatus);
});

// Swagger documentation
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Products Service API',
      version: '1.0.0',
      description: 'API para gerenciamento de produtos',
    },
    servers: [
      {
        url: `http://localhost:${PORT}`,
        description: 'Development server',
      },
    ],
  },
  apis: ['./src/routes/*.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Rotas públicas
app.get('/', (req, res) => {
  res.json({
    message: 'Products Service API',
    version: '1.0.0',
    docs: '/api-docs',
    health: '/health'
  });
});

// Middleware de autenticação (opcional para algumas rotas)
app.use('/api', validateAPIKey);

// Middleware de cache e rate limiting
app.use('/api/products', cacheMiddleware(300)); // Cache de 5 minutos
app.use('/api/categories', rateLimiter(100, 15 * 60)); // 100 requests por 15 minutos

// Rotas da API
app.use('/api/products', productRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/search', searchRoutes);

// Error handlers
app.use(notFoundHandler);
app.use(errorHandler);

// Exportar app para testes
module.exports = app;

// Iniciar servidor apenas se não estiver em ambiente de teste
if (require.main === module) {
  app.listen(PORT, () => {
    logger.info(`Products Service running on port ${PORT}`);
    logger.info(`API Documentation: http://localhost:${PORT}/api-docs`);
  });
}