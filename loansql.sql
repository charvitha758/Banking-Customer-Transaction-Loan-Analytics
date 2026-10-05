-- total loans
SELECT
    COUNT(*) AS total_loans
FROM loan;
-- total, avg, min, max loan amount
SELECT
    SUM(amount) AS total_loan_amount,
    ROUND(AVG(amount), 2) AS avg_loan_amount,
    MIN(amount) AS min_loan_amount,
    MAX(amount) AS max_loan_amount
FROM loan;
-- loan status analysis
SELECT
    status,
    COUNT(*) AS loan_count,
    SUM(amount) AS total_loan_amount,
    ROUND(AVG(amount), 2) AS avg_loan_amount
FROM loan
GROUP BY status
ORDER BY loan_count DESC;

-- loan duration analysis
SELECT
    duration,
    COUNT(*) AS loan_count,
    SUM(amount) AS total_loan_amount,
    ROUND(AVG(amount), 2) AS avg_loan_amount
FROM loan
GROUP BY duration
ORDER BY duration;

-- loan amount vs monthly payment
SELECT
    loan_id,
    account_id,
    amount AS loan_amount,
    payments AS monthly_payment,
    duration,
    status
FROM loan
ORDER BY amount DESC;

-- loan by year
SELECT
    1900 + CAST(SUBSTRING(date, 1, 2) AS UNSIGNED) AS loan_year,
    COUNT(*) AS loan_count,
    SUM(amount) AS total_loan_amount
FROM loan
GROUP BY
    1900 + CAST(SUBSTRING(date, 1, 2) AS UNSIGNED)
ORDER BY loan_year;

-- customer level loan analysis
SELECT
    d.client_id,
    COUNT(DISTINCT l.loan_id) AS loan_count,
    SUM(l.amount) AS total_loan_amount,
    ROUND(AVG(l.amount), 2) AS avg_loan_amount
FROM disp d
JOIN loan l
    ON d.account_id = l.account_id
GROUP BY d.client_id
ORDER BY total_loan_amount DESC;

-- district-level loan analysis
SELECT
    a.district_id AS district_id,
    COUNT(DISTINCT l.loan_id) AS loan_count,
    SUM(l.amount) AS total_loan_amount,
    ROUND(AVG(l.amount), 2) AS avg_loan_amount
FROM account a
JOIN loan l
    ON a.account_id = l.account_id
GROUP BY a.district_id
ORDER BY total_loan_amount DESC;card


