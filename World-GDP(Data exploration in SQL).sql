--Top 20 countries in terms of GPD in 2022.

SELECT TOP 20 *
FROM Countries_gdp
WHERE [year] = '2022'
ORDER BY GDP desc

--Top 20 countries in terms of GPD including region & income group in 2022.

SELECT TOP 20 country_name, cg.country_code, [year], GDP, region, income_group
FROM Countries_gdp cg
INNER JOIN country_codes cc
   ON cg.country_code = cc.country_code
WHERE [year] = '2022'
ORDER BY GDP desc

--Ranking of all countries in terms of GDP in 2022

SELECT country_name, country_code, [year], CAST(GDP as bigint) as GDP
, RANK() OVER(ORDER BY GDP desc) as Ranking
FROM Countries_gdp
WHERE [year] = '2022'



--Number of countries per income group in 2022

SELECT income_group, [year], COUNT(income_group) as Countries
FROM country_codes cc
INNER JOIN Countries_gdp cg
   ON cc.country_code = cg.country_code
WHERE [year] = '2022'
GROUP BY income_group, [year]

-- GDP percantage by country (2022) **CTE**

WITH GDP_Percentage_By_Country (country_name, [year], GDP, income_group, Sum_of_all_countries_GDP)
as
(
SELECT country_name, [year], GDP, income_group
,SUM(GDP) OVER(ORDER BY [year]) as Sum_of_all_countries_GDP
FROM Countries_gdp cg
Inner join country_codes cc
   ON cg.country_code = cc.country_code
WHERE [year] = '2022'
)
SELECT *, GDP / Sum_of_all_countries_GDP * 100 as Percentage_of_total_GDP
FROM GDP_Percentage_By_Country
ORDER BY GDP desc


-- GDP percentage by country (2022) **TEMP TABLE**

DROP TABLE IF exists #CountriesPercentageGDP
CREATE TABLE #CountriesPercentageGDP
(
country_name nvarchar(255),
[year] float,
GDP float,
income_group nvarchar(255),
Sum_of_all_countries_GDP float
)

INSERT INTO #CountriesPercentageGDP
SELECT cg.country_name, cg.[year], cg.GDP, cc.income_group
, SUM(cg.GDP) OVER(ORDER BY cg.[year]) as Sum_of_all_countries_GDP
FROM Countries_gdp cg
Inner Join country_codes cc
   ON cg.country_code = cc.country_code
WHERE cg.[year] = '2022'

SELECT *, CAST(GDP / Sum_of_all_countries_GDP * 100 as decimal(10, 6)) as Percentage_of_total_GDP
FROM #CountriesPercentageGDP
ORDER BY GDP desc

--Create View for: Top 20 countries in terms of GPD including region & income group in 2022.

CREATE VIEW Top20Countries as
SELECT TOP 20 country_name, cg.country_code, [year], GDP, region, income_group
FROM Countries_gdp cg
INNER JOIN country_codes cc
   ON cg.country_code = cc.country_code
WHERE [year] = '2022'
ORDER BY GDP desc

--Create View for: Ranking of all countries in terms of GDP in 2022

CREATE VIEW CountriesRank as
SELECT country_name, country_code, [year], CAST(GDP as bigint) as GDP
, RANK() OVER(ORDER BY GDP desc) as Ranking
FROM Countries_gdp
WHERE [year] = '2022'


--Create View for: Number of countries per income group in 2022

CREATE VIEW CountriesPerIncomeGroup as
SELECT income_group, [year], COUNT(income_group) as Countries
FROM country_codes cc
INNER JOIN Countries_gdp cg
   ON cc.country_code = cg.country_code
WHERE [year] = '2022'
GROUP BY income_group, [year]


--Create View for: GDP percentage by country (2022) **TEMP TABLE**

CREATE View CountriesPercentageGDP as
SELECT cg.country_name, cg.[year], cg.GDP, cc.income_group
, SUM(cg.GDP) OVER(ORDER BY cg.[year]) as Sum_of_all_countries_GDP
FROM Countries_gdp cg
INNER Join country_codes cc
   ON cg.country_code = cc.country_code
WHERE [year] = '2022'





