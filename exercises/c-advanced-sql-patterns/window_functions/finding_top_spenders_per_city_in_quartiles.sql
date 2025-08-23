-- Combining Aggregations and Window Functions
-- Aggregations like SUM, COUNT, AVG requires to reducing rows into grouped summaries.
-- Window functions opearte accross rows without collapsing them.
-- When combining them, you often need two steps:
    -- Aggregate the baase data to the correct granularity (e.g per customer, per store, per city)
    -- Apply window function over those aggregates (ranking, percentiles, running totals)
-- This seperation keeps your logic clean and prevents mis-aplied calculations
-- Real World Use Cases:
    -- Retail: ranking stores by sales and dividing them into tiers
    -- Finance: quartiling customers by account balances to segment "top investors"
    -- Marketing: assigning customers into deciles by lifetime spend for targeted compaigns


-- Example
-- Analyze data and identify top 3 spenders per city and assign rankings to quartiles like
    -- Top 25% spenders in Istanbul go into quartile 1
-- Sort the results as top 3 spenders (if there are) shown together with most spenders at the first row for each city triple.

-- Problem Solving
-- Problem requires to identify customers' spendings and comparing them per city. In order to achive that purpose, we should analyze total payment of each customer with their address data. 
-- Address data can be related to the city data through address.city_id field so we should:
    -- Join payment table with customer through payment.customer_id and customer.customer_id
    -- Join address table with customer through address.address_id and customer.address_id
    -- Join city table with address through city.city_id and address.city_ad
    -- Then using CTE (Common Table Expression pattern) to aggregate spendings per customer per city, this will also increase readability of the query
    -- Rank customers over their spendings per city using DENSE_RANK()
    -- Bucket customer into quartiles with NTILE(4) withing city

WITH customer_spendings AS
(
    SELECT
        CONCAT(customer.first_name, ' ',customer.last_name) AS customer_fullname,
        city.city_id AS city_id,
        city.city AS city_name,
        SUM(payment.amount) AS customer_total_spendings
    FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
    INNER JOIN address ON address.address_id = customer.address_id
    INNER JOIN city ON city.city_id = address.city_id
    GROUP BY customer.customer_id, city.city_id
)
SELECT 
    customer_fullname,
    city_name,
    customer_total_spendings,
    DENSE_RANK() OVER(PARTITION BY customer_spendings.city_id  ORDER BY customer_spendings.customer_total_spendings DESC)
    NTILE(4) OVER(PARTITION BY customer_spendings.city_id ORDER BY customer_spendings.customer_total_spendings DESC)
FROM customer_spendings
