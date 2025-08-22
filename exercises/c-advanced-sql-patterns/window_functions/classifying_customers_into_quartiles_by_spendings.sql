-- | LECTURE |
-- Percentile Rankings with `NTILE()`
-- SQL `NTILE()` function is a window function that distributes rows of an ordered partition into a pre-defined number of roughly equal groups.
-- It assigns each group a `number_expression` ranging from one. NTILE() function assigns a number_expression for every row in a group, 
-- to which the row belongs.
-- Syntax: -------------------------------
/*
NTILE(number_expression) OVER( [PARTITION BY partition_expression] ORDER BY sort_expression [ASC | DESC])
*/
-- Parameters: ----------------------------
-- number_expression: The number_expression is the integer into which the rows are divided.
-- PARTITION BY clause: The PARTITION BY is optional here, it differs the rows of a result set into partitions where the NTILE() function is used.
-- ORDER BY clause: The ORDER BY clause defines the order of rows in each partition where the NTILE() is used.
-- /
-- When a number of rows are not divisible by the number_expression, the NTILE() function results the groups of two sizes with a difference by one.
-- The larger groups come ahead of the smaller group within the order specified by the ORDER BY within the OVER() clause. Also, when the all of
-- rows are divisible by the number_expression, the function divides evenly the rows among number_expression.
-- /
-- Use cases:
-- "Who are our top 25% of customers by spend?"
-- "Which city's customers fall into the bottom 10% of payments?"

-- EXERCISE
-- Classifying Customers into Quartiles by Spending (Medium)
-- Classify customers into four quartiles based on their total spendings accross all payments. The business wants to know who belongs in the
-- top 25%, second 25%, third 25% and bottom 25% of all customers globally. Serve relevant data, sort on classyfied customers spendings quartile.

-- Hint:
-- To solve this problem you might:
-- First aggregate spendings per customer
-- Then apply `NTILE` ordered by total spendings descending

-- Problem Solving
-- In order to serve payment and customer inforrmation, first we need to join payment and customer tables.
-- Payment table has payment.customer_id field that we can use to relate with customer.customer_id
-- After that we can divide data on each customer's total spendings with NTILE ordered in descending
-- Common Table Expression would be used to increase readability.

WITH customer_payments_cte AS 
(
    SELECT
        customer.customer_id AS customer_id,
        CONCAT(customer.first_name, ' ', customer.last_name) AS customer_fullname,
        SUM(payment.amount) AS customer_total_spendings,
        NTILE(4) OVER(ORDER BY SUM(payment.amount) DESC) AS customer_spendings_quartile
    FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
    GROUP BY customer.customer_id
)
SELECT 
    customer_id,
    customer_fullname,
    customer_total_spendings,
    customer_spendings_quartile
FROM customer_payments_cte;