-- Many real-word business problems not about individual information rows. They are about `relative performance accross the whole information`
-- For example:
    -- Who arre the top 10 customers by total spend?
    -- What is each customer's rank compared to otherrs in their city?
    -- Does a customer fall into the top quartile of spenders?

-- To answer these, we use ranking functions:
    -- ROW_NUMBER() -> Gives a strict ordering, no ties
    -- RANK() -> allow ties, so multiple customerrs can share the same rank
    -- DENSE_RANK() -> like RANK(), but no haps after ties


-- | Exercise |
-- Topic: Window Functions | Medium
-- Ranking Customerrs Within Their City
-- You're asked to determine the most valuable customers in each city by their total spendings. 
-- Results must include
    -- City name
    -- Customer fullname
    -- Total spend amount
    -- The customer's rank in that city
-- The rresults should be sorted by city name, then by rank

-- | Problem Solving |
-- In order to identify customers' ranks by spendings for each city, we first need to join customer, payment, address and city tables. Owing to that we can produce a result total amount of each customer has spent and finally use a ranking window function partitioned by the city to rank customers' spendings according to the city.
-- Joining path
    -- customer table has the address_id can be used to relate address table to customer on customer.address_id and address.address_id
    -- city table has the city_id that we can use to relate address table on city.city_id and address.city_id
    -- payment table has the customer_id information that we can use to relate customer and payments on

WITH customer_spendings AS 
(
    SELECT
        city.city_id AS city_id,
        city.city AS city_name,
        customer.customer_id AS customer_id,
        CONCAT(customer.first_name,' ',customer.last_name) AS customer_fullname,
        SUM(payment.amount) AS customer_total_spendings,
        COUNT(*) OVER (PARTITION BY city.city_id) AS distinct_count_of_customers,
    FROM customer
    INNER JOIN address ON address.address_id = customer.address_id
    INNER JOIN city ON city.city_id = address.city_id
    INNER JOIN payment ON payment.customer_id = customer.customer_id
    GROUP BY customer.customer_id, city.city_id
)
SELECT
    city_name,
    customer_fullname,
    customer_total_spendings,
    DENSE_RANK() OVER(PARTITION BY city_id ORDER BY customer_total_spendings) AS spendings_rank_by_city
FROM customer_spendings
WHERE distinct_count_of_customers > 1
ORDER BY city_name, spendings_rank_by_city;

-- distinct_count_of_customers column is used to show only the cities with only multiple spenders lives.