-- ============================================================
--  ONLINE FOOD DELIVERY SQL PROJECT
--  Full Project: Schema → Queries → Indexes → Triggers
-- ============================================================

-- ============================================================
-- PHASE 1: DATABASE & TABLE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS food_delivery_db;
USE food_delivery_db;

-- Customers Table
CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    city          VARCHAR(50),
    joined_date   DATE
);

-- Restaurants Table
CREATE TABLE IF NOT EXISTS restaurants (
    restaurant_id   INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(150) NOT NULL,
    cuisine_type    VARCHAR(80),
    city            VARCHAR(50),
    rating          DECIMAL(2,1)
);

-- Menu Items Table
CREATE TABLE IF NOT EXISTS menu_items (
    item_id         INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id   INT NOT NULL,
    item_name       VARCHAR(100) NOT NULL,
    category        VARCHAR(50),
    price           DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Delivery Agents Table
CREATE TABLE IF NOT EXISTS delivery_agents (
    agent_id    INT AUTO_INCREMENT PRIMARY KEY,
    agent_name  VARCHAR(100) NOT NULL,
    phone       VARCHAR(20),
    city        VARCHAR(50),
    is_active   BOOLEAN DEFAULT TRUE
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    restaurant_id   INT NOT NULL,
    agent_id        INT,
    order_date      DATE NOT NULL,
    order_amount    DECIMAL(10,2) NOT NULL,
    discount        DECIMAL(5,2) DEFAULT 0,
    delivery_time   INT COMMENT 'minutes',
    status          ENUM('Delivered','Cancelled','Pending') DEFAULT 'Pending',
    FOREIGN KEY (customer_id)   REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (agent_id)      REFERENCES delivery_agents(agent_id)
);

-- Order Items (bridge table)
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    item_id       INT NOT NULL,
    quantity      INT DEFAULT 1,
    unit_price    DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id)  REFERENCES menu_items(item_id)
);

-- ============================================================
-- PHASE 2: SAMPLE DATA
-- ============================================================

INSERT INTO customers (customer_name, email, phone, city, joined_date) VALUES
('Aarav Sharma',    'aarav@mail.com',   '9876543210', 'Mumbai',    '2022-01-15'),
('Priya Nair',      'priya@mail.com',   '9876543211', 'Pune',      '2022-03-22'),
('Rahul Gupta',     'rahul@mail.com',   '9876543212', 'Delhi',     '2021-11-05'),
('Sneha Patel',     'sneha@mail.com',   '9876543213', 'Bangalore', '2023-02-10'),
('Vikram Rao',      'vikram@mail.com',  '9876543214', 'Hyderabad', '2022-07-18'),
('Ananya Singh',    'ananya@mail.com',  '9876543215', 'Chennai',   '2023-05-30'),
('Arjun Mehta',     'arjun@mail.com',   '9876543216', 'Mumbai',    '2021-08-14'),
('Kavya Reddy',     'kavya@mail.com',   '9876543217', 'Pune',      '2022-12-01'),
('Rohan Joshi',     'rohan@mail.com',   '9876543218', 'Delhi',     '2023-01-20'),
('Meera Iyer',      'meera@mail.com',   '9876543219', 'Bangalore', '2022-09-09');

INSERT INTO restaurants (restaurant_name, cuisine_type, city, rating) VALUES
('Spice Garden',        'Indian',     'Mumbai',    4.5),
('Pizza Paradise',      'Italian',    'Pune',      4.2),
('Dragon Wok',          'Chinese',    'Delhi',     4.0),
('Burger Barn',         'American',   'Bangalore', 4.3),
('South Spice',         'South Indian','Hyderabad',4.7),
('The Pasta House',     'Italian',    'Chennai',   3.9),
('Tandoor Express',     'Indian',     'Mumbai',    4.6),
('Sushi Central',       'Japanese',   'Pune',      4.1),
('Kebab King',          'Middle Eastern','Delhi',  4.4),
('Green Bowl',          'Healthy',    'Bangalore', 4.8);

INSERT INTO delivery_agents (agent_name, phone, city, is_active) VALUES
('Amit Kumar',   '8001001001', 'Mumbai',    TRUE),
('Suresh Babu',  '8001001002', 'Pune',      TRUE),
('Rajesh Verma', '8001001003', 'Delhi',     TRUE),
('Kiran Das',    '8001001004', 'Bangalore', TRUE),
('Naveen Rao',   '8001001005', 'Hyderabad', FALSE);

