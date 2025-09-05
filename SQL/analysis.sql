-- analysis.sql
-- contains SQL queries to explore the 311 service request data
-- run this after schema and load_data

-------------------------------------------
-- OVERVIEW / TRENDS IN REQUESTS OVER TIME
-------------------------------------------
-- Total number of 311 calls, 2015-2024
SELECT count(*) from calls_all;

-- Annual number of 311 calls, 2015-2024
SELECT year, count(*)
FROM calls_all
GROUP BY year;

-- Percent change in number of calls, 2015–2024
SELECT 
    (1.0 * SUM(CASE WHEN year = 2024 THEN 1 END) - 
	    SUM(CASE WHEN year = 2015 THEN 1 END)) /
		SUM(CASE WHEN year = 2015 THEN 1 END)
	AS perc_change_in_calls
FROM calls_all;

-- Percent change in Boston population, 2015 - 2024 
-- (to check if calls increased b/c population increased)
SELECT 
    (1.0 * SUM(CASE WHEN year = 2024 THEN population_boston END) -
    SUM(CASE WHEN year = 2015 THEN population_boston END)) /
	SUM(CASE WHEN year = 2015 THEN population_boston END) AS perc_change_in_population
FROM boston_pop;

-- Weekly trends in 311 counts 
-- Note: all weeks contain 7 days, except for week 53, which is irregular
Select
    year,
    FLOOR((EXTRACT(DOY FROM open_dt) - 1) / 7) + 1 AS week_index, -- put each week into a 7 day bucket
    MIN(open_dt::date) AS week_start, -- this represents the first day of each 7-week bucket                            
    COUNT(*) AS total_cases
From calls_all
Group by year, week_index
Order by year, week_index;

-------------------------------------------
-- TRENDS BY DEPARTMENTS
-------------------------------------------

-- Monthly counts by department
SELECT 
    year, 
	EXTRACT(MONTH FROM open_dt) AS month,
    DATE_TRUNC('month', open_dt)::date AS year_month,
	department,
	COUNT(*) AS total_cases
FROM calls_all
GROUP BY year, month, year_month, department
ORDER BY year, month, year_month, total_cases desc;

-- Top departments in each year, 2015 to 2024, pivoted with each year as a column
SELECT 
	rank,
	MAX(CASE WHEN year = 2015 then department end) as year_2015,
	MAX(CASE WHEN year = 2016 then department end) as year_2016,
	MAX(CASE WHEN year = 2017 then department end) as year_2017,
	MAX(CASE WHEN year = 2018 then department end) as year_2018,
	MAX(CASE WHEN year = 2019 then department end) as year_2019,
	MAX(CASE WHEN year = 2020 then department end) as year_2020,
	MAX(CASE WHEN year = 2021 then department end) as year_2021,
	MAX(CASE WHEN year = 2022 then department end) as year_2022,
	MAX(CASE WHEN year = 2023 then department end) as year_2023,
	MAX(CASE WHEN year = 2024 then department end)  as year_2024
FROM
	(SELECT 
		year, 
		department, 
		COUNT(*) AS total_cases, 
		rank() OVER (partition by year order by COUNT(*) desc) as rank
	FROM calls_all
	GROUP BY year, department
	ORDER BY year, rank) subquery
WHERE rank <= 10
GROUP BY rank
ORDER BY rank;

-- Departments that have seen largest increase, 2015 to 2024 
-- (both growth in raw numbers and % growth)
SELECT 
    department,
    COUNT(*) FILTER (WHERE year = 2015) AS cases_2015,
    COUNT(*) FILTER (WHERE year = 2024) AS cases_2024,
    COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015) AS number_growth,
	( (COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015)) * 1.0 
      / NULLIF(COUNT(*) FILTER (WHERE year = 2015), 0) ) AS percent_growth
FROM calls_all
GROUP BY department
ORDER BY number_growth DESC
LIMIT 10;

-------------------------------------------
-- TRENDS BY REASON
-------------------------------------------

-- Reasons for calls in each year 
SELECT 
	year, 
	reason,
	COUNT(*) AS total_cases
FROM calls_all 
GROUP BY year, reason
ORDER BY year desc, total_cases desc;

