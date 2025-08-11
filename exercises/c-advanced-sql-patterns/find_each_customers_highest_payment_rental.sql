-- Medium Difficulty
-- Topic: Window Functions
-- Finding Top Spendings Rental for each Customer
-- # Identify each customer's highest costing rental and the amount of spendings on that rental.
-- # Results must include customers' identity information, payments' id, spending amount and rental id


-- Problem Solving
-- Problem is about analyzing payments of each customer on rentals and identifying each customers' highest spending on rentals. 
-- Thus we need to join payment, rental and customer tables to analyze spendings and supply information together.
--      # Rental table has customer (rental.customer_id) information that we can interact customer and rental information together
--      # Payment taable has rental (payment.rental_id) inforrmation that we can interact payment and rental information together
--      # CTE can be used to query complex information for rental, payment and customer. 
--      # Payments' amount for each customers' should be ranked, those ranks can be filtered to serve highest ranked payments.



WITH PAYMENT_RENTAL_CTE AS (
    SELECT
    customer.customer_id as customerid,
    customer.first_name as firstname,
    customer.last_name as lastname,
    payment.payment_id as payment_id,
    payment.amount as spending_amount,
    rental.rental_id as rental_id,
    ROW_NUMBER() OVER (PARTITION BY customer.customer_id ORDER BY payment.amount DESC) as payment_order
    FROM customer
    INNER JOIN rental ON rental.customer_id = customer.customer_id
    INNER JOIN payment ON payment.rental_id = rental.rental_id
)
SELECT
    customerid,
    firstname,
    lastname,
    payment_id,
    spending_amount,
    rental_id,
    payment_order
FROM PAYMENT_RENTAL_CTE
WHERE payment_order = 1;











