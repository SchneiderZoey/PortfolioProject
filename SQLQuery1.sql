select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

select location, date, total_deaths, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select location, date, total_deaths, total_deaths, (total_deaths/total_cases)*100 as DeathPrecentage
From PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2

select location, date, population, total_cases,  (total_cases/population)*100 as DeathPrecentage
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2


select location, population, MAX(total_cases) as Highestinfectioncount,  MAX(total_cases/population)*100 as Precentpopulationinfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
group by location, population
order by Precentpopulationinfected desc


select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths  
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc