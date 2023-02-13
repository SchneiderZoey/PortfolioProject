select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

--select date to be used

select location, date, total_deaths, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--looking at Total Cases VS Total Deaths
--Shows likelyhood of dying if you contracted covid

select location, date, total_deaths, total_deaths, (total_deaths/total_cases)*100 as DeathPrecentage
From PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2

--looking at Total Cases vs Total Deaths
--shows what precentage of population got COVID 

select location, date, population, total_cases,  (total_cases/population)*100 as DeathPrecentage
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2

--looking at Countries with highest infection rate compared to population 

select location, population, MAX(total_cases) as Highestinfectioncount,  MAX(total_cases/population)*100 as Precentpopulationinfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
group by location, population
order by Precentpopulationinfected desc


--showing Contries with highest death count per Population 

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths  
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

--breaking things down by continent
--showing Continents with highest death count per population

select continent,MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths  
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers per day 

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/sum(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--total Global numbers 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


with PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp Table

drop Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


-- Creating view 

Create View PercentPopulationVaccinated as
select dea.continent. dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
