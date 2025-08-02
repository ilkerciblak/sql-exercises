-- Medium Difficulty
-- Topic: Basic Queries
-- Tracking Customer Activity via Rental Inventory
-- # Identify customers who have rented a broad selection of inventory items.
-- # Results must include customers' id, first name, last name and number of distinct inventory items they have been rented.
-- # Filter customers that rented more than 30 distinct inventory items
-- # Sort results by the number of inventory items rented in descending order, use customers' ids in ascending order
-- for tie-breaking information


-- Problem Solving
-- Since we're investigating `divergent number of inventory items that each customer rented` first let us look at
-- inventory and rental tables to investigate how are we connect this table to customers:
--  # Rental table is the relevant table holds both customers' and related rented inventory item information with
--      # inventory_id and customer_id
--  # Each customer is able to rent same inventory item more than once so counting rental_id will not help us
--  # Thus we should join customer and rental tables, while grouping by customers' infos and counting distinct rental.inventory_id since
-- we're investigating how many different film copies each customer interacted with, not divergence of the films or other information.
-- # Note: Inventory table items represents the phsical instances of the film table items. (possible one to many relation)

WITH inventory_customer_cte AS (
    SELECT
        customer.customer_id AS id,
        customer.first_name AS first_name,
        customer.last_name AS last_name,
        COUNT(DISTINCT(rental.inventory_id)) AS distinct_rental_count
    FROM customer
    INNER JOIN rental ON rental.customer_id = customer.customer_id
    GROUP BY customer.customer_id
) 
SELECT 
    id,
    first_name,
    last_name,
    distinct_rental_count
FROM inventory_customer_cte
WHERE distinct_rental_count > 30
ORDER BY
    distinct_rental_count DESC,
    id ASC
LIMIT 10;