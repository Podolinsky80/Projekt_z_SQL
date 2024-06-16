-- PROJEKT Z SQL - VYTVOŘENÍ PRVNÍ ZDROJOVÉ TABULKY
-- Řešitel: Petr Podolinský


-- Smazání předchozí verze tabulky t_{jmeno}_{prijmeni}_project_SQL_primary_final

DROP TABLE t_petr_podolinsky_project_SQL_primary_final;


-- Vytvoření tabulky t_{jmeno}_{prijmeni}_project_SQL_primary_final

CREATE TABLE t_petr_podolinsky_project_SQL_primary_final AS
SELECT
    a.payroll_year AS `year`,
	a.industry_branch_code, 
    a.branch, 
    a.avg_payroll_value_per_year,
    b.goods_category_code,
    b.goods_category_name,
    b.avg_price_goods_per_year,
    c.GDP_rounded_mld
FROM (
    SELECT 
        cpr.value_type_code, 
        cpr.industry_branch_code, 
        cpib.name AS branch, 
        cpr.payroll_year,
        ROUND(AVG(cpr.value)) AS avg_payroll_value_per_year
    FROM czechia_payroll cpr
    JOIN czechia_payroll_industry_branch cpib
        ON cpr.industry_branch_code = cpib.code
    WHERE cpr.value_type_code = 5958
    GROUP BY 
        cpr.industry_branch_code,
        cpr.payroll_year
) AS a
LEFT JOIN (
    SELECT 
        cp.category_code AS goods_category_code,
        cpc.name AS goods_category_name,
        YEAR(cp.date_to) AS date_year,
        ROUND(AVG(cp.value), 2) AS avg_price_goods_per_year
    FROM czechia_price cp
    JOIN czechia_price_category cpc
        ON cp.category_code = cpc.code
    WHERE cp.region_code IS NULL
    GROUP BY 
        cp.category_code,
        YEAR(cp.date_to)
) AS b
ON a.payroll_year = b.date_year
LEFT JOIN (
	SELECT 
		e.`year`, 
		round(e.GDP / 1e9, 3) AS GDP_rounded_mld
	FROM economies e
	WHERE country = 'Czech Republic'
) AS c
ON a.payroll_year = c.`year`
ORDER BY 
    a.industry_branch_code,
    a.payroll_year
;
    
   
/* Načtení dat z tabulky t_petr_podolinsky_project_SQL_primary_final, 
která obsahuje nenulové hodnoty pro zboží (goods_category_code, goods_category_name 
a avg_price_goods_per_year) v rozmezí let 2006-2018, přičemž tabulka obsahuje celkem 6669 záznamů */:

SELECT *
FROM t_petr_podolinsky_project_sql_primary_final;