-- Top reasons for calls in each year, 2015 to 2024, pivoted with each year as a column
SELECT 
	rank,
	MAX(CASE WHEN year = 2015 then reason end) as year_2015,
	MAX(CASE WHEN year = 2016 then reason end) as year_2016,
	MAX(CASE WHEN year = 2017 then reason end) as year_2017,
	MAX(CASE WHEN year = 2018 then reason end) as year_2018,
	MAX(CASE WHEN year = 2019 then reason end) as year_2019,
	MAX(CASE WHEN year = 2020 then reason end) as year_2020,
	MAX(CASE WHEN year = 2021 then reason end) as year_2021,
	MAX(CASE WHEN year = 2022 then reason end) as year_2022,
	MAX(CASE WHEN year = 2023 then reason end) as year_2023,
	MAX(CASE WHEN year = 2024 then reason end)  as year_2024
FROM
	(SELECT 
		year, 
		reason, 
		COUNT(*) AS total_cases, 
		rank() OVER (partition by year order by COUNT(*) desc) as rank
	FROM calls_all
	GROUP BY year, reason
	ORDER BY year, rank) subquery
WHERE rank <= 10
GROUP BY rank
ORDER BY rank;

-- Reasons that have seen greatest increase, 2015 to 2024 
-- (both growth in raw numbers and % growth)
SELECT 
    reason,
    COUNT(*) FILTER (WHERE year = 2015) AS cases_2015,
    COUNT(*) FILTER (WHERE year = 2024) AS cases_2024,
    COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015) AS number_growth,
	( (COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015)) * 1.0 
      / NULLIF(COUNT(*) FILTER (WHERE year = 2015), 0) ) AS perc_growth
FROM calls_all
GROUP BY reason
ORDER BY number_growth DESC;

---- Types that have seen greatest increase, 2015 to 2024 
-- (both growth in raw numbers and % growth)
SELECT 
    type,
    COUNT(*) FILTER (WHERE year = 2015) AS cases_2015,
    COUNT(*) FILTER (WHERE year = 2024) AS cases_2024,
    COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015) AS number_growth,
	( (COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015)) * 1.0 
      / NULLIF(COUNT(*) FILTER (WHERE year = 2015), 0) ) AS perc_growth
FROM calls_all
GROUP BY type
ORDER BY number_growth DESC;

-------------------------------------------
-- BY ZIP CODE AND NEIGHBORHOOD
-------------------------------------------
-- Calls by zip code, adjusted by zip code population
SELECT 
	c.year, 
	z.zip, 
	c.count, 
	c.count / z.pop_estimate *100 as count_per_100pop, 
	z.pop_estimate
FROM
	(Select 
		year, 
		location_zipcode, 
		count(*) as count
	from calls_all
	GROUP BY year, location_zipcode) c
JOIN zip_pop z
	ON z.zip = c.location_zipcode 
	AND z.year = c.year
WHERE z.pop_estimate IS NOT NULL
  AND z.pop_estimate > 0
  AND c.location_zipcode IS NOT NULL
  AND c.location_zipcode != '';

-- Zips seeing greatest increase in calls
SELECT 
    location_zipcode, 
	COUNT(*) FILTER (WHERE year = 2015) AS cases_2015,
    COUNT(*) FILTER (WHERE year = 2024) AS cases_2024,
    COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015) AS number_growth,
	( (COUNT(*) FILTER (WHERE year = 2024) - COUNT(*) FILTER (WHERE year = 2015)) * 1.0 
      / NULLIF(COUNT(*) FILTER (WHERE year = 2015), 0) ) AS percent_growth
FROM calls_all
GROUP BY location_zipcode
ORDER BY number_growth DESC;

-------------------------------------------
-- CASE OUTCOMES  / TIME TO CLOSE
-------------------------------------------
-- Percent of calls open vs. closed per year
-- To see which years still have a lot of open cases
Select 
	year,
	closed,
	open,
	closed::numeric / (closed + open) as perc_closed,
	open::numeric / (closed + open) as perc_open
FROM
	(Select 
		year, 
		SUM(CASE WHEN case_status = 'Closed' then 1 end) as closed,
		SUM(CASE WHEN case_status = 'Open' then 1 end) as open
	FROM calls_all
	GROUP BY year)
ORDER BY perc_open desc;

-- Among closed cases, the median time to close
SELECT 
	year,
	percentile_cont(0.5) WITHIN GROUP (ORDER BY closed_dt - open_dt) AS median_time_to_close
FROM calls_all
WHERE case_status = 'Closed'
GROUP BY year;

-- Among closed cases, the median time to close across departments (in hrs) for each year
Select 
    year,
	count(*),
    department,
    ROUND(EXTRACT(EPOCH FROM percentile_cont(0.5) WITHIN GROUP (ORDER BY closed_dt - open_dt)) / 3600) AS median_hours_to_close -- in hours
FROM calls_all
WHERE case_status = 'Closed'
GROUP BY year, department
ORDER BY year desc, median_hours_to_close desc;