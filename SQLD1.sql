--select * from PortfolioProject..CovidDeaths 

--select * from PortfolioProject..CovidVaccinations 

--select * from PortfolioProject..CovidDeaths order by 3,4

--select * from PortfolioProject..CovidVaccinations order by 3,4

-- select location,date,total_cases,new_cases,total_deaths,population from PortfolioProject..CovidDeaths order by 1,2

--Looking at total cases vs total deaths shows death Percentage

--select location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,2) as deathpercentage 
--from PortfolioProject..CovidDeaths where location like '%ia%'
--order by 1,2
 
 --shows what percentage of population got covid
/* select location,date,total_cases,population,total_deaths,round((total_cases/population)*100,2) as populationgotcovid
from PortfolioProject..CovidDeaths where location like '%ia%'
order by 1,2*/

--looking at countries with highest infection rate compared to population

--select location,population,max(total_cases)as HighestInfectCount,round(Max(total_cases/population)*100,2) as percentagepopulationinfected 
--from PortfolioProject..CovidDeaths 
--group by location,population 
--order by location,population  desc

--showing Countries with highest Death Count per population


--select location,max(cast(total_deaths as int) )as totaldeath 
--from PortfolioProject..CovidDeaths where continent is not null
--group by location 
--order by totaldeath  desc

--LET'S BREAK THINGS DOWN BY CONTINENT

--select continent,max(cast(total_deaths as int) )as totaldeath 
--from PortfolioProject..CovidDeaths where continent is not null
--group by continent
--order by totaldeath  desc


--GLOBAL NUMBERS

SELECT 
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    ROUND(SUM(CAST(new_deaths AS INT)) * 100.0 / SUM(new_cases), 2) AS death_percentage
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
ORDER BY 
    total_cases, total_deaths;


	--Looking at total populations and vaccinations

	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
	from PortfolioProject..CovidDeaths dea join 
	PortfolioProject..CovidVaccinations  vac on dea.location =vac.location and dea.date=vac.date
	where dea.continent is not null
	order by 2,3

	--with CTE'S
	with popvsvac(continent,location,date,population,new_vaccination,rollingpeoplevaccinated)as(

	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
	from PortfolioProject..CovidDeaths dea join 
	PortfolioProject..CovidVaccinations  vac on dea.location =vac.location and dea.date=vac.date
	where dea.continent is not null)
	select*, round((rollingpeoplevaccinated/population)*100,2) from popvsvac
	

	--TEMP Tables
	drop table if exists #percentpopulationVaccinated
	Create table #percentpopulationVaccinated(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric, 
	rollingpeoplevaccinated numeric)

	insert into #percentpopulationVaccinated
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
	from PortfolioProject..CovidDeaths dea join 
	PortfolioProject..CovidVaccinations  vac on dea.location =vac.location and dea.date=vac.date
	where dea.continent is not null
	select*, round((rollingpeoplevaccinated/population)*100,2) 
	from #percentpopulationVaccinated


	--view
	create view percentpopulationVaccinated as
	SELECT 
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    ROUND(SUM(CAST(new_deaths AS INT)) * 100.0 / SUM(new_cases), 2) AS death_percentage
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
	select*from  percentpopulationVaccinated

	create view  percentpopulationVaccinated2 as
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
	from PortfolioProject..CovidDeaths dea join 
	PortfolioProject..CovidVaccinations  vac on dea.location =vac.location and dea.date=vac.date
	where dea.continent is not null
	select*from  percentpopulationVaccinated2