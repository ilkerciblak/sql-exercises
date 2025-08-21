-- Window functions like RANK() or DENSE_RANK() or ROW_NUMBER() allows to give orderal information based on some column data with little differences.
-- That is powerfull, however problem might need some specific filtering and does not want whole ranking list.

-- Exercise | Medium - Hard
-- Management wants to see the top 3 customer based on their spendings for each city.
-- The output should present city, customer with fullname, customer's total spendings and their ranks by city.
-- CHALLENGE: Window Functions do not work with a `WHERE` clause directly, because they're applied after aggregation but before filtering. 
-- HINT: In order to jump this obsticle we can wrap our central query in a CTE or subquery, then filter the information.

WITH customer_spendings_cte AS 
(
    SELECT
        city.city_id AS city_id,
        city.city AS city_name,
        customer.customer_id AS customer_id,
        CONCAT(customer.first_name,' ',customer.last_name ) AS customer_fullname,
        SUM(payment.amount) AS customer_total_spendings,
        DENSE_RANK() OVER(PARTITION BY city.city_id ORDER BY SUM(payment.amount) DESC) AS customer_ranking
    FROM customer
    INNER JOIN address ON address.address_id = customer.address_id
    INNER JOIN city ON city.city_id = address.city_id
    INNER JOIN payment ON payment.customer_id = customer.customer_id
    GROUP BY city.city_id, customer.customer_id
)
SELECT
    city_id,
    city_name,
    customer_id,
    customer_fullname,
    customer_total_spendings,
    customer_ranking
FROM customer_spendings_cte
WHERE customer_ranking <= 3;