-- | LECTURE |
-- Lecture Topic: Window Functions - Accessing Previous and Next Rows
-- Window Functions like `LAG() and LEAD()` allows to access data from `previous and next rows` in partition without writing complex self-joins. 
    --  LAG(column, offset, default) -> looks backwards by the given offset
    --  LEAD(column, offset, default) -> looks forward
-- These functions are often used to:
    -- Compare a row's value to the previous one (e.g. difference in daily sales)
    -- Detect changes in state(e.g. when a customer switches subscription plans)
    -- Track trends (e.g. increasing vs decreasing amounts)

-- | EXERCISE |
-- Management suspects that some customers make long breaks between their payments. They've asked you to prepare a report that shows
    -- Payment information
    -- Customer information
    -- payment amount
    -- The previous payment date by that same customer if exists
    -- The number of days since the previous payment
-- Show the results as customer's payments are together with latest payment is in the latest row.

-- | Problem Solving |
-- Since the problem requires to analyze payments of customers' we need to somehow join customer and payment information.
-- Payment table has the payment.customer_id field that we can join customer table with it.
-- Using LAG(payment.payment_date) will give us the last payment date if it is exists
-- Finally we can substract the lagged value from current payment date to find the number of days after the last payment
-- We can use CTE to simplify last query in order to incrase readability of the query

WITH customer_payments_with_date AS 
(
    SELECT
        payment.payment_id AS payment_id,
        payment.payment_date AS payment_date,
        customer.customer_id AS customer_id,
        CONCAT(customer.first_name, ' ', customer.last_name) AS customer_fullname,
        payment.amount AS spendings_amount,
        LAG(payment.payment_date, 1, NULL) OVER (PARTITION BY customer.customer_id ORDER BY payment.payment_date ASC) AS previous_payment_date
    FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
)
SELECT
    payment_id,
    payment_date,
    customer_id,
    customer_fullname,
    spendings_amount,
    previous_payment_date,
    EXTRACT(day from  payment_date - previous_payment_date) AS number_of_days
FROM customer_payments_with_date
ORDER BY customer_id, payment_date;