INSERT INTO menu_items (restaurant_id, item_name, category, price) VALUES
(1, 'Butter Chicken',     'Main Course', 320.00),
(1, 'Garlic Naan',        'Bread',        60.00),
(2, 'Margherita Pizza',   'Pizza',       350.00),
(2, 'Pasta Arrabbiata',   'Pasta',       280.00),
(3, 'Kung Pao Chicken',   'Main Course', 300.00),
(4, 'Classic Burger',     'Burger',      220.00),
(5, 'Masala Dosa',        'Breakfast',   120.00),
(6, 'Penne Alfredo',      'Pasta',       260.00),
(7, 'Dal Makhani',        'Main Course', 240.00),
(10,'Buddha Bowl',        'Bowl',        380.00);

INSERT INTO orders (customer_id, restaurant_id, agent_id, order_date, order_amount, discount, delivery_time, status) VALUES
(1,  1, 1, '2024-01-10',  640.00, 50.00,  30, 'Delivered'),
(2,  2, 2, '2024-01-12',  350.00,  0.00,  25, 'Delivered'),
(3,  3, 3, '2024-01-15',  600.00, 30.00,  50, 'Delivered'),
(4,  4, 4, '2024-01-18',  440.00, 20.00,  20, 'Delivered'),
(5,  5, 5, '2024-01-20',  360.00,  0.00,  60, 'Delivered'),
(6,  6, 1, '2024-02-02',  260.00,  0.00,  35, 'Delivered'),
(7,  7, 2, '2024-02-05',  480.00, 10.00,  28, 'Delivered'),
(8,  8, 3, '2024-02-08',  900.00, 50.00,  40, 'Delivered'),
(9,  9, 4, '2024-02-10', 1200.00,100.00,  22, 'Delivered'),
(10,10, 1, '2024-02-14',  380.00,  0.00,  18, 'Delivered'),
(1,  2, 2, '2024-03-01',  700.00, 70.00,  55, 'Delivered'),
(2,  7, 3, '2024-03-05',  960.00,  0.00,  32, 'Delivered'),
(3,  1, 4, '2024-03-10',  320.00,  0.00,  27, 'Cancelled'),
(4,  5, 1, '2024-03-15',  480.00, 20.00,  48, 'Delivered'),
(5,  4, 2, '2024-03-20', 1100.00,100.00,  19, 'Delivered');

INSERT INTO order_items (order_id, item_id, quantity, unit_price) VALUES
(1,  1, 2, 320.00), (1, 2, 0, 60.00),
(2,  3, 1, 350.00),
(3,  5, 2, 300.00),
(4,  6, 2, 220.00),
(5,  7, 3, 120.00),
(6,  8, 1, 260.00),
(7,  9, 2, 240.00),
(8,  4, 3, 280.00),
(9, 10, 1, 380.00),
(10,10, 1, 380.00);

-- ============================================================
-- PHASE 3: EXPLORATORY QUERIES
-- ============================================================

-- 1. Total number of orders
SELECT COUNT(*) AS total_orders FROM orders;

-- 2. Total revenue from delivered orders
SELECT ROUND(SUM(order_amount - discount), 2) AS total_revenue
FROM orders
WHERE status = 'Delivered';

-- 3. Average order value
SELECT ROUND(AVG(order_amount), 2) AS avg_order_value FROM orders;

-- 4. Orders by status
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status;

-- 5. Top 5 customers by spending
SELECT c.customer_name,
       ROUND(SUM(o.order_amount - o.discount), 2) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 6. Top 10 restaurants by revenue
SELECT r.restaurant_name,
       r.cuisine_type,
       ROUND(SUM(o.order_amount - o.discount), 2) AS revenue,
       COUNT(o.order_id) AS total_orders
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name, r.cuisine_type
ORDER BY revenue DESC
LIMIT 10;

-- 7. City-wise order distribution
SELECT c.city, COUNT(o.order_id) AS total_orders,
       ROUND(SUM(o.order_amount), 2) AS city_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;

-- 8. Average delivery time per city
SELECT c.city,
       ROUND(AVG(o.delivery_time), 1) AS avg_delivery_minutes
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.city
ORDER BY avg_delivery_minutes;

-- 9. Monthly revenue trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       COUNT(*) AS orders,
       ROUND(SUM(order_amount - discount), 2) AS revenue
FROM orders
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;

-- 10. Most popular cuisine types
SELECT r.cuisine_type,
       COUNT(o.order_id) AS order_count,
       ROUND(SUM(o.order_amount), 2) AS total_revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.cuisine_type
