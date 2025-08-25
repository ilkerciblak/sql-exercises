-- Lecture: Beyond Simple Lead/Lag -- Calculating Change
-- Used Lead and Lag for simple `previous/next values` in the first step. However the real analytics power comes when we use them to calculate
-- differences, growth or trends.
-- For example:
    -- Finance: Comparing this month's revenue with last month to compute growth
    -- E-commerce: Detect if a customer is spending less or more each time, a churn risk.
    -- Streaming services: Finding if a user's watch time is increasing or decreasing
-- This is where LAG/LEAD meet math:
-- ROUND( (payment.amount - LAG(payment.amount) OVER(...)) / NULLIF(LAG(payment.amount) OVER(...),0) * 100 , 2) AS growth_percent

-- Exercise: Hard Difficulty
-- Detecting Customer Spendings Trends
-- Imagine you're an analyst at the same movie rental company. Your manager says
-- I want to see if customer spendings are growing or shrinking over time. Find each customer's payment history, and calculate how much each payment
-- changed compared to the previous one, both in absolute value andd in percentage terms.
-- Hint: Handle divide-by-zero with `NULLIF` statement

-- Problem Solving
-- In order to identify `change in customer spendings`, we need to first join customer and payment data with correlated information which is
    -- payment.customer_id and customer.customer_id foreign and primary keys
-- We can use `LAG` and `LEAD` window functions to analyze previous and next data respectively.
-- In order to see difference between current and previous payment data we can use math over current and LAGged data.
-- CTE can be used to wrap customers' spendings query to increase readability of the query and extend it.

WITH customer_spendings_cte AS
(
    SELECT
        customer.customer_id AS customer_id,
        CONCAT(customer.first_name,' ',customer.last_name) AS customer_fullname,
        payment.payment_date AS payment_date,
        payment.amount AS current_payment,
        NULLIF(LAG(payment.amount) OVER(PARTITION BY payment.customer_id ORDER BY payment.payment_date ASC), 0) AS previous_payment
    FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
)
SELECT
    customer_fullname,
    payment_date,
    current_payment,
    previous_payment,
    current_payment - previous_payment AS difference,
    CONCAT(ROUND(ABS((current_payment - previous_payment)/previous_payment),2), '%') AS change_in_percentage
FROM customer_spendings_cte;
