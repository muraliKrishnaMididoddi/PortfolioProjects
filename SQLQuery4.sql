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
Select Sum(new_cases) as total_cases,Sum(cast( new_deaths as int)) as total_deaths, (Sum(cast( new_deaths as int))/Sum(New_Cases)) *100 as deathPercentage
From PortfolioProject..coviddeaths
--where location like '%states%' 
where continent is not null 
--Group by date
Order by 1,2

select *
From PortfolioProject..Coviddeaths dea
Join PortfolioProject..Covidvaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Looking at total population vs hospital beds
Select dea.continent,dea.location,dea.date,vac.population, vac.hospital_beds_per_thousand
,Sum(convert(float,hospital_beds_per_thousand)) Over (Partition by dea.location order by dea.location,
dea.date)
From PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
 on dea.location =vac.location
 and dea.date=vac.date
where dea.continent is not null
Order by 2,3


With PopvsVac(Continent,location,Date,population,hospital_beds_per_thousand,RollingPeopleGettingBed)
as
(
Select dea.continent,dea.location,dea.date,population, hospital_beds_per_thousand
,Sum(cast(hospital_beds_per_thousand as float)) Over (Partition by dea.location,dea.date) as RollingPeoplegettingBed
From PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
 on dea.location =vac.location
 and dea.date=vac.date
--where dea.continent is not null
--Order by 2,3
)
Select *,(RollingPeopleGettingBed/population)*100 as per
From  PopvsVac


 --Temp Table
 Drop Table if exists #PercentPopulationGettingBed
 Create Table #PercentPopulationGettingBed
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 POPULATION NUMERIC,
 Newvaccinations numeric,
 RollingPeopleGettingBed numeric
 )


 Insert into #PercentPopulationGettingBed
 Select dea.continent,dea.location,dea.date,population, vac.hospital_beds_per_thousand
,Sum(convert(int,hospital_beds_per_thousand)) Over (Partition by dea.location,dea.date) as RollinPeopleGettingBed
From PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
 on dea.location =vac.location
 and dea.date=vac.date
--where dea.continent is not null
--Order by 2,3

Select *,(RollingPeopleGettingBed/Population)*100
From #PercentPopulationGettingBed


--Creating view to store data for later visualizations

DROP view [PercentPopulationGettingBed];
Create View PercentPopulationGettingBed 
as
Select dea.continent,dea.location,dea.date,population, vac.hospital_beds_per_thousand
,Sum(convert(float,hospital_beds_per_thousand)) Over (Partition by dea.location,dea.date) as RollinPeopleGettingBed
From PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
 on dea.location =vac.location
 and dea.date=vac.date
--where dea.continent is not null
--Order by 2,3

Select *
From  PercentPopulationGettingBed