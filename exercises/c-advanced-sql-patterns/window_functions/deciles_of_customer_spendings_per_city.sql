-- Advanced Window Function Exercise
-- Hard | Segmenting Customers into Deciles by City
-- Problem Description:
-- So far, we've grouped customers into quartiles globally, but businesses often want finer graanularity per region or city. In this task,
-- you'll extend the NTILE approach by ranking customers within their city into 10 equal sized buckets (deciles). This allows local store managerrs
-- to see whi their top-spendings customers are compared to peers in the same area, ratherr than globally.


WITH customer_spendings_city_cte AS 
(
    SELECT
        customer.customer_id AS customer_id,
        city.city_id AS city_id,
        CONCAT(customer.first_name, ' ', customer.last_name) AS customer_fullname,
        SUM(payment.amount) AS customer_total_spendings,
        NTILE(10) OVER (PARTITION BY city.city_id ORDER BY SUM(payment.amount) DESC) AS customer_rankings
    FROM customer
    INNER JOIN address ON address.address_id = customer.address_id
    INNER JOIN city ON city.city_id = address.city_id
    INNER JOIN payment ON payment.customer_id = customer.customer_id
    GROUP BY customer.customer_id,city.city_id
)
SELECT
    customer_id,
    city_id,
    customer_fullname,
    customer_total_spendings,
    customer_rankings
FROM customer_spendings_city_cte
ORDER BY city_id DESC
