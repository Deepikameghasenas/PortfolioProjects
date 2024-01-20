select *
from portfolioproject1..CovidDeaths$
order by 3,4

select *
from portfolioproject1..CovidVaccinations$
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from portfolioproject1..CovidDeaths$
order by 1,2
-- total cases vs total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from portfolioproject1..CovidDeaths$
where location like '%states%'
--percentage of population got covid
select location,date,total_cases,total_deaths,(total_cases/population)*100 as casespercentage
from portfolioproject1..CovidDeaths$
where location like '%states%'

----countries with highest infection rate
--select location,population,MAX(total_cases) as highestinfectionrate,Max((total_cases/population))*100 as percentagepopulationinfected
--from portfolioproject1..CovidDeaths$
--order by 1,2

--totalcases vs population
select location,date,total_cases,population,(total_cases/population)*100 as casespercentage
from portfolioproject1..CovidDeaths$
where location like '%states%'
order by 1,2
--totalcases in india
select location,date,total_cases,population,(total_cases/population)*100 as casespercentage
from portfolioproject1..CovidDeaths$
where location='India'
order by 1,2
--countries with highest infectionrate compared to population
--select population,location,date,max(total_cases) as highestinfectionratecount,population,max((total_cases/population))*100 as percentageofpopulationinfected
--from portfolioproject1..CovidDeaths$
----where location like '%states%'
--group by population,location
--order by percentageofpopulationinfected

--showing countries with highest death count
select location,max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject1..CovidDeaths$
--where location like '%states%'
group by location
order by totaldeathcount desc

--break things by continent
select location,max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject1..CovidDeaths$
--where location like '%states%'
where continent is null
group by location
order by totaldeathcount desc

--showing continents with highest death rate vs population
select continent,max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc

-- covid vaccinations tasks
select dead.continent,dead.location, dead.date,dead.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dead.location order by dead.location)
from portfolioproject1..CovidDeaths$ dead
join portfolioproject1..CovidVaccinations$ vac
on dead.location=vac.location
and dead.date=vac.date
where dead.continent is not null
order by 2,3

-- temp table
create table percentpopulatedvaccinated
(
continent varchar(300),
Location varchar(200),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into percentpopulatedvaccinated
select dead.continent,dead.location, dead.date,dead.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dead.location order by dead.location)
from portfolioproject1..CovidDeaths$ dead
join portfolioproject1..CovidVaccinations$ vac
on dead.location=vac.location
and dead.date=vac.date
where dead.continent is not null
order by 2,3

select *
from percentpopulatedvaccinated

-- creating view
create view percentpopulatedvaccinated as
select dead.continent,dead.location, dead.date,dead.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dead.location order by dead.location)
from portfolioproject1..CovidDeaths$ dead
join portfolioproject1..CovidVaccinations$ vac
on dead.location=vac.location
and dead.date=vac.date
where dead.continent is not null
order by 2,3