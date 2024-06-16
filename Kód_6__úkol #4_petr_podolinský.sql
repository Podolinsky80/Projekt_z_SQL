-- PROJEKT Z SQL - KÓD PRO ŘEŠENÍ ČTVRTÉHO ÚKOLU
-- Řešitel: Petr Podolinský


-- Úkol 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH FoodPriceChange AS (
    SELECT
        `year`,
        avg_price_goods_per_year,
        LAG(avg_price_goods_per_year) 
        	OVER (ORDER BY `year`) AS prev_year_price,
        (avg_price_goods_per_year - LAG(avg_price_goods_per_year) 
        	OVER (ORDER BY `year`)) / LAG(avg_price_goods_per_year) 
        		OVER (ORDER BY `year`) * 100 AS food_price_change
    FROM (
        SELECT
            `year`, 
            AVG(avg_price_goods_per_year) AS avg_price_goods_per_year
        FROM t_petr_podolinsky_project_SQL_primary_final
        WHERE goods_category_name IS NOT NULL
        GROUP BY `year`
    ) AS avg_price_per_year
),
PayrollChange AS (
    SELECT
        `year`,
        avg_all_branches_value_per_year,
        LAG(avg_all_branches_value_per_year) 
        	OVER (ORDER BY `year`) AS prev_year_payroll,
        (avg_all_branches_value_per_year - LAG(avg_all_branches_value_per_year) 
        	OVER (ORDER BY `year`)) / LAG(avg_all_branches_value_per_year) 
        		OVER (ORDER BY `year`) * 100 AS payroll_change
    FROM (
        SELECT
            `year`,
            ROUND(AVG(avg_payroll_value_per_year), 0) 
            	AS avg_all_branches_value_per_year
        FROM t_petr_podolinsky_project_SQL_primary_final
        WHERE goods_category_name IS NOT NULL
        GROUP BY `year`
    ) AS avg_payroll_per_year
)
SELECT 
    fpc.`year`, 
    fpc.food_price_change, 
    pc.payroll_change,
    abs(fpc.food_price_change - pc.payroll_change) AS abs_change_difference
FROM 
    FoodPriceChange fpc
JOIN 
    PayrollChange pc ON fpc.`year` = pc.`year`
WHERE 
    -- fpc.food_price_change > 0 
    -- AND payroll_change > 0
    abs(fpc.food_price_change - pc.payroll_change) > 10
	-- AND abs(fpc.food_price_change - pc.payroll_change) > 9
ORDER BY abs_change_difference DESC
;