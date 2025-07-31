-- Medium Difficulty
-- Topic: Date Filtering and Aggregation
-- Analyzing Monthly Rental Activity
-- # Determine the number of rentals made in each month of the year 2022
-- # Result must represent the month name and the count of rentals of that month
-- # Sort results by month in ascending order, from January to December

SELECT 
    TO_CHAR(rental.rental_date, 'Month') as month_name,
    COUNT(*) as rental_count
FROM rental
WHERE rental.rental_date >= '2022-01-01' 
AND rental.rental_date < '2023-01-01'
GROUP BY EXTRACT(MONTH FROM  rental.rental_date), month_name
ORDER BY EXTRACT(MONTH FROM  rental.rental_date) ASC;

