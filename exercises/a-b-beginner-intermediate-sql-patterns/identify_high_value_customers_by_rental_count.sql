-- Medium Difficulty
-- Topic: Aggregations and Filtering with Joins
-- Identifying High Value Customers by Rental Count
-- # Find customers who have rented more than 10 films in total
-- # Result must include customer's id, first name, last name, and the total number of rentals each customer made
-- # Sort results by number of rentals in descending order, showing the most frequent renters first.

-- SELECT 
--     customer.customer_id AS id,
--     customer.first_name,
--     customer.last_name,
--     COUNT(*) as rental_count
-- FROM customer
-- INNER JOIN payment ON payment.customer_id = customer.customer_id
-- INNER JOIN rental ON rental.rental_id = payment.rental_id
-- GROUP BY customer.customer_id
-- HAVING COUNT(*) > 10
-- ORDER BY COUNT(*) DESC;

--  This join direction can work but is not typical; usually,
--  we count rentals by joining rental directly to customer via customer_id through the rental table’s foreign keys.

--  Also, counting with COUNT(*) after joining payment could lead to duplicates if a rental has
--  multiple payments (unlikely here, but good to be aware).


-- Did not noticed: rental table already has customer_id foreign key. (Developer)
-- Thus 2nd solution
SELECT 
   customer.customer_id AS id,
    customer.first_name,
    customer.last_name,
    COUNT(*) as rental_count
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING COUNT(*) > 10
ORDER BY COUNT(*) DESC;