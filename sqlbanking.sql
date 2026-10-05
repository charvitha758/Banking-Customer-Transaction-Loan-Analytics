CREATE DATABASE banking_analytics;
USE banking_analytics;
SHOW DATABASES;
USE banking_analytics;

CREATE TABLE district (
    A1 INT PRIMARY KEY,
    A2 VARCHAR(100),
    A3 VARCHAR(50),
    A4 INT,
    A5 INT,
    A6 INT,
    A7 INT,
    A8 INT,
    A9 INT,
    A10 INT,
    A11 DECIMAL(10,2),
    A12 DECIMAL(10,2),
    A13 DECIMAL(10,2),
    A14 DECIMAL(10,2),
    A15 INT,
    A16 INT
);

CREATE TABLE client (
    client_id INT PRIMARY KEY,
    gender CHAR(1),
    birth_number INT,
    district_id INT,
    FOREIGN KEY (district_id) REFERENCES district(A1)
);

CREATE TABLE account (
    account_id INT PRIMARY KEY,
    district_id INT,
    frequency VARCHAR(50),
    date INT,
    FOREIGN KEY (district_id) REFERENCES district(A1)
);

CREATE TABLE disp (
    disp_id INT PRIMARY KEY,
    client_id INT,
    account_id INT,
    type VARCHAR(20),
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
);

CREATE TABLE card (
    card_id INT PRIMARY KEY,
    disp_id INT,
    type VARCHAR(20),
    issued INT,
    FOREIGN KEY (disp_id) REFERENCES disp(disp_id)
);

CREATE TABLE loan (
    loan_id INT PRIMARY KEY,
    account_id INT,
    date INT,
    amount DECIMAL(15,2),
    duration INT,
    payments DECIMAL(15,2),
    status VARCHAR(20),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    account_id INT,
    bank_to VARCHAR(20),
    account_to INT,
    amount DECIMAL(15,2),
    k_symbol VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
);

CREATE TABLE trans (
    trans_id INT PRIMARY KEY,
    account_id INT,
    date INT,
    type VARCHAR(30),
    operation VARCHAR(50),
    amount DECIMAL(15,2),
    balance DECIMAL(15,2),
    k_symbol VARCHAR(50),
    bank VARCHAR(20),
    account INT,
    FOREIGN KEY (account_id) REFERENCES account(account_id)
);

SHOW TABLES;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/Banking-Customer-Transaction-Loan-Analytics/data/district.csv'
INTO TABLE district
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/Banking-Customer-Transaction-Loan-Analytics/data/district.csv'
INTO TABLE district
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
TRUNCATE TABLE trans;
SELECT COUNT(*) AS total_rows FROM trans;
USE banking_analytics;

DROP TABLE IF EXISTS trans_import;

CREATE TABLE trans_import (
    trans_id VARCHAR(30),
    account_id VARCHAR(30),
    date VARCHAR(30),
    type VARCHAR(100),
    operation VARCHAR(100),
    amount VARCHAR(50),
    balance VARCHAR(50),
    k_symbol VARCHAR(100),
    bank VARCHAR(50),
    account VARCHAR(50)
    
);
SELECT COUNT(*) FROM district;
-- data cleaning for client
SELECT COUNT(*) AS null_client_id
FROM client
WHERE client_id IS NULL;

SELECT client_id, COUNT(*)
FROM client
GROUP BY client_id
HAVING COUNT(*) > 1;

SELECT *
FROM client
WHERE client_id <= 0;

SELECT *
FROM client
WHERE birth_number IS NULL
   OR birth_number <= 0;

SELECT *
FROM client
WHERE district_id <= 0;

SELECT c.*
FROM client c
LEFT JOIN district d
    ON c.district_id = d.A1
WHERE d.A1 IS NULL;

SELECT
    client_id,
    birth_number
FROM client
LIMIT 20;

SELECT
    client_id,
    birth_number
FROM client
WHERE
    birth_number IS NULL
    OR
    LENGTH(birth_number) <> 6;
    
SELECT
    client_id,
    birth_number
FROM client
WHERE
    (
        CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED) NOT BETWEEN 1 AND 12
        AND
        CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED) NOT BETWEEN 51 AND 62
    )
    OR
    CAST(SUBSTRING(birth_number, 5, 2) AS UNSIGNED) NOT BETWEEN 1 AND 31;
    
