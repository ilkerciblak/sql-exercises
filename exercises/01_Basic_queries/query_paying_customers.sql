-- We need a list of customers who have made at least one payment. Retrieve their customer_id, first_name, last_name, and the total amount they have paid. Only include customers with a total payment amount greater than 100. Sort the results by total amount paid in descending order, and if there is a tie, sort by customer_id ascending.

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount)
FROM customer
INNER JOIN payment
ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING SUM(payment.amount) > 100
ORDER BY SUM(payment.amount) DESC, customer.customer_id ASC;
