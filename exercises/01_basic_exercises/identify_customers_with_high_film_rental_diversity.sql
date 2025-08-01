-- Medium Difficulty
-- Topic: Aggregations and Filtering with Joins
-- Identifying Customers with High Film Rental Diversity
-- # Identify customers who have rented films more than 10 different categories
-- # Results must include customers' id, first name, last name, and number of distinct categories they have rented from
-- # Results must be sorted by customers' distinct count of rented categories with the largest at top, if any similarities happens, 
-- sort by customers' ids in ascending order

WITH CATEGORY_CTE AS (
    SELECT
        customer.customer_id AS customer_id,
        customer.first_name AS first_name,
        customer.last_name AS last_name,
        COUNT(DISTINCT(film_category.category_id)) AS category_count
    FROM customer
    INNER JOIN rental ON rental.customer_id = customer.customer_id
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
    category_count
FROM CATEGORY_CTE
WHERE category_count > 10
ORDER BY category_count DESC, customer_id ASC;