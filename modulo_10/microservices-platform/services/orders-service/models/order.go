package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type OrderStatus string

const (
	OrderStatusPending    OrderStatus = "pending"
	OrderStatusConfirmed  OrderStatus = "confirmed"
	OrderStatusProcessing OrderStatus = "processing"
	OrderStatusShipped    OrderStatus = "shipped"
	OrderStatusDelivered  OrderStatus = "delivered"
	OrderStatusCancelled  OrderStatus = "cancelled"
	OrderStatusRefunded   OrderStatus = "refunded"
)

type Order struct {
	ID              uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	OrderNumber     string         `gorm:"uniqueIndex;not null" json:"order_number"`
	UserID          uuid.UUID      `gorm:"type:uuid;not null;index" json:"user_id"`
	Status          OrderStatus    `gorm:"type:varchar(20);default:'pending';index" json:"status"`

	// Valores monetários
	TotalAmount     float64        `gorm:"type:decimal(10,2);not null" json:"total_amount"`
	Subtotal        float64        `gorm:"type:decimal(10,2);not null" json:"subtotal"`
	TaxAmount       float64        `gorm:"type:decimal(10,2);default:0" json:"tax_amount"`
	ShippingAmount  float64        `gorm:"type:decimal(10,2);default:0" json:"shipping_amount"`
	DiscountAmount  float64        `gorm:"type:decimal(10,2);default:0" json:"discount_amount"`
	Currency        string         `gorm:"type:varchar(3);default:'BRL'" json:"currency"`

	// Endereços
	ShippingAddress JSONB          `gorm:"type:jsonb;not null" json:"shipping_address"`
	BillingAddress  JSONB          `gorm:"type:jsonb;not null" json:"billing_address"`

	// Métodos
	PaymentMethod   string         `gorm:"type:varchar(50)" json:"payment_method"`
	PaymentStatus   string         `gorm:"type:varchar(20);default:'pending'" json:"payment_status"`
	ShippingMethod  string         `gorm:"type:varchar(50)" json:"shipping_method"`

	// Informações adicionais
	Notes           string         `gorm:"type:text" json:"notes"`
	Metadata        JSONB          `gorm:"type:jsonb;default:'{}'" json:"metadata"`

	// Timestamps
	CreatedAt       time.Time      `json:"created_at"`
	UpdatedAt       time.Time      `json:"updated_at"`
	DeletedAt       gorm.DeletedAt `gorm:"index" json:"-"`

	// Relacionamentos
	Items           []OrderItem    `gorm:"foreignKey:OrderID;constraint:OnDelete:CASCADE" json:"items,omitempty"`
	StatusHistory   []OrderStatusHistory `gorm:"foreignKey:OrderID;constraint:OnDelete:CASCADE" json:"status_history,omitempty"`
	Payments        []Payment      `gorm:"foreignKey:OrderID;constraint:OnDelete:CASCADE" json:"payments,omitempty"`
}

type OrderItem struct {
	ID           uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	OrderID      uuid.UUID `gorm:"type:uuid;not null;index" json:"order_id"`
	ProductID    uuid.UUID `gorm:"type:uuid;not null;index" json:"product_id"`
	ProductName  string    `gorm:"type:varchar(255);not null" json:"product_name"`
	ProductSKU   string    `gorm:"type:varchar(50);not null" json:"product_sku"`
	Quantity     int       `gorm:"not null" json:"quantity"`
	UnitPrice    float64   `gorm:"type:decimal(10,2);not null" json:"unit_price"`
	TotalPrice   float64   `gorm:"type:decimal(10,2);not null" json:"total_price"`
	VariantData  JSONB     `gorm:"type:jsonb;default:'{}'" json:"variant_data"`
	CreatedAt    time.Time `json:"created_at"`
}

type OrderStatusHistory struct {
	ID        uuid.UUID   `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	OrderID   uuid.UUID   `gorm:"type:uuid;not null;index" json:"order_id"`
	Status    OrderStatus `gorm:"type:varchar(20);not null" json:"status"`
	Notes     string      `gorm:"type:text" json:"notes"`
	CreatedAt time.Time   `json:"created_at"`
}

type Payment struct {
	ID            uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	OrderID       uuid.UUID `gorm:"type:uuid;not null;index" json:"order_id"`
	PaymentMethod string    `gorm:"type:varchar(50);not null" json:"payment_method"`
	Gateway       string    `gorm:"type:varchar(50);not null" json:"gateway"`
	TransactionID string    `gorm:"type:varchar(100);uniqueIndex" json:"transaction_id"`
	Amount        float64   `gorm:"type:decimal(10,2);not null" json:"amount"`
	Currency      string    `gorm:"type:varchar(3);default:'BRL'" json:"currency"`
	Status        string    `gorm:"type:varchar(20);default:'pending'" json:"status"`
	GatewayData   JSONB     `gorm:"type:jsonb;default:'{}'" json:"gateway_data"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// JSONB é um tipo customizado para JSONB do PostgreSQL
type JSONB map[string]interface{}

func (j JSONB) Value() (interface{}, error) {
	return json.Marshal(j)
}

func (j *JSONB) Scan(value interface{}) error {
	if value == nil {
		*j = nil
		return nil
	}

	b, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}

	return json.Unmarshal(b, j)
}