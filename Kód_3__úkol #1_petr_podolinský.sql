-- PROJEKT Z SQL - KÓD PRO ŘEŠENÍ PRVNÍHO ÚKOLU
-- Řešitel: Petr Podolinský


-- Úkol 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH AvgSalaries AS (
	SELECT DISTINCT
    	t1.`year`,
    	t1.industry_branch_code,
    	t1.branch,
    	t2.avg_payroll_value_per_year AS avg_payroll_value_per_year_minus_1,
    	t1.avg_payroll_value_per_year,
    	CASE 
        	WHEN t2.avg_payroll_value_per_year > t1.avg_payroll_value_per_year THEN 0
        	ELSE 1
    	END AS is_increasing_payroll
	FROM t_petr_podolinsky_project_sql_primary_final t1
	LEFT JOIN t_petr_podolinsky_project_sql_primary_final t2
    	ON t1.industry_branch_code = t2.industry_branch_code
    	AND t1.branch = t2.branch
    	AND t1.`year` = t2.`year` + 1
	WHERE t2.avg_payroll_value_per_year IS NOT NULL
	ORDER BY
    	t1.industry_branch_code,
   		t1.`year`)   	
SELECT
    industry_branch_code,
    branch,
    sum(is_increasing_payroll) AS count_of_yearly_increase,
    round((sum(is_increasing_payroll) * 100) / 21, 2) 
    	AS pct_growth_periods_y2001_to_2021,
    round(avg(avg_payroll_value_per_year - avg_payroll_value_per_year_minus_1), 0) 
    	AS avg_yearly_payroll_change
FROM AvgSalaries
GROUP BY
    industry_branch_code,
    branch
ORDER BY 
    -- count_of_yearly_increase DESC,
   	avg_yearly_payroll_change DESC
;