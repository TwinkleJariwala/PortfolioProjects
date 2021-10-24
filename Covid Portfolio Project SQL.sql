Select *
From PortfolioProject1..[Covid-death]
where continent is not null
order by 3,4
--Select *
--From PortfolioProject1..[Covid-Vaccination]
--order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject1..[Covid-death]
where continent is not null
order by 1,2

--Total cases vs total deaths
--Likelihood of dying by covid in USA

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..[Covid-death]
where location like '%states%'
and continent is not null
order by 1,2

--Same by continent

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..[Covid-death]
--where location like '%states%'
where continent is null
order by 1,2





--Total Cases vs Population

Select location,date, population,total_cases, (total_cases/population)*100 as InfectPercentage
From PortfolioProject1..[Covid-death]
where location like '%states%'
and continent is not null
order by 1,2


-- Coutnries with highest infection rates compared to population
Select location, population,max(total_cases) as HighestInfectionCount, max((total_cases)/population)*100 as InfectPercentage
From PortfolioProject1..[Covid-death]
--where location like '%states%'
where continent is not null
Group by location,population
order by InfectPercentage desc

--Countries with highest death count

Select location,max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject1..[Covid-death]
--where location like '%states%'
where continent is not null
Group by location
order by HighestDeathCount desc


--Same by Continent

Select continent,max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject1..[Covid-death]
--where location like '%states%'
where continent is not null
Group by continent
order by HighestDeathCount desc


--Global numbers 


Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int ))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject1..[Covid-death]
--where location like '%states%'
where continent is not null
Group by date
order by 1,2

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int ))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject1..[Covid-death]
--where location like '%states%'
where continent is not null
order by 1,2



--Total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over  (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject1..[Covid-Vaccination] vac
join PortfolioProject1..[Covid-death] dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


--USe CTE

With PopvsVac(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over  (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject1..[Covid-Vaccination] vac
join PortfolioProject1..[Covid-death] dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac






--Temp table

Drop Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over  (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject1..[Covid-Vaccination] vac
join PortfolioProject1..[Covid-death] dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as VaccinatePercent
from #PercentPopulationVaccinated

--Creating view to store data for visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over  (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject1..[Covid-Vaccination] vac
join PortfolioProject1..[Covid-death] dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3



Select *
From PercentPopulationVaccinated