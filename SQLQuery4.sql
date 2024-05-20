select *
From PortfolioProject..coviddeaths
where continent is not null
ORDER BY 3,4

--select *
--From PortfolioProject..covidvaccinations
--ORDER BY 3,4

--select the data we are going to use



Select  Location,date,total_cases,new_cases, total_deaths ,population_density
From PortfolioProject..coviddeaths
Order by 1,2

--Looking at total cases vs total deaths
Select  Location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..coviddeaths
where location like '%states%' 
Order by 1,2

--Total cases vs population
--shows what percentage of population got effected
Select  Location,date,total_cases, population_density, (total_cases/population_density)*100 as percentPopulationInfected
From PortfolioProject..coviddeaths
--where location like '%ndia%' 
Order by 1,2

--Looking at countries with highest infection rate compared to population
Select  Location ,MAX(total_cases) as HighestInfectionCount, population_density, MAX((total_cases/population_density))*100 as max_percentInfected
From PortfolioProject..coviddeaths
where continent is not null
Group by population_density, Location
Order by max_percentInfected desc


--Let's do this by continent
Select  continent ,MAX(cast(total_deaths AS int)) as TotalDeathCount
From PortfolioProject..coviddeaths
where continent is  not null 
Group by  continent
Order by TotalDeathCount desc

--Showing countries with highest death count per population
Select  Location ,MAX(cast(total_deaths AS int)) as TotalDeathCount
From PortfolioProject..coviddeaths
where continent is not null 
Group by  Location
Order by TotalDeathCount desc


   
--showing continents with highest death rate
Select  continent ,MAX(cast(total_deaths AS int)) as TotalDeathCount
From PortfolioProject..coviddeaths
where continent is  not null 
Group by  continent
Order by TotalDeathCount desc

--Global Numbers
Select Sum(new_cases) as total_cases,Sum(cast( total_deaths as int)), Sum(cast( total_deaths as int))/Sum(new_cases) *100 as deathPercentage
From PortfolioProject..coviddeaths
--where location like '%states%' 
where continent is not null 
--Group by date
Order by 1,2

--Looking at total population vs hospital beds
Select dea.continent,dea.location,dea.date,vac.population, vac.hospital_beds_per_thousand
,Sum(convert(int,hospital_beds_per_thousand)) Over (Partition by dea.location)
From PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
 on dea.location =vac.location
 and dea.date=vac.date
where dea.continent is not null
Order by 2,3


With PopvsVac(Continent,location,dea.Date,vac.population,RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,vac.population, vac.hospital_beds_per_thousand
,Sum(convert(int,hospital_beds_per_thousand)) Over (Partition by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..coviddeath dea
join PortfolioProject..covidvacscinations vac
 on dea.location =vac.location
 and dea.date=vac.date
where dea.continent is not null
Order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From  PopvsVac


 --Temp Table
 Create Table #PercentPopulationVaccinated
 (
 Continent varchar(255),
 Location nvarchar(255),
 Date datetime,
 POPULATION NUMERIC,
 Newvaccinations numeric,
 RollingPeopleVaccinated numeric
 )


 Insert into #PercentPopulationVaccinated
 Select dea.continent,dea.location,dea.date,vac.population, vac.hospital_beds_per_thousand
,Sum(convert(int,hospital_beds_per_thousand)) Over (Partition by dea.location)
From PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
 on dea.location =vac.location
 and dea.date=vac.date
where dea.continent is not null
Order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
