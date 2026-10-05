-- total accounts
SELECT COUNT(*) AS total_accounts
FROM account;

-- unique accounts
SELECT COUNT(DISTINCT account_id) AS unique_accounts
FROM account;

-- how frequently customers review account
SELECT
    frequency,
    COUNT(*) AS account_count
FROM account
GROUP BY frequency
ORDER BY account_count DESC;

-- account frequency percentage
SELECT
    frequency,
    COUNT(*) AS account_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM account),
        2
    ) AS percentage
FROM account
GROUP BY frequency
ORDER BY account_count DESC;

-- account by district
SELECT
    d.A1 AS district_id,
    d.A2 AS district_name,
    COUNT(*) AS account_count
FROM account a
JOIN district d
    ON a.district_id = d.A1
GROUP BY
    d.A1,
    d.A2
ORDER BY account_count DESC;

-- Top 10 districts by number of accounts
SELECT
    d.A2 AS district_name,
    COUNT(*) AS account_count
FROM account a
JOIN district d
    ON a.district_id = d.A1
GROUP BY d.A2
ORDER BY account_count DESC
LIMIT 10;

-- account opening dates
SELECT
    account_id,
    date
FROM account
LIMIT 20;

-- accounts opened by year
SELECT
    1900 + CAST(SUBSTRING(date, 1, 2) AS UNSIGNED) AS opening_year,
    COUNT(*) AS account_count
FROM account
GROUP BY opening_year
ORDER BY opening_year;

-- accounts opened by year and month
SELECT
    1900 + CAST(SUBSTRING(date, 1, 2) AS UNSIGNED) AS opening_year,
    CAST(SUBSTRING(date, 3, 2) AS UNSIGNED) AS opening_month,
    COUNT(*) AS account_count
FROM account
GROUP BY
    opening_year,
    opening_month
ORDER BY
    opening_year,
    opening_month;
    
-- earliest account opening date
SELECT
    MIN(date) AS earliest_account_date
FROM account;

-- latest account opening date
SELECT
    MAX(date) AS latest_account_date
FROM account;

-- accounts opened by frequency and year
SELECT
    1900 + CAST(SUBSTRING(date, 1, 2) AS UNSIGNED) AS opening_year,
    frequency,
    COUNT(*) AS account_count
FROM account
GROUP BY
    opening_year,
    frequency
ORDER BY
    opening_year,
    frequency;
    
-- customer and account analysis using disp
-- total customers and accounts connected through disp
SELECT
    COUNT(DISTINCT client_id) AS customers_with_accounts,
    COUNT(DISTINCT account_id) AS accounts_with_customers
FROM disp;

-- relationship type distribution
SELECT
    type,
    COUNT(*) AS relationship_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disp),
        2
    ) AS percentage
FROM disp
GROUP BY type;

-- cistomer with multiple accounts
SELECT
    client_id,
    COUNT(DISTINCT account_id) AS account_count
FROM disp
GROUP BY client_id
HAVING COUNT(DISTINCT account_id) > 1
ORDER BY account_count DESC;

-- distribution of customers by number of accounts
SELECT
    account_count,
    COUNT(*) AS customer_count
FROM (
    SELECT
        client_id,
        COUNT(DISTINCT account_id) AS account_count
    FROM disp
    GROUP BY client_id
) AS customer_accounts
GROUP BY account_count
ORDER BY account_count;

-- accounts with multiple customers
SELECT
    account_id,
    COUNT(DISTINCT client_id) AS customer_count
FROM disp
GROUP BY account_id
HAVING COUNT(DISTINCT client_id) > 1
ORDER BY customer_count DESC;

-- customer account relationship
SELECT
    c.client_id,
    d.account_id,
    d.type
FROM client c
JOIN disp d
    ON c.client_id = d.client_id
ORDER BY c.client_id, d.account_id;

-- customers with no account
SELECT
    c.client_id
FROM client c
LEFT JOIN disp d
    ON c.client_id = d.client_id
WHERE d.client_id IS NULL;

-- Account with no customer
SELECT
    a.account_id
FROM account a
LEFT JOIN disp d
    ON a.account_id = d.account_id
WHERE d.account_id IS NULL;
describe account;
