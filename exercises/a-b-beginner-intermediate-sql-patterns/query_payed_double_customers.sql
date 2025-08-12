-- Find the number of payments made by each customer who has made more than 2 payments.
-- Show customer_id, first_name, last_name, and payment_count. 
-- Sort by payment_count descending, then customer_id ascending.

SELECT 
    customer.customer_id AS id,
    customer.first_name, customer.last_name,
    COUNT(payment.amount) AS payment_count
FROM customer
INNER JOIN payment
ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING COUNT(payment.amount) > 2
ORDER BY COUNT(payment.amount) DESC, id ASC;