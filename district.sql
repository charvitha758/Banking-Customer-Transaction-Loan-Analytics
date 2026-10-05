-- distrcit population and salary
SELECT
    A1 AS district_id,
    A2 AS district_name,
    A4 AS population,
    A11 AS avg_salary
FROM district
ORDER BY population DESC;

-- district unemployment
SELECT
    A1 AS district_id,
    A2 AS district_name,
    A12 AS unemployment_1995,
    A13 AS unemployment_1996
FROM district
ORDER BY unemployment_1996 DESC;

-- district crime
SELECT
    A1 AS district_id,
    A2 AS district_name,
    A15 AS crimes_1995,
    A16 AS crimes_1996
FROM district
ORDER BY crimes_1996 DESC;

-- customers and accounts by district
SELECT
    d.A1 AS district_id,
    d.A2 AS district_name,
    COUNT(DISTINCT c.client_id) AS customer_count,
    COUNT(DISTINCT a.Account_id) AS account_count
FROM district d
LEFT JOIN client c
    ON d.A1 = c.district_id
LEFT JOIN account a
    ON d.A1 = a.district_id
GROUP BY d.A1, d.A2
ORDER BY customer_count DESC;

-- loan amount by district
SELECT
    d.A1 AS district_id,
    d.A2 AS district_name,
    COUNT(DISTINCT l.loan_id) AS loan_count,
    SUM(l.amount) AS total_loan_amount
FROM district d
JOIN account a
    ON d.A1 = a.district_id
JOIN loan l
    ON a.account_id = l.account_id
GROUP BY d.A1, d.A2
ORDER BY total_loan_amount DESC;