SELECT COUNT(*) AS invalid_district_references
FROM client c
LEFT JOIN district d
    ON c.district_id = d.A1
WHERE d.A1 IS NULL;

-- data cleaning for account table
SELECT
    SUM(account_id IS NULL) AS null_account_id,
    SUM(district_id IS NULL) AS null_district_id,
    SUM(frequency IS NULL) AS null_frequency,
    SUM(date IS NULL) AS null_date
FROM account;

SELECT
    account_id,
    COUNT(*) AS duplicate_count
FROM account
GROUP BY account_id
HAVING COUNT(*) > 1;

SELECT *
FROM account
WHERE account_id <= 0;

SELECT *
FROM account
WHERE district_id <= 0;

SELECT
    frequency,
    COUNT(*) AS account_count
FROM account
GROUP BY frequency;

SELECT DISTINCT frequency
FROM account;

SELECT a.*
FROM account a
LEFT JOIN district d
    ON a.district_id = d.A1
WHERE d.A1 IS NULL;

SELECT
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM account;

SELECT date
FROM account
ORDER BY date
LIMIT 20;

SELECT COUNT(*) AS invalid_account_district
FROM account a
LEFT JOIN district d
    ON a.district_id = d.A1
WHERE d.A1 IS NULL;

-- data cleaning for disp table
SELECT
    SUM(disp_id IS NULL) AS null_disp_id,
    SUM(client_id IS NULL) AS null_client_id,
    SUM(account_id IS NULL) AS null_account_id,
    SUM(type IS NULL) AS null_type
FROM disp;

SELECT
    disp_id,
    COUNT(*) AS duplicate_count
FROM disp
GROUP BY disp_id
HAVING COUNT(*) > 1;

SELECT *
FROM disp
WHERE disp_id <= 0
   OR client_id <= 0
   OR account_id <= 0;
   
SELECT
    type,
    COUNT(*) AS count
FROM disp
GROUP BY type;

SELECT DISTINCT type
FROM disp;

SELECT d.*
FROM disp d
LEFT JOIN client c
    ON d.client_id = c.client_id
WHERE c.client_id IS NULL;

SELECT d.*
FROM disp d
LEFT JOIN account a
    ON d.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS invalid_client_links
FROM disp d
LEFT JOIN client c
    ON d.client_id = c.client_id
WHERE c.client_id IS NULL;

SELECT COUNT(*) AS invalid_account_links
FROM disp d
LEFT JOIN account a
    ON d.account_id = a.account_id
WHERE a.account_id IS NULL;

-- data cleaning loan table
SELECT
    SUM(loan_id IS NULL) AS null_loan_id,
    SUM(account_id IS NULL) AS null_account_id,
    SUM(date IS NULL) AS null_date,
    SUM(amount IS NULL) AS null_amount,
    SUM(duration IS NULL) AS null_duration,
    SUM(payments IS NULL) AS null_payments,
    SUM(status IS NULL) AS null_status
FROM loan;

SELECT
    loan_id,
    COUNT(*) AS duplicate_count
FROM loan
GROUP BY loan_id
HAVING COUNT(*) > 1;

SELECT *
FROM loan
WHERE loan_id <= 0
   OR account_id <= 0;

SELECT *
FROM loan
WHERE amount <= 0;

SELECT *
FROM loan
WHERE duration <= 0;

SELECT *
FROM loan
WHERE payments <= 0;

SELECT
    status,
    COUNT(*) AS loan_count
FROM loan
GROUP BY status;

SELECT l.*
FROM loan l
LEFT JOIN account a
    ON l.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT
    MIN(date) AS earliest_loan_date,
    MAX(date) AS latest_loan_date
FROM loan;

SELECT date
FROM loan
ORDER BY date
LIMIT 20;

SELECT date
FROM loan
WHERE date IS NULL
   OR LENGTH(date) <> 6;

SELECT COUNT(*) AS invalid_loan_accounts
FROM loan l
LEFT JOIN account a
    ON l.account_id = a.account_id
WHERE a.account_id IS NULL;

-- data cleaning for card table
SELECT
    SUM(card_id IS NULL) AS null_card_id,
    SUM(disp_id IS NULL) AS null_disp_id,
    SUM(type IS NULL) AS null_type,
    SUM(issued IS NULL) AS null_issued
FROM card;

