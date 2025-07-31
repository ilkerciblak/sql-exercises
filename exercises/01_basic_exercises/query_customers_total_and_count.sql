-- Retrive each customer's `customer_id`, `fist_name`, `last_name` and `total payment amounts` and `total number of payments`.
-- Include only customers who have made more than 3 payments and whose total payment amount is greater than 200.
-- Sort results by total payment amount descending, customer id ascending

SELECT 
    customer.customer_id, customer.first_name, customer.last_name,
    SUM(payment.amount) AS total_payments, COUNT(*) AS payment_counts
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING COUNT(*) > 3 AND SUM(payment.amount) > 200
ORDER BY total_payments DESC, customer.customer_id ASC;