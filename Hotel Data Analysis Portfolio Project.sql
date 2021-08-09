

-- WELCOME TO MY SQL & POWER BI DATA ANALYST PROJECT! --


-- CHECKING TO MAKE SURE THE DATA WAS CORRECTLY IMPORTED --

SELECT * 
FROM dbo.['2018$']

SELECT *
FROM dbo.['2019$']

SELECT *
FROM dbo.['2020$']


-- UTILIZING THE "UNION" FUNCTION TO COMBINE THE TABLES AND HAVE 1 LARGE SET OF DATA --

SELECT *
FROM dbo.['2018$']
UNION
SELECT *
FROM dbo.['2019$']
UNION
SELECT *
FROM dbo.['2020$']


-- EXPLORATORY ANALYSIS WHILE USING SQL --


-- TEMP TABLE --

CREATE VIEW hotels_view1 AS
(
	SELECT *
	FROM dbo.['2018$']
	UNION
	SELECT *
	FROM dbo.['2019$']
	UNION
	SELECT *
	FROM dbo.['2020$']
)

SELECT *
FROM dbo.hotels_view1


-- WHAT IS THE HOTEL REVENUE GROWTH YEAR OVER YEAR? --

SELECT 
arrival_date_year,
hotel,
ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights)*adr),2)
AS revenue
FROM dbo.hotels_view1
GROUP BY arrival_date_year, hotel


-- USING JOINS TO CREATE COLUMNS THAT DISPLAY NEW INFORMATION

SELECT *
FROM dbo.hotels_view1
LEFT JOIN market_segment$
ON dbo.hotels_view1.market_segment = market_segment$.market_segment
LEFT JOIN dbo.meal_cost$
ON meal_cost$.meal = hotels_view1.meal

