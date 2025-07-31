-- Calculate the average payment amount per customer for who paid more than 50 in total.
-- Show `customer_id`, `first_name`, `last_name`, and `avg_payment`. 
-- Sort by `avg_payment` descending

SELECT
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    AVG(payment.amount) AS avg_payment
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING SUM(payment.amount) > 50
ORDER BY avg_payment DESC;