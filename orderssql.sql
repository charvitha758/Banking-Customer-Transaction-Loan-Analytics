-- total orders and total amount
SELECT
    COUNT(*) AS total_orders,
    SUM(amount) AS total_order_amount,
    ROUND(AVG(amount), 2) AS avg_order_amount
FROM orders;

-- orders by destination bank
SELECT
    bank_to,
    COUNT(*) AS order_count,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM orders
GROUP BY bank_to
ORDER BY total_amount DESC;

-- orders by payment category
SELECT
    k_symbol,
    COUNT(*) AS order_count,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM orders
GROUP BY k_symbol
ORDER BY order_count DESC;

-- orders by account
SELECT
    account_id,
    COUNT(*) AS order_count,
    SUM(amount) AS total_order_amount,
    ROUND(AVG(amount), 2) AS avg_order_amount
FROM orders
GROUP BY account_id
ORDER BY total_order_amount DESC;

-- top accounts by standing order value
SELECT
    account_id,
    SUM(amount) AS total_order_amount
FROM orders
GROUP BY account_id
ORDER BY total_order_amount DESC
LIMIT 10;

-- account + loan + standing order 
