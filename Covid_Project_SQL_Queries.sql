--SQL Queries for the dataset on Covid Till April 2021.


-------------------------------------------------
1. --Total Infection in the World Til April 2021
SELECT location, date,total_cases
FROM Covid.CovidDeaths
WHERE continent is not null
ORDER BY 3 DESC

2.  --Likelyhood of dying from Covid in India
SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage 
FROM Covid.CovidDeaths
WHERE location = "India"
ORDER BY 1

3.  --Looking at Total Cases vs Population
--Shows percenatge of population got covid in "India"
SELECT location,date, total_cases, population, (total_cases/population)*100 AS percentage_cases
FROM Covid.CovidDeaths
WHERE location ="India"
ORDER BY 1

4.  --Looking at Total Cases vs Population
--Shows percenatge of population got covid in "India"
SELECT location,date, total_cases, population, (total_cases/population)*100 AS percentage_cases
FROM Covid.CovidDeaths
WHERE location ="India"
ORDER BY 1

5.  --Looking from the perspective of the the Continents
--Showing Continens with highest death counts

SELECT continent, MAX(total_deaths) AS highest_death_count,MAX((total_deaths/population)*100) AS highest_percentage_deaths
FROM Covid.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY MAX(total_deaths) DESC

6.  --Looking at Total Vaccinations at April 2021
SELECT deaths.location, MAX(vaccines.new_vaccinations) AS total_vaccination
FROM `Covid.CovidDeaths` deaths
JOIN `Covid.CovidVaccinations`vaccines
ON deaths.location=vaccines.location and deaths.date=vaccines.date
WHERE deaths.continent is not null
GROUP BY deaths.location
ORDER BY 1

7.  --Total Percent of Population Vaccinated Till April 2021 Around The World
WITH PopVsVac AS
(
SELECT deaths.continent,deaths.location,deaths.date,deaths.population, vaccines.new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS RollingOfVaccination
FROM `Covid.CovidDeaths` deaths
JOIN `Covid.CovidVaccinations`vaccines
ON deaths.location=vaccines.location and deaths.date=vaccines.date
WHERE deaths.continent is not null
--ORDER BY 2,3
)
SELECT location, MAX((RollingOfVaccination/population)*100)
FROM PopVsVac
GROUP BY location

8.  --Total Percent of Population Vaccinated Till April 2021 in India
WITH PopVsVac AS
(
SELECT deaths.continent,deaths.location,deaths.date,deaths.population, vaccines.new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS RollingOfVaccination
FROM `Covid.CovidDeaths` deaths
JOIN `Covid.CovidVaccinations`vaccines
ON deaths.location=vaccines.location and deaths.date=vaccines.date
WHERE deaths.continent is not null
--ORDER BY 2,3
)
SELECT location, MAX((RollingOfVaccination/population)*100)
FROM PopVsVac
WHERE location = "India"
GROUP BY location

9.  --Looking at Highest Infection Rate compared to Population
SELECT location, MAX(total_cases) AS highest_infection_count, population, MAX((total_cases/population)*100) AS highest_percentage_cases
FROM Covid.CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY 2 DESC
