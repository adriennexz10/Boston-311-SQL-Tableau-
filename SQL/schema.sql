-- schema.sql
-- This file defines the structure of the database (the tables and columns) 
-- for the Boston 311 calls dataset. Run this first to create the schema.

-- Create the master table for all 311 calls
CREATE TABLE calls_all (
    case_enquiry_id BIGINT,
    open_dt TIMESTAMP,
    sla_target_dt TIMESTAMP,
    closed_dt TIMESTAMP,
    on_time TEXT,
    case_status TEXT,
    closure_reason TEXT,
    case_title TEXT,
    subject TEXT,
    reason TEXT,
    type TEXT,
    queue TEXT,
    department TEXT,
    submitted_photo TEXT,
    closed_photo TEXT,
    location TEXT,
    fire_district TEXT,
    pwd_district TEXT,
    city_council_district TEXT,
    police_district TEXT,
    neighborhood TEXT,
    neighborhood_services_district TEXT,
    ward TEXT,
    precinct TEXT,                 
    location_street_name TEXT,
    location_zipcode TEXT,         
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    geom_4326 TEXT,
    source TEXT,
    year INT
);

-- Create the temporary staging table, which we will use to load the data in the next step
CREATE TABLE calls_stage (
    case_enquiry_id BIGINT,
    open_dt TIMESTAMP,
    sla_target_dt TIMESTAMP,
    closed_dt TIMESTAMP,
    on_time TEXT,
    case_status TEXT,
    closure_reason TEXT,
    case_title TEXT,
    subject TEXT,
    reason TEXT,
    type TEXT,
    queue TEXT,
    department TEXT,
    submitted_photo TEXT,
    closed_photo TEXT,
    location TEXT,
    fire_district TEXT,
    pwd_district TEXT,
    city_council_district TEXT,
    police_district TEXT,
    neighborhood TEXT,
    neighborhood_services_district TEXT,
    ward TEXT,
    precinct TEXT,
    location_street_name TEXT,
    location_zipcode TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    geom_4326 TEXT,
    source TEXT
);


-- Create the Boston population table, so we can adjust for a changing population by zip over time
CREATE TABLE boston_pop (
year integer,
population_boston integer
);

-- Create the zip population table, so we can adjust for a changing population by zip over time
CREATE TABLE zip_pop (
year integer,
zip text,
pop_estimate numeric,
moe numeric
);