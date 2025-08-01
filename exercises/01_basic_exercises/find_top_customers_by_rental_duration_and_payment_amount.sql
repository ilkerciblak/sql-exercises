-- Medium Difficulty
-- Topic: Filtering And Aggregation with Multiple Conditions
-- Finding Top Customers by Rental Duration and Payment Amount
-- # Identify customers who have rented for a total duration exceeding 1k minutes and have paid more than $200 in total
-- # Results must include customers' id, first name and last name, total rental duration and total payment amount
-- # Sort the results by total payment amounts in descending order.

 SELECT
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    ROUND(SUM(EXTRACT(EPOCH FROM (rental.return_date - rental.rental_date)) / 60)) AS rental_duration_min,
    SUM(payment.amount) AS total_payment
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
INNER JOIN rental ON rental.rental_id = payment.rental_id
GROUP BY 
    customer.customer_id,
    customer.first_name,
    customer.last_name
HAVING 
    ROUND(SUM(EXTRACT(EPOCH FROM (rental.return_date - rental.rental_date)) / 60)) > 1000
    AND SUM(payment.amount) > 200
ORDER BY total_payment DESC; 

-- USING CTE

WITH rental_cte AS (
    SELECT  
        customer.customer_id as customer_id,
        customer.first_name as first_name,
        customer.last_name as last_name,
        ROUND(SUM(EXTRACT(EPOCH FROM (rental.return_date - rental.rental_date)) / 60)) as rental_duration_min,
        SUM(payment.amount) AS total_payment
    FROM rental
    INNER JOIN customer ON customer.customer_id = rental.customer_id
    INNER JOIN payment ON payment.rental_id = rental.rental_id
    GROUP BY 
        customer.customer_id,
        customer.first_name, 
        customer.last_name 
    ORDER BY total_payment DESC
)
SELECT 
    customer_id,
    first_name,
    last_name,
    rental_duration_min,
    total_payment
FROM rental_cte
WHERE total_payment > 200 AND rental_duration_min > 1000;

