select *
from PortfolioProjectAlton..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProjectAlton..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjectAlton..CovidDeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in Bangladesh


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjectAlton..CovidDeaths
where location like '%Bangladesh%'
and continent is not null
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percetage of population got Covid

select location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProjectAlton..CovidDeaths
--where location like '%Bangladesh%'
order by 1,2


-- Looking at countries with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) as HighestInfectionCount,  Max(total_cases/population)*100 as 
	PercentPopulationInfected
from PortfolioProjectAlton..CovidDeaths
--where location like '%Bangladesh%'
group by location, population
order by PercentPopulationInfected desc


-- LETS'S BREAK THINGS DOWN BY CONTINENT


select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProjectAlton..CovidDeaths
--where location like '%Bangladesh%'
where continent is not  null
group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

select sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/sum(new_cases) as death_percentage
from PortfolioProjectAlton..CovidDeaths
--where location like '%Bangladesh%'
where continent is not null
--group by date
order by 1,2



-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjectAlton..CovidDeaths dea
join PortfolioProjectAlton..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjectAlton..CovidDeaths dea
join PortfolioProjectAlton..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100 as percentage
from PopvsVac



-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjectAlton..CovidDeaths dea
join PortfolioProjectAlton..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

USE PortfolioProjectAlton
Go
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjectAlton..CovidDeaths dea
join PortfolioProjectAlton..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select *
From PercentPopulationVaccinated












	


