-- =========================
-- Schema: Customers & Orders
-- =========================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id  INT PRIMARY KEY,
    signup_date  DATE NOT NULL,
    country      TEXT NOT NULL
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(customer_id),
    order_date    DATE NOT NULL,
    order_amount  NUMERIC(10,2) NOT NULL CHECK (order_amount >= 0)
);

-- =========================
-- Sample Data (Small but useful)
-- =========================

INSERT INTO customers (customer_id, signup_date, country) VALUES
(1, '2024-01-05', 'Canada'),
(2, '2024-01-20', 'Canada'),
(3, '2024-02-02', 'USA'),
(4, '2024-02-15', 'Canada'),
(5, '2024-03-01', 'UK');

INSERT INTO orders (order_id, customer_id, order_date, order_amount) VALUES
(101, 1, '2024-01-10', 120.50),
(102, 1, '2024-02-12',  75.00),
(103, 2, '2024-01-25', 200.00),
(104, 2, '2024-03-05',  50.00),
(105, 3, '2024-02-10',  99.99),
(106, 3, '2024-03-12', 150.00),
(107, 4, '2024-02-20',  80.00),
(108, 4, '2024-04-01', 110.00),
(109, 5, '2024-03-15',  60.00),
(110, 5, '2024-04-10',  90.00);
