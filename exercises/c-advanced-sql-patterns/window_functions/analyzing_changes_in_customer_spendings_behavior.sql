-- |LECTURE|
-- While `LAG()` looks for the information in previous rows, `LEAD()` will look into upcoming rows. Using them together might allow
-- to easily compare a row with both predecessor and it succesor.
-- These window functions can be used for:
--      Detecting trends (checking some count is decreasing or increasing)
--      Highlighting fisrt/last event (When LAG() and/or LEAD() returns null)
--      Time series analysis (comparing consecutive dates)

-- | EXERCISE |
-- Management wants to better understand customer behavior by seeing whether customers are spending more or less compared to their
-- previous rental. As an member of analytics team at the DVD rental company serve a data that includes
    -- Payment information
    -- Customer information with fullname
    -- Previous payment for each customer if it exists
    -- Next payment for each customer if it exists
    -- A derived column indicating the current payment is "higher","lower" or "same" compared to the previous one.
-- List the result as the same customer's payments are together with last payment would be the last row for each customer.
-- Hint: You can use `CASE WHEN` expression to derive meaningful insights.

-- PROBLEM SOLVING
-- Problem wants us to analyze customers' payments and derive some information for each payment compared to the previous one.
-- That so we should JOIN customer and payment tables with the foreign key payment.customer_id = customer.customer_id
-- We can use LAG() and LEAD() window functions PARTITIONED BY customer_id for gathering information on previous and next payment respectively.
-- We can use `CASE WHEN THEN` expression to derive meaningfull information on insights instead of serving 1-0 as information
-- We can use `CTE` to simplify query to increase readability of the query

WITH customer_payments_cte AS 
(
    SELECT
        payment.payment_id AS payment_id,
        TO_CHAR(payment.payment_date, 'DD.MM.YYYY') AS payment_date,
        payment.amount AS payment_amount,
        customer.customer_id AS customer_id,
        CONCAT(customer.first_name, ' ', customer.last_name) AS customer_fullname,
        LAG(payment.amount) OVER (PARTITION BY customer.customer_id ORDER BY payment.payment_date) AS previous_payment,
        LEAD(payment.amount) OVER (PARTITION BY customer.customer_id ORDER BY payment.payment_date) AS next_payment
    FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
)
SELECT
    customer_id,
    customer_fullname,
    payment_id,
    payment_date,
    payment_amount AS current_payment,
    previous_payment,
    next_payment,
    CASE
        WHEN previous_payment > payment_amount THEN 'lower'
        WHEN previous_payment = payment_amount THEN 'same'
        WHEN previous_payment < payment_amount THEN 'higher'
        WHEN previous_payment IS NULL THEN 'first payment' 
    END AS payment_comparement
FROM customer_payments_cte
ORDER BY customer_id, payment_date ASC;