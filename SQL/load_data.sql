-- load_data.sql
-- contains instructions for importing the yearly csv files (2015–2024) into the staging table, then inserting them into the master table (calls_all).
-- run this after schema.sql.

-- Step 1. Import data from all years into the staging table, then the master table

-- 2015 data
Copy calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2015.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2015 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2016 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2016.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2016 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2017 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2017.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2017 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2018 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2018.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2018 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2019 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2019.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2019 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2020 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2020.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2020 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2021 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2021.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2021 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2022 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2022.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2022 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2023 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2023.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2023 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- 2024 data
COPY calls_stage FROM 'C:\SQL\Boston 311\311 Service Requests 2024.csv' 
WITH (FORMAT csv, HEADER true);
INSERT INTO calls_all SELECT *, 2024 AS year FROM calls_stage;
TRUNCATE calls_stage;

-- Check what the table looks like, to make sure all years are included
Select year, count(*)
FROM calls_all
GROUP BY year;

-- Step 2: Load citywide population data
-- I used ACS 1-year estimates, with the exception of 2020, where I interpolated between 2019 and 2021
-- and 2024, where I used 2023 data (as 2024 data is not yet available)
COPY boston_pop FROM 'C:\SQL\Boston 311\population_boston.csv' 
WITH (FORMAT csv, HEADER true);

-- Check that it loaded correcttly
SELECT * from boston_pop ORDER BY year;

-- Step 3: Load zip code pop data  
-- I used ACS 5-year estimates, with the exception of 2020, where I interpolated between 2019 and 2021
-- and 2024, where I used 2023 data (as 2024 data is not yet available)
COPY zip_pop FROM 'C:\SQL\Boston 311\population_by_zip.csv' 
WITH (FORMAT csv, HEADER true);

-- Check that it loaded correctly
-- (Note that this is actually data for ALL zip codes -- but we will filter out the unnecessary zips later)
SELECT year, count(*) as zip_count from zip_pop GROUP BY year ORDER BY year;


