Select *
From Public."CovidDeaths"
where continent is not null
order by 1,2 

--Select data that we are going to be use 

Select Location, date, total_cases, new_cases, total_deaths, population
From Public."CovidDeaths"
where continent is not null
order by 1,2 



-- Looking at Total Cases vs Total Deaths

Select Location, date, total_cases,  total_deaths, cast(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)*100 as DeathPercentage
From Public."CovidDeaths"
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths (USA )

Select Location, date, total_cases,  total_deaths, cast(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)*100 as DeathPercentage
From Public."CovidDeaths"
WHERE lower(LOCATION) LIKE '%states%'
 and continent is not null
order by 1,2

Select Location, date, total_cases,  total_deaths, cast(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)*100 as DeathPercentage
From Public."CovidDeaths"
WHERE lower(LOCATION) LIKE '%india%'
 and continent is not null
order by 1,2




--LOkking at total cases vs population
--shows what percentage of population got covid 


Select Location, date, total_cases, population, cast(total_cases AS FLOAT)/CAST(population AS FLOAT)*100 as InfectionPercentage
From Public."CovidDeaths"
WHERE lower(LOCATION) LIKE '%india%'
and  continent is not null
order by 1,2

---
Select Location, date, total_cases, population, cast(total_cases AS FLOAT)/CAST(population AS FLOAT)*100 as InfectionPercentage
From Public."CovidDeaths"
where continent is not null
order by 1,2



--Looking at Countries with Highest Infection Rate to Popoulation


Select Location, population, MAX(total_cases), MAX(cast(total_cases AS FLOAT)/CAST(population AS FLOAT)*100) as InfectionPercentage
From Public."CovidDeaths"
Group By Location, population

order by InfectionPercentage desc



Select Location, population, MAX(total_cases), MAX(cast(total_cases AS FLOAT)/CAST(population AS FLOAT)*100) as PopulationInfectionPercentage
From Public."CovidDeaths"
where continent is not null
Group By Location, population
having MAX(cast(total_cases AS FLOAT)/CAST(population AS FLOAT)*100) Is Not Null
order by PopulationInfectionPercentage desc



-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT OVER POPULATION


Select Location,  MAX(total_deaths) AS TotalDeathCount
From Public."CovidDeaths"
where continent is not null
Group By Location
Having MAX(total_deaths) IS NOT NULL
order by TotalDeathCount desc



-- break thing down by location




Select location,  MAX(total_deaths) AS TotalDeathCount
From Public."CovidDeaths"
where continent is null
Group By location
Having MAX(total_deaths) IS NOT NULL
order by TotalDeathCount desc 




Select continent,  MAX(total_deaths) AS TotalDeathCount
From Public."CovidDeaths"
where continent is not null
Group By continent
--Having MAX(total_deaths) IS NOT NULL
order by TotalDeathCount desc 


-- Global Numbers

Select date, sum(new_cases) as total_cases,  sum(new_deaths) as total_deaths,  sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercentage
From Public."CovidDeaths"
where continent is not null
group by date
order by 1,2



Select  sum(new_cases) as total_cases,  sum(new_deaths) as total_deaths,  sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercentage
From Public."CovidDeaths"
where continent is not null
--group by date
order by 1,2



Select *
From Public."CovidVaccinations"
--where continent is not  null
order by 1,2 

--Join 2 tables 

Select * 
From Public."CovidDeaths" dea
Join Public."CovidVaccinations" vac
on dea.location = vac.location
and dea.date = vac.date

--Lokking at total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Public."CovidDeaths" dea
Join Public."CovidVaccinations" vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Public."CovidDeaths" dea
Join Public."CovidVaccinations" vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



--Creating View to store data for later visualization 

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Public."CovidDeaths" dea
Join Public."CovidVaccinations" vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null



Select * from PercentPopulationVaccinated
