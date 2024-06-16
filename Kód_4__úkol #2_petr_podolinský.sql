-- PROJEKT Z SQL - KÓD PRO ŘEŠENÍ DRUHÉHO ÚKOLU
-- Řešitel: Petr Podolinský


/* Úkol 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné 
období v dostupných datech cen a mezd? */

WITH min_max_years AS (
    SELECT 
        MIN(`year`) AS min_year,
        MAX(`year`) AS max_year
    FROM t_petr_podolinsky_project_SQL_primary_final
    WHERE goods_category_code IN (111301, 114201)
),
filtered_data AS (
    SELECT 
        `year`,
        goods_category_code,
        goods_category_name,
        branch,
        avg_payroll_value_per_year,
        avg_price_goods_per_year,
        ROUND(avg_payroll_value_per_year / avg_price_goods_per_year, 0) 
        	AS quantity_available
    FROM t_petr_podolinsky_project_SQL_primary_final
    WHERE goods_category_code IN (111301, 114201)
        AND `year` IN (SELECT min_year FROM min_max_years
                       UNION
                       SELECT max_year FROM min_max_years)
)
SELECT
    fd.goods_category_name,
    fd.branch,
    MAX(CASE 
	    WHEN fd.`year` = my.min_year THEN fd.quantity_available 
	    ELSE NULL END) AS quantity_available_2006,
    MAX(CASE 
	    WHEN fd.`year` = my.max_year THEN fd.quantity_available 
	    ELSE NULL END) AS quantity_available_2018,
	MAX(CASE 
        WHEN fd.`year` = my.max_year THEN fd.quantity_available 
        ELSE NULL END) - 
    MAX(CASE 
        WHEN fd.`year` = my.min_year THEN fd.quantity_available 
        ELSE NULL END) AS quantity_difference
FROM filtered_data fd
JOIN min_max_years my ON 1=1
GROUP BY 
    fd.goods_category_name,
    fd.branch
ORDER BY 
    fd.goods_category_name DESC,
   quantity_difference DESC
;