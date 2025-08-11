-- Lecture: SUM(expression) OVER(..) Window Function | Running Totals and Moving Aggregates
-- What is it?
--  Unline `Group By`, `SUM() OVER()` function is a `window aggregate`. 
    -- > While GROUP BY compresses ROWS of data, window functions preserves ROWS let you calculate running totals, cumulative totals etc
    -- and more per partition.
-- Syntax
    -- SUM(expression) OVER (
    --     PARTITION BY some_column
    --     ORDER BY some_order_column
    --     [ROWS BETWEEN ...]
    -- )

-- Exercise | Medium Difficulty
-- Cumulative Spendings per Customer over Time
-- # For each customer, identify total spendings accumulate over time.
-- # In order to achive that, serve customer's identification, each payment date, amount and the total spending up to that payment including
-- that payment.
-- # Sort results customers' id information in ascending way.

-- Problem Solving
-- Problem is about analyzing customers' each payment and calculating total payment from this customer each time. Since there are identical,
-- twin payments may happened, in order to gather accurate information both rental and payment table will be used.
--      # Rental table has both usefull information to join payment and customer table,
--          # customer.customer_id and rental.customer_id will be used to join Customer and Rental tables
--          # payment.rental_id and rental.rental_id correlation will be used to join Rental and Payment tables
--      # Common Table Expression syntax will be used to simplify readability and to join relative informations
--      # SUM(payment.amount) OVER (PARTITION BY customer identification ORDER BY date information) will be used to sum payments partitoned by customers and calculating the running total.


WITH CUSTOMER_PAYMENTS_CTE AS (
    SELECT
        customer.customer_id as customer_id,
        rental.rental_id as rental_id,
        payment.payment_date as payment_date,
        payment.amount as payment_amount
    FROM customer
    INNER JOIN rental ON rental.customer_id = customer.customer_id
    INNER JOIN payment ON payment.rental_id = rental.rental_id
)
SELECT
    customer_id,
    rental_id,
    payment_date,
    payment_amount    ,
    SUM(payment_amount) OVER (PARTITION BY customer_id ORDER BY payment_date ASC)
FROM CUSTOMER_PAYMENTS_CTE
ORDER BY customer_id ASC;