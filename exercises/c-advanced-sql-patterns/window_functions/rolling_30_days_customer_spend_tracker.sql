-- Window Functions Exercise | Hard
-- Topic: Advanced Window Functions | Moving Windows with Rows and Range
-- Tracking Customer Spendings with Rolling 30 Days

-- # You work for the analytics team of a DVD rental company. Management wants to see how much `each customer spends within any rolling 30-day` 
-- period. This means for each payment record, you should `calculate the sum of all payments made by that same customer in the 30 days leading 
-- up to and including that payment date`. The list should still `include all individual payments with their dates`, `but with an extra column 
-- showing this rolling total`.

-- You should handle cases where customers make multiple payments on the same day, ensuring they’re all counted correctly. 
-- Results should be sorted by customer_id and payment_date in ascending order.


-- Problem Solving
-- To analyze customers' spendings, problem requires to investigate over customers' payments and their rolling spendings totals for each 
-- 30 day period for each spending including that payment.
-- Also we need to serve each payment amount and date information with that extra information.
-- Despite payment table has customer related infromation to join two tables, back then there was a warning about dublicate payments. 
-- Thus rental table will be used as an intermediate table to join payment and customerr informations
--      # Rental table has customer information (rental.customer_id) that we can join rental and customer tables
--      # Payment table has rental information (payment.rental_id) that we can join payment and rental tables

WITH PAYMENT_RENTAL_CUSTOMER_CTE AS (
    SELECT
        customer.customer_id as customer_id,
        rental.rental_id as rental_id,
        payment.payment_id as payment_id,
        payment.amount as payment_amount,
        payment.payment_date as payment_date
    FROM customer
    INNER JOIN rental ON rental.customer_id = customer.customer_id
    INNER JOIN payment ON payment.rental_id = rental.rental_id
)
SELECT
    customer_id,
    rental_id,
    payment_id,
    payment_amount,
    payment_date,
    SUM(payment_amount) 
        OVER(PARTITION BY customer_id
        ORDER BY payment_date 
         RANGE BETWEEN INTERVAL '30 days' PRECEDING AND CURRENT ROW)
FROM PAYMENT_RENTAL_CUSTOMER_CTE
