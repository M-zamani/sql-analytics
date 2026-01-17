-- sample_data.sql
-- Small, realistic sample dataset (mix of segments, months, and channels)

INSERT INTO customers (customer_id, full_name, email, segment, country, created_at) VALUES
(1,'Ava Chen','ava.chen@example.com','SMB','Canada','2024-10-02'),
(2,'Noah Patel','noah.patel@example.com','SMB','Canada','2024-10-15'),
(3,'Sophia Martin','sophia.martin@example.com','Mid-Market','Canada','2024-11-01'),
(4,'Liam Johnson','liam.johnson@example.com','Mid-Market','USA','2024-11-10'),
(5,'Olivia Smith','olivia.smith@example.com','Enterprise','Canada','2024-11-22'),
(6,'Ethan Brown','ethan.brown@example.com','Enterprise','UK','2024-12-05'),
(7,'Mia Wilson','mia.wilson@example.com','SMB','USA','2024-12-12'),
(8,'Lucas Garcia','lucas.garcia@example.com','Mid-Market','Canada','2025-01-08');

INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(101,'Starter Plan','Subscription',29.00),
(102,'Pro Plan','Subscription',79.00),
(103,'Enterprise Plan','Subscription',199.00),
(201,'Analytics Add-on','Add-on',19.00),
(202,'Data Connector Pack','Add-on',49.00),
(301,'Onboarding Service','Services',299.00);

-- Orders across 6 months with some churn/return/cancel behavior
INSERT INTO orders (order_id, customer_id, order_date, order_status, channel) VALUES
(1001,1,'2024-11-03','completed','web'),
(1002,1,'2024-12-07','completed','web'),
(1003,1,'2025-01-05','completed','mobile'),
(1004,1,'2025-03-09','completed','web'),

(1005,2,'2024-11-18','completed','web'),
(1006,2,'2024-12-20','completed','web'),
(1007,2,'2025-01-22','cancelled','mobile'),

(1008,3,'2024-12-02','completed','partner'),
(1009,3,'2025-01-10','completed','partner'),
(1010,3,'2025-02-14','completed','web'),

(1011,4,'2024-12-15','completed','web'),
(1012,4,'2025-02-01','completed','mobile'),

(1013,5,'2024-12-21','completed','partner'),
(1014,5,'2025-01-18','returned','partner'),
(1015,5,'2025-02-20','completed','partner'),
(1016,5,'2025-03-25','completed','partner'),

(1017,6,'2025-01-06','completed','web'),
(1018,6,'2025-02-09','completed','web'),
(1019,6,'2025-03-11','completed','web'),

(1020,7,'2025-01-15','completed','mobile'),
(1021,7,'2025-03-02','completed','mobile'),

(1022,8,'2025-01-28','completed','web'),
(1023,8,'2025-02-25','cancelled','web'),
(1024,8,'2025-03-20','completed','web');

-- Order items (capture unit_price at purchase time)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1,1001,101,1,29.00),
(2,1001,201,1,19.00),

(3,1002,101,1,29.00),
(4,1002,202,1,49.00),

(5,1003,102,1,79.00),

(6,1004,102,1,79.00),
(7,1004,201,1,19.00),

(8,1005,101,1,29.00),
(9,1006,101,1,29.00),
(10,1007,102,1,79.00),

(11,1008,102,1,79.00),
(12,1009,102,1,79.00),
(13,1010,102,1,79.00),
(14,1010,202,1,49.00),

(15,1011,101,1,29.00),
(16,1012,102,1,79.00),

(17,1013,103,1,199.00),
(18,1013,301,1,299.00),
(19,1014,103,1,199.00),
(20,1015,103,1,199.00),
(21,1016,103,1,199.00),
(22,1016,202,1,49.00),

(23,1017,103,1,199.00),
(24,1018,103,1,199.00),
(25,1019,103,1,199.00),

(26,1020,101,1,29.00),
(27,1021,102,1,79.00),

(28,1022,102,1,79.00),
(29,1023,101,1,29.00),
(30,1024,102,1,79.00),
(31,1024,201,1,19.00);
