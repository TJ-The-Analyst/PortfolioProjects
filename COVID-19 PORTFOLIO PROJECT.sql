-- COMPLETED IN: Microsoft SQL Server 2019 --

SELECT * FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL
ORDER BY 3,4;


-- Selecting the Data that we are going to be using:

SELECT LOCATION, DATE, total_cases, new_cases, total_deaths, POPULATION
FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- Looking at Total Cases .vs. Total Deaths --
-- Shows the likelyhood of dying if you contract Covid-19 in your country:

SELECT LOCATION, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM PorfolioProject..[COVID DEATHS]
WHERE LOCATION LIKE '%states%' AND continent IS NOT NULL
ORDER BY 1,2;


-- Looking at the Total Cases .vs. Population --
-- Shows what percentage of the population has gotten Coivd-19:

SELECT LOCATION, DATE, total_cases, POPULATION, (total_cases/POPULATION)*100 as percent_of_population_infected
FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL

ORDER BY 1,2;


-- Looking at countries with Highest Infection rate compared to Population:

SELECT LOCATION, POPULATION, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as percent_of_population_infected
FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL
GROUP BY LOCATION, POPULATION
ORDER BY percent_of_population_infected DESC


-- Showing Countries with Highest Death count per Population:

SELECT LOCATION, MAX(CAST(total_deaths as INT)) as total_death_count
FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL
GROUP BY LOCATION
ORDER BY total_death_count DESC


-- Let's break things down by Continent --

SELECT continent, MAX(CAST(total_deaths as INT)) as total_death_count
FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

			   
-- Showing the continents with the highest death count per Population:

SELECT LOCATION, MAX(CAST(total_deaths as INT)) as total_death_count
FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL
GROUP BY LOCATION
ORDER BY total_death_count DESC


-- Global Numbers --

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INT)) as total_deaths, SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 death_percentage
FROM PorfolioProject..[COVID DEATHS]
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- Looking at Total Population .vs. Vaccinations:

SELECT dea.continent, dea.LOCATION, dea.DATE, dea.POPULATION, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION, dea.DATE) as rolling_people_vaccinated 
FROM PorfolioProject..[COVID DEATHS] dea
JOIN PorfolioProject..[COVID VACCINATIONS] vac
	ON dea.LOCATION = vac.LOCATION
	AND dea.DATE = vac.DATE
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;


-- Use CTE --

WITH Pop_vs_Vac (continent, LOCATION, DATE, POPULATION, new_vaccinations, rolling_people_vaccinated)
AS
(SELECT dea.continent, dea.LOCATION, dea.DATE, dea.POPULATION, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION, dea.DATE) as rolling_people_vaccinated 
FROM PorfolioProject..[COVID DEATHS] dea
JOIN PorfolioProject..[COVID VACCINATIONS] vac
	ON dea.LOCATION = vac.LOCATION
	AND dea.DATE = vac.DATE
WHERE dea.continent IS NOT NULL
)
SELECT * ,(rolling_people_vaccinated/POPULATION)*100
FROM Pop_vs_Vac;


-- Temp Table --

DROP TABLE IF EXISTS #percent_populated_vaccinated
CREATE TABLE #percent_population_vaccinated
(
	continent NVARCHAR(255),
	LOCATION NVARCHAR(255),
	DATE DATETIME,
	POPULATION NUMERIC,
	new_vaccinations NUMERIC,
	rolling_people_vaccinated NUMERIC
);

INSERT INTO #percent_population_vaccinated
SELECT dea.continent, dea.LOCATION, dea.DATE, dea.POPULATION, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION, dea.DATE) as rolling_people_vaccinated 
FROM PorfolioProject..[COVID DEATHS] dea
JOIN PorfolioProject..[COVID VACCINATIONS] vac
	ON dea.LOCATION = vac.LOCATION
	AND dea.DATE = vac.DATE
WHERE dea.continent IS NOT NULL

SELECT * , (rolling_people_vaccinated/POPULATION)*100
FROM #percent_population_vaccinated


-- Creating View to store data for later visualizations --

CREATE VIEW percent_population_vaccinated as
SELECT dea.continent, dea.LOCATION, dea.DATE, dea.POPULATION, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION, dea.DATE) as rolling_people_vaccinated 
FROM PorfolioProject..[COVID DEATHS] dea
JOIN PorfolioProject..[COVID VACCINATIONS] vac
	ON dea.LOCATION = vac.LOCATION
	AND dea.DATE = vac.DATE
WHERE dea.continent IS NOT NULL