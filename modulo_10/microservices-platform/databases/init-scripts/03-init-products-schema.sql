\c productsdb

-- Tabela de categorias
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES categories(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    compare_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    category_id UUID REFERENCES categories(id),
    stock_quantity INTEGER DEFAULT 0,
    stock_status VARCHAR(20) DEFAULT 'out_of_stock',
    weight DECIMAL(8,2),
    dimensions JSONB,
    images JSONB DEFAULT '[]',
    attributes JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de reviews
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    comment TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    is_approved BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_created_at ON products(created_at);
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);

-- Inserir categorias padrão
INSERT INTO categories (id, name, slug, description) VALUES
    ('d1e8a3b5-c2f4-4a7d-9c8e-5f6a7b8c9d0a', 'Eletrônicos', 'eletronicos', 'Produtos eletrônicos em geral'),
    ('e2f9b4c6-d3g5-5b8e-0d9f-6a7b8c9d0e1b', 'Informática', 'informatica', 'Computadores e acessórios'),
    ('f3g0c5d7-e4h6-6c9f-1e0g-7b8c9d0e1f2c', 'Livros', 'livros', 'Livros de todos os gêneros')
ON CONFLICT (slug) DO NOTHING;