
-- Lecture Topic: Window Functions
-- In SQL, window functions are a powerful feature that allow to perform calculations across a set of rows that are related to `current row`
-- without collapsing them into a single aggregated result unlike `Group By`

-- Core Syntax
/*
function_name(expression) OVER (
    [PARTITION BY column]
    [ORDER BY column]
    [frame_clause]
)
*/
--  PARTITION BY: divides the result set into seperate `windows` based on one or more columns
--  ORDER BY: defines the order in which the function is applied within each partition
--  frame_clause(s): like ROWS BETWEEN or RANGE BETWEEN further define which rows are considered in the calculation


-- Exercise | Medium Difficulty
-- Ranking Staff by Total Sales Per Store
-- Management wants to know how each staff member is performing comparred to others in the same store. 
-- They’ve asked you to prepare a report that:
--      Shows each staff member’s ID, full name, and store ID.
--      Calculates the total sales amount handled by each staff member.
--      Ranks them within their store so the top seller has rank 1.
--      Keeps all staff members in the list — even if there are ties in sales.
-- Also, if two staff members in the same store made the same total sales, they should share the same rank, 
-- and the next rank should be skipped (just like in competition rankings).

-- Sort results in the report as same store members will be listed together with better ranks in top of each chunk.


-- Problem Solving
-- Problem requires to analyze payments that related to each staff, and comparing total payments that logged to each staff. That so we can
--      Join payment table and staff table to analyze total payments forr each staff on payment.staff_id and staff.staff_id
--      Use Common Table Expressions to obtain prevent complexity
--      Partitate data over Store identifications

WITH staff_sales_cte AS (
    SELECT
        staff.staff_id as staff_id,
        CONCAT(staff.first_name,' ',staff.last_name) as full_name,
        staff.store_id as store_id,
        SUM(payment.amount) as total_sales
    FROM staff
    INNER JOIN payment ON payment.staff_id = staff.staff_id
    GROUP BY staff.staff_id
)
SELECT 
    staff_id,
    full_name,
    store_id,
    total_sales,
    RANK() OVER(PARTITION BY store_id ORDER BY total_sales DESC) AS store_rank
FROM staff_sales_cte
ORDER BY store_id, store_rank ASC;