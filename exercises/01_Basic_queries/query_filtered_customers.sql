-- name: Querying filtered customers
SELECT customer_id, first_name, last_name, email
FROM customer
WHERE create_date > '2005-01-01'
ORDER BY customer_id ASC;