ORDER BY order_count DESC;

-- 11. Discount impact analysis
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) AS discounted_orders,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(SUM(discount), 2) AS total_discount_given
FROM orders;

-- 12. Late deliveries (> 45 min)
SELECT o.order_id, c.customer_name, r.restaurant_name,
       o.delivery_time, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.delivery_time > 45 AND o.status = 'Delivered'
ORDER BY o.delivery_time DESC;

-- 13. Agent performance
SELECT da.agent_name,
       COUNT(o.order_id) AS deliveries_made,
       ROUND(AVG(o.delivery_time), 1) AS avg_delivery_time,
       ROUND(SUM(o.order_amount), 2) AS total_value_delivered
FROM orders o
JOIN delivery_agents da ON o.agent_id = da.agent_id
WHERE o.status = 'Delivered'
GROUP BY da.agent_id, da.agent_name
ORDER BY deliveries_made DESC;

-- 14. Customer retention - repeat orders
SELECT c.customer_name,
       COUNT(o.order_id) AS times_ordered
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY times_ordered DESC;

-- 15. High-value orders (> 1000)
SELECT o.order_id, c.customer_name, r.restaurant_name,
       o.order_amount, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_amount > 1000
ORDER BY o.order_amount DESC;

-- ============================================================
-- PHASE 4: ADVANCED / ANALYTICAL QUERIES
-- ============================================================

-- 16. Rank restaurants by revenue using window function
SELECT restaurant_name, revenue,
       RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM (
    SELECT r.restaurant_name,
           ROUND(SUM(o.order_amount - o.discount), 2) AS revenue
    FROM orders o
    JOIN restaurants r ON o.restaurant_id = r.restaurant_id
    WHERE o.status = 'Delivered'
    GROUP BY r.restaurant_id, r.restaurant_name
) ranked;

-- 17. Running total of revenue by date
SELECT order_date,
       daily_revenue,
       ROUND(SUM(daily_revenue) OVER (ORDER BY order_date), 2) AS running_total
FROM (
    SELECT order_date,
           SUM(order_amount - discount) AS daily_revenue
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY order_date
) daily;

-- 18. Percentage of total revenue per restaurant
SELECT r.restaurant_name,
       ROUND(SUM(o.order_amount - o.discount), 2) AS restaurant_revenue,
       ROUND(
           SUM(o.order_amount - o.discount) * 100.0 /
           SUM(SUM(o.order_amount - o.discount)) OVER(), 2
       ) AS pct_of_total
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY restaurant_revenue DESC;

-- 19. Customers who have never cancelled
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) = 0
ORDER BY total_orders DESC;

-- 20. Average order value vs. average delivery time correlation
SELECT r.restaurant_name,
       ROUND(AVG(o.order_amount), 2) AS avg_order_value,
       ROUND(AVG(o.delivery_time), 1) AS avg_delivery_time
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name;

-- ============================================================
-- PHASE 5: VIEWS
-- ============================================================

-- View: Order summary with all joined details
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    o.order_id,
    c.customer_name,
    c.city          AS customer_city,
    r.restaurant_name,
    r.cuisine_type,
    da.agent_name,
    o.order_date,
    o.order_amount,
    o.discount,
    ROUND(o.order_amount - o.discount, 2) AS net_amount,
    o.delivery_time,
    o.status
FROM orders o
JOIN customers       c  ON o.customer_id   = c.customer_id
JOIN restaurants     r  ON o.restaurant_id = r.restaurant_id
LEFT JOIN delivery_agents da ON o.agent_id = da.agent_id;

-- View: Restaurant revenue summary
CREATE OR REPLACE VIEW vw_restaurant_revenue AS
SELECT
    r.restaurant_id,
    r.restaurant_name,
    r.cuisine_type,
    r.city,
    r.rating,
    COUNT(o.order_id)                              AS total_orders,
    ROUND(SUM(o.order_amount - o.discount), 2)     AS total_revenue,
    ROUND(AVG(o.order_amount), 2)                  AS avg_order_value,
    ROUND(AVG(o.delivery_time), 1)                 AS avg_delivery_time
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id AND o.status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name, r.cuisine_type, r.city, r.rating;

