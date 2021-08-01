select * from PortfolioProject..covidvaccinations
order by 3,4;

select * from PortfolioProject..coviddeath
order by 3,4;

select location,date,total_cases,new_cases
,total_deaths,population from PortfolioProject..coviddeath
order by 1,2;

--What are the chances of dying from covid in nigeria? 
select location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as deathpercase from PortfolioProject..coviddeath
where location='Nigeria'
order by 1,2;

--what percentage of population got covid?
-- what is nigeria's covid-19 infection rate?
select location,date,total_cases,population,total_deaths,
(total_deaths/population)*100 as deathperpopulation from PortfolioProject..coviddeath
where location='Nigeria'
order by 1,2
;

--discovering top 10 countries with the highest infection rate?
select top 10 location,population, max(total_cases) as highestinfectioncount,
max(total_cases/population)*100 as infectionrate from PortfolioProject..coviddeath
group by location,population
order by 4 desc;

--discover the 10 african countires with the highest covid-19 infectious rate
select top 10 location,population,continent,max(total_cases) as highestinfectioncount,
max(total_cases/population)*100 as infectionrate from PortfolioProject..coviddeath
group by location, population,continent
having continent='Africa'
order by 4 desc;

--showing countries with the highestdeathcount

select location, max(cast (total_deaths as int)) as highestdeathcount,
max(total_deaths/population)*100 as deathrate from PortfolioProject..coviddeath
where continent is not null
group by location
order by 2 desc;

--showing countries with the highest infectionrate
select location, max(cast (total_deaths as int)) as highestdeathcount,
max(total_deaths/population)*100 as deathrate from PortfolioProject..coviddeath
where continent is not null
group by location
order by 3 desc;

--continents with the most infection rate
create view continentswithcovid as
select continent,max(total_deaths/population)*100 as deathrate from PortfolioProject..coviddeath
where continent is not null 
group by continent;
select * 
from continentswithcovid;

--total cases and deaths in the world

select sum(new_cases)as totalcases,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathrate 
from PortfolioProject..coviddeath
 ;

 --total number of people vaccinated as at 17/07/2021
 
 with totalvac (continent, location,date, population,new_vaccinations, totalVacc)
 as
 (
 select d.continent, d.location, d.date, d.population, 
 v.new_vaccinations,sum(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location) as totalVacc
 from PortfolioProject..coviddeath d
 join PortfolioProject..covidvaccinations v
 on d.location=v.location
 and
 d.date=v.date
 where d.continent is not null
 and v.new_vaccinations is not null
 group by d.continent, d.location, d.date, d.population, 
 v.new_vaccinations
 )
 select continent, location, population,totalVacc,max(totalVacc/population)*100 as VaccinationRate from totalvac
 group by continent, location, population, totalVacc;

 IF OBJECT_ID ('tempdb.dbo.#totalnumbervaccinated','u') is not null
drop table #totalnumbervaccinated  
create table #totalnumbervaccinated
(continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
totalVacc numeric
)

insert into #totalnumbervaccinated
 select d.continent, d.location, d.date, d.population, 
 v.new_vaccinations,sum(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location) as totalVacc
 from PortfolioProject..coviddeath d
 join PortfolioProject..covidvaccinations v
 on d.location=v.location
 and
 d.date=v.date
 where d.continent is not null
 and v.new_vaccinations is not null
 group by d.continent, d.location, d.date, d.population, 
 v.new_vaccinations
 order by 1,2;

 select * from #totalnumbervaccinated









