SELECT * FROM PortfolioProject..merged_domestic_visitors

SELECT * FROM PortfolioProject..merged_foreign_visitors

-- List the top 10 districts that have the highest number of domestic visitors overall (2016-2019)
SELECT top 10 district, sum(visitors)
FROM PortfolioProject..merged_domestic_visitors
GROUP BY district
ORDER BY sum(visitors) desc

-- How have the number of tourists (domestic and foreign) changed for Hyderabad over 2016-2019?
SELECT sum(visitors) as total_number_of_visitors, district, year from (
SELECT district, visitors, year FROM PortfolioProject..merged_domestic_visitors
UNION ALL
SELECT district, visitors, year FROM PortfolioProject..merged_foreign_visitors) as subquery
where district = 'Hyderabad'
group by year, district

-- What are the top 3 performing districts for foreign tourism over 2016-2019?
SELECT top 3 district, sum(visitors) as total_visitor_number
FROM PortfolioProject..merged_foreign_visitors
group by district
order by sum(visitors) desc

-- What is the bottom performing district for foreign tourism over 2016-2019?
SELECT top 1 district, sum(visitors) as total_visitor_number
FROM PortfolioProject..merged_foreign_visitors
group by district
order by sum(visitors) asc

-- What are the peak and low season months for Hyderabad based on the data from 2016-2019?
SELECT sum(visitors) as total_visitors, month
FROM PortfolioProject..merged_domestic_visitors
GROUP BY MONTH
ORDER BY total_visitors desc

SELECT sum(visitors) as total_visitors, month
FROM PortfolioProject..merged_domestic_visitors
GROUP BY MONTH
ORDER BY total_visitors asc

SELECT sum(visitors) as total_visitors, month
FROM PortfolioProject..merged_foreign_visitors
GROUP BY MONTH
ORDER BY total_visitors desc

SELECT sum(visitors) as total_visitors, month
FROM PortfolioProject..merged_foreign_visitors
GROUP BY MONTH
ORDER BY total_visitors asc

-- What are the average number of visitors per year for every district (domestic and foreign combined)?
SELECT avg(visitors) as total_number_of_visitors, district, year
from (
SELECT district, visitors, year FROM PortfolioProject..merged_domestic_visitors
UNION ALL
SELECT district, visitors, year FROM PortfolioProject..merged_foreign_visitors) as subquery
group by year, district
ORDER BY year asc








