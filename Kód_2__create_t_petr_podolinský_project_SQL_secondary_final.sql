-- PROJEKT Z SQL - VYTVOŘENÍ DRUHÉ ZDROJOVÉ TABULKY
-- Řešitel: Petr Podolinský


-- Smazání předchozí verze tabulky t_{jmeno}_{prijmeni}_project_SQL_secondary_final

DROP TABLE t_petr_podolinsky_project_SQL_secondary_final;


/* Vytvoření tabulky t_{jmeno}_{prijmeni}_project_SQL_secondary_final
Vybrané období: 2000-2020, přičemž z tabulky 'countries' je hodnota populace stanovena pro r. 2018
Celkem pro evropské státy za dané období: 945 záznamů */

CREATE TABLE t_petr_podolinsky_project_SQL_secondary_final AS
SELECT
    e.`year`, 
    e.country,
    round(e.GDP / 1e9, 2) AS GDP_mld,
    e.gini AS Gini_koef,
    CASE 
	    WHEN e.`year` = 2018 THEN c.population 
	    ELSE NULL 
	END AS population_mid2018
FROM economies e
LEFT JOIN countries c
    ON e.country = c.country
WHERE 
    e.`year` BETWEEN 2000 AND 2021
    AND c.continent = 'Europe'    
ORDER BY 
	e.`year`,
	e.country
;


/* Načtení dat z tabulky t_petr_podolinsky_project_SQL_secondary_final, 
která obsahuje nenulové hodnoty:
	- Giniho koeficientu pro 578 záznamů, tj. cca 61 % z 945 záznamů,
	- GDP_mld pro 882 záznamů, tj. cca 93 % z 945 záznamů;
a dále populace je uvedena pouze pro r. 2018 ve vazbě na tabulku 'countries' */:

SELECT *
FROM t_petr_podolinsky_project_SQL_secondary_final;