SELECT
    card_id,
    COUNT(*) AS duplicate_count
FROM card
GROUP BY card_id
HAVING COUNT(*) > 1;

SELECT *
FROM card
WHERE card_id <= 0
   OR disp_id <= 0;
   
SELECT
    type,
    COUNT(*) AS card_count
FROM card
GROUP BY type;

SELECT DISTINCT type
FROM card;

SELECT c.*
FROM card c
LEFT JOIN disp d
    ON c.disp_id = d.disp_id
WHERE d.disp_id IS NULL;

SELECT
    MIN(issued) AS earliest_issue,
    MAX(issued) AS latest_issue
FROM card;

SELECT issued
FROM card
ORDER BY issued
LIMIT 20;

SELECT COUNT(*) AS invalid_card_disp
FROM card c
LEFT JOIN disp d
    ON c.disp_id = d.disp_id
WHERE d.disp_id IS NULL;

SELECT
    SUM(order_id IS NULL) AS null_order_id,
    SUM(account_id IS NULL) AS null_account_id,
    SUM(bank_to IS NULL) AS null_bank_to,
    SUM(account_to IS NULL) AS null_account_to,
    SUM(amount IS NULL) AS null_amount,
    SUM(k_symbol IS NULL) AS null_k_symbol
FROM orders;

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM orders
WHERE order_id <= 0
   OR account_id <= 0;
   
SELECT *
FROM orders
WHERE amount <= 0;

SELECT DISTINCT bank_to
FROM orders;

SELECT
    k_symbol,
    COUNT(*) AS order_count
FROM orders
GROUP BY k_symbol;

SELECT o.*
FROM orders o
LEFT JOIN account a
    ON o.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS invalid_order_accounts
FROM orders o
LEFT JOIN account a
    ON o.account_id = a.account_id
WHERE a.account_id IS NULL;

-- data cleaning district

SELECT
    SUM(A1 IS NULL) AS null_district_id,
    SUM(A2 IS NULL) AS null_district_name,
    SUM(A3 IS NULL) AS null_region
FROM district;

SELECT
    A1,
    COUNT(*) AS duplicate_count
FROM district
GROUP BY A1
HAVING COUNT(*) > 1;

SELECT *
FROM district
WHERE A1 <= 0;

SELECT DISTINCT c.district_id
FROM client c
LEFT JOIN district d
    ON c.district_id = d.A1
WHERE d.A1 IS NULL;

SELECT DISTINCT a.district_id
FROM account a
LEFT JOIN district d
    ON a.district_id = d.A1
WHERE d.A1 IS NULL;

SELECT COUNT(*) AS invalid_client_districts
FROM client c
LEFT JOIN district d
    ON c.district_id = d.A1
WHERE d.A1 IS NULL;

SELECT COUNT(*) AS invalid_account_districts
FROM account a
LEFT JOIN district d
    ON a.district_id = d.A1
WHERE d.A1 IS NULL;

-- credit card analysis
-- total cards
SELECT
    COUNT(*) AS total_cards
FROM card;

-- cards by type
SELECT
    type,
    COUNT(*) AS card_count
FROM card
GROUP BY type
ORDER BY card_count DESC;

-- cards  by issue year
SELECT
    1900 + CAST(SUBSTRING(issued, 1, 2) AS UNSIGNED) AS issue_year,
    COUNT(*) AS card_count
FROM card
GROUP BY
    1900 + CAST(SUBSTRING(issued, 1, 2) AS UNSIGNED)
ORDER BY issue_year;

-- cards by customer
SELECT
    d.client_id,
    COUNT(DISTINCT c.card_id) AS card_count
FROM card c
JOIN disp d
    ON c.disp_id = d.disp_id
GROUP BY d.client_id
ORDER BY card_count DESC;

-- customers with multiple cards
SELECT
    d.client_id,
    COUNT(DISTINCT c.card_id) AS card_count
FROM card c
JOIN disp d
    ON c.disp_id = d.disp_id
GROUP BY d.client_id
HAVING COUNT(DISTINCT c.card_id) > 1
ORDER BY card_count DESC;

-- card type by relation type
SELECT
    c.type AS card_type,
    d.type AS relationship_type,
    COUNT(*) AS card_count
FROM card c
JOIN disp d
    ON c.disp_id = d.disp_id
GROUP BY c.type, d.type
ORDER BY card_count DESC;