-- ============================================================
-- PHASE 6: STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- Procedure: Revenue report by date range
CREATE PROCEDURE IF NOT EXISTS sp_revenue_by_period(
    IN p_start DATE,
    IN p_end   DATE
)
BEGIN
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        COUNT(*) AS total_orders,
        ROUND(SUM(order_amount - discount), 2) AS revenue
    FROM orders
    WHERE status = 'Delivered'
      AND order_date BETWEEN p_start AND p_end
    GROUP BY month
    ORDER BY month;
END$$

-- Procedure: Customer order history
CREATE PROCEDURE IF NOT EXISTS sp_customer_history(
    IN p_customer_id INT
)
BEGIN
    SELECT o.order_id, r.restaurant_name, o.order_date,
           o.order_amount, o.discount,
           ROUND(o.order_amount - o.discount, 2) AS net_amount,
           o.delivery_time, o.status
    FROM orders o
    JOIN restaurants r ON o.restaurant_id = r.restaurant_id
    WHERE o.customer_id = p_customer_id
    ORDER BY o.order_date DESC;
END$$

DELIMITER ;

-- ============================================================
-- PHASE 7: INDEXES (Performance Optimization)
-- ============================================================

-- Index on order_date for date-range queries
CREATE INDEX IF NOT EXISTS idx_order_date
    ON orders(order_date);

-- Index on customer_name for search queries
CREATE INDEX IF NOT EXISTS idx_customer_name
    ON customers(customer_name);

-- Index on restaurant_name for search queries
CREATE INDEX IF NOT EXISTS idx_restaurant_name
    ON restaurants(restaurant_name);

-- Composite index on status + order_date (very common filter combo)
CREATE INDEX IF NOT EXISTS idx_order_status_date
    ON orders(status, order_date);

-- Index on delivery_time for latency analysis
CREATE INDEX IF NOT EXISTS idx_delivery_time
    ON orders(delivery_time);

-- ============================================================
-- PHASE 8: TRIGGERS
-- ============================================================

-- Log table for high value orders
CREATE TABLE IF NOT EXISTS high_value_orders_log (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    order_id    INT,
    customer_id INT,
    order_amount DECIMAL(10,2),
    logged_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Log table for delivery delays
CREATE TABLE IF NOT EXISTS delivery_delay_log (
    log_id        INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT,
    restaurant_id INT,
    delivery_time INT,
    logged_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

-- Trigger 1: Log high-value orders (> $1,000)
CREATE TRIGGER IF NOT EXISTS trg_high_value_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.order_amount > 1000 THEN
        INSERT INTO high_value_orders_log (order_id, customer_id, order_amount)
        VALUES (NEW.order_id, NEW.customer_id, NEW.order_amount);
    END IF;
END$$

-- Trigger 2: Prevent negative discounts
CREATE TRIGGER IF NOT EXISTS trg_no_negative_discount
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.discount < 0 THEN
        SET NEW.discount = 0;
    END IF;
END$$

-- Trigger 3: Log delivery delays (> 45 minutes)
CREATE TRIGGER IF NOT EXISTS trg_delivery_delay_warning
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.delivery_time > 45 THEN
        INSERT INTO delivery_delay_log (order_id, restaurant_id, delivery_time)
        VALUES (NEW.order_id, NEW.restaurant_id, NEW.delivery_time);
    END IF;
END$$

DELIMITER ;

-- ============================================================
-- PHASE 9: TRIGGER TESTING
-- ============================================================

-- Test 1: Should log in high_value_orders_log (amount = 1500)
INSERT INTO orders (customer_id, restaurant_id, agent_id, order_date, order_amount, discount, delivery_time, status)
VALUES (1, 1, 1, CURDATE(), 1500.00, 0, 25, 'Delivered');

-- Test 2: Negative discount → should be set to 0 automatically
INSERT INTO orders (customer_id, restaurant_id, agent_id, order_date, order_amount, discount, delivery_time, status)
VALUES (2, 2, 2, CURDATE(), 450.00, -50.00, 30, 'Delivered');

-- Test 3: Delivery time 60 min → should log in delivery_delay_log
INSERT INTO orders (customer_id, restaurant_id, agent_id, order_date, order_amount, discount, delivery_time, status)
VALUES (3, 3, 3, CURDATE(), 300.00, 0, 60, 'Delivered');

-- Verify trigger results
SELECT * FROM high_value_orders_log;
SELECT * FROM delivery_delay_log;

-- Confirm negative discount was zeroed
SELECT order_id, order_amount, discount
FROM orders
ORDER BY order_id DESC
LIMIT 5;

-- ============================================================
-- END OF PROJECT
-- ============================================================
