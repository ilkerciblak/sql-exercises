-- | LECTURE |
-- Lecture Topic: Window Functions - Running Totals
-- Window functions are especially usefull when there is a need to calculate running totals or cumulative aggregates
/*
SUM(amount) OVER (

        PARTITION BY partition_column
        ORDER BY order_column
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    
    )

*/
-- PARTITION BY ensures the total resets for each group (e.g. per customer_id)
-- ORDER BY ensures the cumulative sum builds in a logical sequence (e.g. by payment_date)
-- the frame clause ROWS BETWEEN defines the range of rows included. 
    -- PostgreSQL defaults RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW when only ORDER BY given with no clause.

-- This can allows us to build inspections like:
    -- Total spendings per customer over time.
    -- Cumulative revenue growth for each store
    -- Running inventory balance


-- |EXERCISE|
-- Medium Difficulty
-- Tracking each Customer's Spending Over Time
-- Management is curios about how each customer's spendings grows over time. They want to see, for each individual payment a customer made with
-- Payment date, customer's identification and fullname, amount of payment, and the cumulative amount that customer has spent up to that payment date,
-- in payment order.
-- Sort results as payments from the same customer will listed together, from first payment to last payment of each customer.


-- | Problem Solving |
-- Problem is about to analyzing each customer's payments and each customer's cumulative payment amount. In order to serve required informations
-- we need to join `payment` and `customer` tables relatively to customer_id.
--      Payment table has the customer information that we can use to join customer and payment table data, payment.customer_id & customer.customer_id
--      Using proper CTE approach we can increase readability of the query, CTE should include each customer's each payment in rows
--      A SUM window function paritioned by customer information and default frame clause can be used to calculate running totals of each payment amount

WITH CUSTOMERS_PAYMENTS_WITH_DATE AS (
    SELECT
        payment.payment_id AS payment_id,
        payment.payment_date AS payment_date,
        customer.customer_id AS customer_id,
        CONCAT(customer.first_name,' ', customer.last_name) AS customer_fullname,
        payment.amount AS spending_amount,
        SUM(payment.amount) OVER (PARTITION BY customer.customer_id ORDER BY payment.payment_date) AS customers_total_spendings
    FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
)
SELECT
    payment_id,
    payment_date,
    customer_id,
    customer_fullname,
    spending_amount,
    customers_total_spendings
FROM CUSTOMERS_PAYMENTS_WITH_DATE
ORDER BY customer_id ASC, payment_date ASC;