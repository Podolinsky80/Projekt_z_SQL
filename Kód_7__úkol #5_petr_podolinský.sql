-- PROJEKT Z SQL - KÓD PRO ŘEŠENÍ PÁTÉHO ÚKOLU
-- Řešitel: Petr Podolinský


/* Úkol 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem? */

WITH Changes AS (
    SELECT 
        `year`,
        GDP_rounded_mld AS GDP_mld,
        ROUND(AVG(avg_payroll_value_per_year), 1) AS avg_payroll,
        AVG(avg_price_goods_per_year) AS avg_price_goods,
        LAG(GDP_rounded_mld) OVER (ORDER BY `year`) AS prev_GDP,
        LAG(ROUND(AVG(avg_payroll_value_per_year), 1)) 
        	OVER (ORDER BY `year`) AS prev_avg_payroll,
        LAG(AVG(avg_price_goods_per_year)) 
        	OVER (ORDER BY `year`) AS prev_avg_price_goods
    FROM t_petr_podolinsky_project_SQL_primary_final
    WHERE GDP_rounded_mld IS NOT NULL 
        AND avg_price_goods_per_year IS NOT NULL
    GROUP BY
        `year`, 
        GDP_rounded_mld
)
SELECT
    `year`,
    GDP_mld,
    round(avg_payroll) AS avg_payroll,
    round(avg_price_goods, 2) AS avg_price_goods,
    round((GDP_mld - prev_GDP) / 
    	prev_GDP * 100, 2) AS GDP_change_pct,
    round((avg_payroll - prev_avg_payroll) / 
    	prev_avg_payroll * 100, 2) AS payroll_change_pct,
    round((avg_price_goods - prev_avg_price_goods) / 
    	prev_avg_price_goods * 100, 2) AS price_goods_change_pct
FROM Changes
WHERE 	
	prev_GDP IS NOT NULL
	-- AND (GDP_mld - prev_GDP) / prev_GDP * 100 > 5
	AND `year` IN (2007, 2008, 2015, 2016, 2017, 2018)
ORDER BY
	`year`
;