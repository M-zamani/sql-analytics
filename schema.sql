-- schema.sql
-- PostgreSQL schema for a small ecommerce-style analytics dataset

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id   INT PRIMARY KEY,
  full_name     TEXT NOT NULL,
  email         TEXT UNIQUE NOT NULL,
  segment       TEXT NOT NULL CHECK (segment IN ('SMB','Mid-Market','Enterprise')),
  country       TEXT NOT NULL,
  created_at    DATE NOT NULL
);

CREATE TABLE products (
  product_id    INT PRIMARY KEY,
  product_name  TEXT NOT NULL,
  category      TEXT NOT NULL,
  unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE orders (
  order_id      INT PRIMARY KEY,
  customer_id   INT NOT NULL REFERENCES customers(customer_id),
  order_date    DATE NOT NULL,
  order_status  TEXT NOT NULL CHECK (order_status IN ('completed','returned','cancelled')),
  channel       TEXT NOT NULL CHECK (channel IN ('web','mobile','partner'))
);

CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id      INT NOT NULL REFERENCES orders(order_id),
  product_id    INT NOT NULL REFERENCES products(product_id),
  quantity      INT NOT NULL CHECK (quantity > 0),
  unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

-- Helpful indexes for analytics-style queries
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
