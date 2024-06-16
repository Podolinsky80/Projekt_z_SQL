-- PROJEKT Z SQL - KÓD PRO ŘEŠENÍ TŘETÍHO ÚKOLU
-- Řešitel: Petr Podolinský


-- Úkol 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH price_changes AS (
    SELECT 
        goods_category_name,
        `year`,
        avg_price_goods_per_year
    FROM t_petr_podolinsky_project_SQL_primary_final
    WHERE 
        goods_category_name IS NOT NULL
        AND avg_price_goods_per_year IS NOT NULL 
    GROUP BY
        goods_category_name,
        `year`
),
price_diffs AS (
    SELECT 
        goods_category_name,
        `year`,
        avg_price_goods_per_year,
        LAG(avg_price_goods_per_year) 
            OVER (PARTITION BY goods_category_name ORDER BY `year`) 
            	AS prev_avg_price_goods_per_year
    FROM price_changes
),
percentage_changes AS (
    SELECT
        goods_category_name,
        `year`,
        ((avg_price_goods_per_year - prev_avg_price_goods_per_year) / 
        prev_avg_price_goods_per_year) * 100 AS pct_change
    FROM price_diffs
    WHERE prev_avg_price_goods_per_year IS NOT NULL
)
SELECT 
    goods_category_name,
    ROUND(AVG(pct_change), 3) AS avg_annual_pct_change
FROM percentage_changes
WHERE `year` BETWEEN 2006 AND 2018
GROUP BY 
    goods_category_name
ORDER BY 
    avg_annual_pct_change ASC
;
