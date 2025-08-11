-- Medium Difficulty
-- Topic: Aggregations, Filtering And Relational Reasoning
-- Analyzing Customers' Spendings on Each Distinct Categories
-- # Retrieve and serve information about each customers' spendings on each distinct film category.
-- # Results must include customers' identity information, each customer's total amount of spendings, total number of distinct category renting of each customer, total amount of each customer's spendings on each distinct film category with category names.
-- # Filter the customers only spends more than $150 and have rented from more than 4 different categories
-- # Order results by highest total spendings to lowest spendings, use customers' information for tie-breaker.


-- Problem Solving:
-- Problem requires to analyze `customers spendings over dinstinct categories` we might need to investigate how to relate 
-- customer information, payment information and film_category information together.
--      # Rental table has customer (rental.customer_id), rented item information (rental.inventory_id) that we can relate to customer and inventory tables
--      # Inventory table has film instance information (inventory.film_id) that we can relate to film_category table to get film category (film_category.category_id) information for each instance
--      # Relating category table with film_category table through category_id information in both table we can gather distinct category names.
--      # Relating Payment table and Rental tables through payment.rental_id and rental.rental_id we can compute spendings with the amount (payment.amount) information



-- WITH cte AS (
--     SELECT
--         category.category_id as category_id,
--         payment.customer_id as customer_id,
--         category.name as category_name,
--         SUM(payment.amount) as category_payment_per_customer
--         -- string_agg(category)
--     FROM category
--     LEFT JOIN film_category ON film_category.category_id = category.category_id
--     INNER JOIN inventory on inventory.film_id = film_category.film_id
--     INNER JOIN rental on rental.inventory_id = inventory.inventory_id
--     INNER JOIN payment on payment.rental_id = rental.rental_id
--     GROUP BY category.category_id, category.name,payment.customer_id
-- )
-- SELECT 

WITH cte AS (
        SELECT
        payment.customer_id as customer_id,
        string_agg(DISTINCT(category.name), ' ,') as category_name,
        SUM(payment.amount) as category_payment_per_customer
    FROM category
    LEFT JOIN film_category ON film_category.category_id = category.category_id
    INNER JOIN inventory on inventory.film_id = film_category.film_id
    INNER JOIN rental on rental.inventory_id = inventory.inventory_id
    INNER JOIN payment on payment.rental_id = rental.rental_id
    GROUP BY 1
)
    SELECT *
    FROM crosstab(
        'SELECT
        payment.customer_id as customer_id,
        string_agg(DISTINCT(category.name), ' ,') as category_name,
        SUM(payment.amount) as category_payment_per_customer
    FROM category
    LEFT JOIN film_category ON film_category.category_id = category.category_id
    INNER JOIN inventory on inventory.film_id = film_category.film_id
    INNER JOIN rental on rental.inventory_id = inventory.inventory_id
    INNER JOIN payment on payment.rental_id = rental.rental_id
    GROUP BY 1'
    ) AS ct ("customer_id" integer)