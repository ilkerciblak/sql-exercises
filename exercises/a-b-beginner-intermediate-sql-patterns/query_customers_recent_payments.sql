-- Retrieve customers that who made at least one payment during the year 2006.
-- Present customer's id, first name, last name and the total number of payments done by that customer in 2006.
-- Sort the results by the number of payments in descending order, aand for customers with same number of payments, sort by customer's id 
-- in ascending order.

SELECT 
    customer.customer_id, customer.first_name, customer.last_name,
    COUNT(*) AS payment_count
FROM customer
INNER JOIN payment 
ON 
    payment.customer_id = customer.customer_id 
    AND payment.payment_date >= '2006-01-01' 
    AND payment.payment_date < '2007-01-01'
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING COUNT(*) >= 1 
ORDER BY payment_count DESC, customer.customer_id ASC;