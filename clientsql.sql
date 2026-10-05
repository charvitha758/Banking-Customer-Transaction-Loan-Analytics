-- number of customers
SELECT COUNT(*) AS total_customers
FROM client;

-- unique customers
SELECT COUNT(DISTINCT client_id) AS unique_customers
FROM client;

-- customers by gender

SELECT
    gender,
    COUNT(*) AS customer_count
FROM client
GROUP BY gender;

-- gender from birth number
SELECT
    CASE
        WHEN CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED) BETWEEN 51 AND 62
            THEN 'Female'
        ELSE 'Male'
    END AS gender,
    COUNT(*) AS customer_count
FROM client
GROUP BY
    CASE
        WHEN CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED) BETWEEN 51 AND 62
            THEN 'Female'
        ELSE 'Male'
    END;
    
-- gender percentage
SELECT 
    CASE 
        WHEN CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED) BETWEEN 51 AND 62 
            THEN 'Female' 
        ELSE 'Male' 
    END AS gender, 
    
    COUNT(*) AS customer_count, 
    
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM client),
        2
    ) AS percentage

FROM client

GROUP BY 
    CASE 
        WHEN CAST(SUBSTRING(birth_number, 3, 2) AS UNSIGNED) BETWEEN 51 AND 62 
            THEN 'Female' 
        ELSE 'Male' 
    END;
    
-- customers by age group
SELECT
    CASE
        WHEN (1999 - (1900 + CAST(SUBSTRING(birth_number, 1, 2) AS UNSIGNED))) < 20
            THEN 'Under 20'

        WHEN (1999 - (1900 + CAST(SUBSTRING(birth_number, 1, 2) AS UNSIGNED))) BETWEEN 20 AND 29
            THEN '20-29'

        WHEN (1999 - (1900 + CAST(SUBSTRING(birth_number, 1, 2) AS UNSIGNED))) BETWEEN 30 AND 39
            THEN '30-39'

        WHEN (1999 - (1900 + CAST(SUBSTRING(birth_number, 1, 2) AS UNSIGNED))) BETWEEN 40 AND 49
            THEN '40-49'

        ELSE '50+'
    END AS age_group,
    COUNT(*) AS customer_count
FROM client
GROUP BY age_group
ORDER BY age_group;

-- customers by district
SELECT
    d.A1 AS district_id,
    d.A2 AS district_name,
    COUNT(*) AS customer_count
FROM client c
JOIN district d
    ON c.district_id = d.A1
GROUP BY
    d.A1,
    d.A2
ORDER BY customer_count DESC;

-- top 10 districts by customer count
SELECT
    d.A1 AS district_id,
    d.A2 AS district_name,
    COUNT(*) AS customer_count
FROM client c
JOIN district d
    ON c.district_id = d.A1
GROUP BY
    d.A1,
    d.A2
ORDER BY customer_count DESC
LIMIT 10;

-- cutomer per district as percentage
SELECT
    d.A2 AS district_name,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM client),
        2
    ) AS customer_percentage
FROM client c
JOIN district d
    ON c.district_id = d.A1
GROUP BY d.A2
ORDER BY customer_count DESC;