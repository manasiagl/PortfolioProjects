SELECT * FROM PortfolioProject..merged_domestic_visitors

SELECT * FROM PortfolioProject..merged_foreign_visitors

-- List the top 10 districts that have the highest number of domestic visitors overall (2016-2019)
SELECT top 10 district, sum(visitors) as total_number_of_domestic_visitors
FROM PortfolioProject..merged_domestic_visitors
group by district
ORDER BY total_number_of_domestic_visitors desc

-- List the top 10 districts that have the highest number of foreign visitors overall (2016-2019)
SELECT top 10 district, sum(visitors) as total_number_of_foreign_visitors
FROM PortfolioProject..merged_foreign_visitors
group by district
ORDER BY total_number_of_foreign_visitors desc

-- How have the number of tourists (domestic and foreign) changed for Hyderabad over 2016-2019?
SELECT sum(visitors) as total_number_of_visitors, district, year from (
SELECT district, visitors, year FROM PortfolioProject..merged_domestic_visitors
UNION ALL
SELECT district, visitors, year FROM PortfolioProject..merged_foreign_visitors) as subquery
where district = 'Hyderabad'
group by year, district

-- What are the peak and low seasons for Hyderabad based on the data from 2016-2019?
SELECT sum(visitors) as total_number_of_visitors, district, month from (
SELECT month, visitors, district FROM PortfolioProject..merged_domestic_visitors
UNION ALL
SELECT month, visitors, district FROM PortfolioProject..merged_foreign_visitors) as subquery
where district = 'Hyderabad'
GROUP BY month, district
ORDER BY total_number_of_visitors desc

-- Create a ranking of the top  3 districts based on the number of visitors they receive (domestic and foreign combined)
WITH combined_tourism AS (
SELECT district, date, month, year, visitors
from PortfolioProject..merged_domestic_visitors
UNION ALL
SELECT district, date, month, year, visitors
FROM PortfolioProject..merged_foreign_visitors ),
district_ranking AS (
SELECT 
district,
sum(visitors) as total_visitors,
DENSE_RANK() OVER(ORDER BY sum(visitors) DESC) as district_rank
FROM combined_tourism
GROUP BY district )
SELECT district, total_visitors, district_rank
FROM district_ranking
WHERE district_rank <= 3
ORDER BY district_rank

-- Create a ranking of the bottom 3 districts based on the number of visitors they receive (domestic and foreign combined)
WITH combined_tourism AS (
SELECT district, date, month, year, visitors
from PortfolioProject..merged_domestic_visitors
UNION ALL
SELECT district, date, month, year, visitors
FROM PortfolioProject..merged_foreign_visitors ),
district_ranking AS (
SELECT 
district,
sum(visitors) as total_visitors,
DENSE_RANK() OVER(ORDER BY sum(visitors) ASC) as district_rank
FROM combined_tourism
GROUP BY district )
SELECT district, total_visitors, district_rank
FROM district_ranking
ORDER BY district_rank

-- Combine data from domestic and foreign tourism
SELECT district, year, month, date, visitors
INTO comb_data
from PortfolioProject..merged_domestic_visitors
UNION ALL
SELECT district, year, month, date, visitors
FROM PortfolioProject..merged_foreign_visitors

SELECT * FROM comb_data

-- Calculate the running total of visitors (domestic and foreign) to each district in Telangana for every month and year?
SELECT month, year, district,
SUM(visitors) OVER(PARTITION BY district ORDER BY year)
FROM comb_data

-- Find the difference in tourist numbers for each year (2016-2019) for each district in Telangana.
SELECT year, district, visitors as previous_number_of_visitors,
LAG(visitors) OVER(ORDER BY YEAR) AS current_number_of_visitors,
visitors - LAG(visitors) OVER (ORDER BY year) AS difference_from_previous_year
FROM (
SELECT year, district, visitors
from comb_data
) AS subquery
ORDER BY difference_from_previous_year desc

-- Show the total number of domestic visitors to each district, per month for every year:
SELECT month, year, district, visitors,
sum(visitors) OVER(PARTITION BY district) AS total_domestic_visitors_by_district
from PortfolioProject..merged_domestic_visitors

-- Show the total number of foreign visitors to each district, per month for every year:
SELECT month, year, district, visitors,
sum(visitors) OVER(PARTITION BY district) AS total_foreign_visitors_by_district
from PortfolioProject..merged_foreign_visitors





