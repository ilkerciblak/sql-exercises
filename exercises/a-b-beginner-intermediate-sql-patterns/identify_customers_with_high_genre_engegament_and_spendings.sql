-- High Difficulty
-- Topic: Intermediate Aggregations and Relational Reasoning
-- Identifying Customers with Diverse Genre Engagement and High Spendings
-- # Identify customers with both high spendings and interacts with broad variety of film genres.
-- # Results must include customers' identity information, total amount of spendings and number of distinct film categories 
-- they have rented from
-- # Filter the customers only spends more than $150 and have rented from more than 8 different film categories
-- # Order results by highest spendings to lowest spendings, use customers' information for tie-breaker.

-- Statement: You should count distinct film categories that each customer rented from, but sum all payments made by that customer (regardless of what category the film was from).


-- Problem Solving:
-- To analyze customers' `spendings and this spendings' corresponding film genres(a.k.a film categories)`, first we might 
-- look at payment and film_category table to investage whether there is a relation and related information
--      # Payment table has the customer (payment.customer_id), spending amount (payment.amount) and rented item (payment.rental_id) 
--        information
--   # Thus for further corelated information lets look at rental table, 
--      # Rental table has the customer (rental.customer_id), inventory item (rental.inventory_id) information that can lead us to
--        rented item information through (inventory.film_id)
--   # Investigating film_category table, we might use the distinct count of category (film_category.category_id) information to identify
--   distinct number of different film categories rented by a customer

-- So,
--      # Spendings -> payment.amount
--      # Distinct Number of Categories -> film_category.category_id
--      # Grouped By customer information

WITH customer_payments_rentals AS (
    SELECT  
        customer.customer_id AS customer_id,
        customer.first_name AS first_name,
        customer.last_name AS last_name,
        SUM(payment.amount) AS total_spendings,
        COUNT(DISTINCT(film_category.category_id)) AS distinct_rental_count
    FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
    INNER JOIN rental ON rental.rental_id = payment.rental_id
    INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
    INNER JOIN film_category ON film_category.film_id = inventory.film_id
    GROUP BY 
        customer.customer_id,
        customer.first_name,
        customer.last_name
)
SELECT
    customer_id,
    first_name,
    last_name,
    total_spendings,
    distinct_rental_count
FROM customer_payments_rentals
WHERE 
    total_spendings > 150
    AND distinct_rental_count > 8
ORDER BY 
    total_spendings DESC,
    customer_id ASC;