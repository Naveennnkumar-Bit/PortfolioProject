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

select location,population,max(total_cases)as HighestInfectCount,round(Max(total_cases/population)*100,2) as percentagepopulationinfected 
from PortfolioProject..CovidDeaths 
group by location,population 
order by location,population  desc