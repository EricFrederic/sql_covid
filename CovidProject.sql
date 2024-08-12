


Select * 
From CovidProject..CovidDeaths
Where continent is not null
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeaths
order by 1,2

--Total Cases vs. Total Deaths: United States

WITH CleanedData AS (
    SELECT 
        Location, 
        date, 
        total_cases, 
        total_deaths
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        location LIKE '%states%'
        AND continent IS NOT NULL 
        AND ISNUMERIC(total_cases) = 1
        AND ISNUMERIC(total_deaths) = 1
)
SELECT 
    Location, 
    CAST(date AS DATE) AS date,
    CAST(total_cases AS FLOAT) AS total_cases, 
    CAST(total_deaths AS FLOAT) AS total_deaths, 
    CASE 
        WHEN CAST(total_cases AS FLOAT) = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 
    END AS DeathPercentage
FROM 
    CleanedData
ORDER BY 
    Location, 
    CAST(date AS DATE);

--Total Cases vs.Total Deaths: China


WITH CleanedData AS (
    SELECT 
        Location, 
        date, 
        total_cases, 
        total_deaths
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        location like '%China%'
        AND continent IS NOT NULL 
        AND ISNUMERIC(total_cases) = 1
        AND ISNUMERIC(total_deaths) = 1
)
SELECT 
    Location, 
    CAST(date AS DATE) AS date,
    CAST(total_cases AS FLOAT) AS total_cases, 
    CAST(total_deaths AS FLOAT) AS total_deaths, 
    CASE 
        WHEN CAST(total_cases AS FLOAT) = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 
    END AS DeathPercentage
FROM 
    CleanedData
ORDER BY 
    Location, 
    CAST(date AS DATE)

--Total Cases vs.Total Deaths: Sweden

WITH CleanedData AS (
    SELECT 
        Location, 
        date, 
        total_cases, 
        total_deaths
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        location like '%Sweden%'
        AND continent IS NOT NULL 
        AND ISNUMERIC(total_cases) = 1
        AND ISNUMERIC(total_deaths) = 1
)
SELECT 
    Location, 
    CAST(date AS DATE) AS date,
    CAST(total_cases AS FLOAT) AS total_cases, 
    CAST(total_deaths AS FLOAT) AS total_deaths, 
    CASE 
        WHEN CAST(total_cases AS FLOAT) = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 
    END AS DeathPercentage
FROM 
    CleanedData
ORDER BY 
    Location, 
    CAST(date AS DATE)

----Total Cases vs.Total Deaths: Italy

WITH CleanedData AS (
    SELECT 
        Location, 
        date, 
        total_cases, 
        total_deaths
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        location like '%Italy%'
        AND continent IS NOT NULL 
        AND ISNUMERIC(total_cases) = 1
        AND ISNUMERIC(total_deaths) = 1
)
SELECT 
    Location, 
    CAST(date AS DATE) AS date,
    CAST(total_cases AS FLOAT) AS total_cases, 
    CAST(total_deaths AS FLOAT) AS total_deaths, 
    CASE 
        WHEN CAST(total_cases AS FLOAT) = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 
    END AS DeathPercentage
FROM 
    CleanedData
ORDER BY 
    Location, 
    CAST(date AS DATE)

--Total Cases vs. Population

WITH CleanedData AS (
    SELECT 
        Location, 
        date, 
        Population,
        total_cases
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        --location LIKE '%states%'
        ISNUMERIC(Population) = 1
        AND ISNUMERIC(total_cases) = 1
)
SELECT 
    Location, 
    CAST(date AS DATE) AS date,
    CAST(Population AS FLOAT) AS Population,
    CAST(total_cases AS FLOAT) AS total_cases, 
    (CAST(total_cases AS FLOAT) / CAST(Population AS FLOAT)) * 100 AS PercentPopulationInfected
FROM 
    CleanedData
ORDER BY 
    Location, 
    CAST(date AS DATE);

--Countries with Highest Covid Infection Rate Compared to Population

WITH CleanedData AS (
    SELECT 
        Location, 
        Population, 
        total_cases
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        --location LIKE '%states%'
        ISNUMERIC(Population) = 1
        AND ISNUMERIC(total_cases) = 1
)
SELECT 
    Location, 
    CAST(Population AS FLOAT) AS Population,
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    MAX((CAST(total_cases AS FLOAT) / CAST(Population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM 
    CleanedData
GROUP BY 
    Location, 
    CAST(Population AS FLOAT)
ORDER BY 
    PercentPopulationInfected DESC;


-- Countries with Highest Death Count per Population


WITH CleanedData AS (
    SELECT 
        Location, 
        TRY_CAST(Total_deaths AS INT) AS Total_deaths
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        continent IS NOT NULL
        AND TRY_CAST(Total_deaths AS INT) IS NOT NULL
        AND Location NOT IN ('World', 'Europe', 'North America', 'European Union', 'South America', 'Asia', 'Africa', 'Oceania', 'Antarctica')
)
SELECT 
    Location, 
    MAX(Total_deaths) AS TotalDeathCount
FROM 
    CleanedData
GROUP BY 
    Location
ORDER BY 
    TotalDeathCount DESC;


--Total Covid Deaths by Continent


WITH CleanedData AS (
    SELECT 
        continent, 
        TRY_CAST(Total_deaths AS INT) AS Total_deaths
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        continent IS NOT NULL
        AND continent <> 'NULL'
        AND TRY_CAST(Total_deaths AS INT) IS NOT NULL
)
SELECT 
    continent, 
    MAX(Total_deaths) AS TotalDeathCount
FROM 
    CleanedData
GROUP BY 
    continent
ORDER BY 
    TotalDeathCount DESC;


--Grand Total of Cases, Deaths, and Death Percentage Globally

WITH CleanedData AS (
    SELECT 
        TRY_CAST(new_cases AS FLOAT) AS new_cases,
        TRY_CAST(new_deaths AS INT) AS new_deaths
    FROM 
        CovidProject..CovidDeaths
    WHERE 
        continent IS NOT NULL
        AND TRY_CAST(new_cases AS FLOAT) IS NOT NULL
        AND TRY_CAST(new_deaths AS INT) IS NOT NULL
)
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
FROM 
    CleanedData
ORDER BY 
    total_cases, 
    total_deaths;


--Total Vaccinations vs. Population


WITH CleanedData AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        TRY_CAST(vac.new_vaccinations AS INT) AS new_vaccinations
    FROM 
        CovidProject..CovidDeaths dea
    JOIN 
        CovidProject..CovidVaccinations vac
    ON 
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
        AND TRY_CAST(vac.new_vaccinations AS INT) IS NOT NULL
)
SELECT 
    continent, 
    location, 
    date, 
    population, 
    new_vaccinations,
    SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS RollingPeopleVaccinated
    --, (RollingPeopleVaccinated/population)*100 -- Uncomment if needed
FROM 
    CleanedData
ORDER BY 
    location, 
    date;

--A CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        TRY_CAST(dea.population AS BIGINT) AS population,
        TRY_CAST(vac.new_vaccinations AS BIGINT) AS new_vaccinations,
        SUM(TRY_CAST(vac.new_vaccinations AS BIGINT)) OVER (
            PARTITION BY dea.Location 
            ORDER BY dea.location, dea.Date
        ) AS RollingPeopleVaccinated
    FROM 
        CovidProject..CovidDeaths dea
    JOIN 
        CovidProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
        AND TRY_CAST(vac.new_vaccinations AS BIGINT) IS NOT NULL
        AND TRY_CAST(dea.population AS BIGINT) IS NOT NULL
)
SELECT 
    Continent, 
    Location, 
    Date, 
    Population, 
    New_Vaccinations, 
    RollingPeopleVaccinated,
    (CAST(RollingPeopleVaccinated AS FLOAT) / CAST(Population AS FLOAT)) * 100 AS VaccinationPercentage
FROM 
    PopvsVac
ORDER BY 
    Location, Date;

--

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

-- Create the temporary table if it doesn't exist


IF OBJECT_ID('tempdb..#PercentPopulationVaccinated') IS NOT NULL
    DROP TABLE #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATE,
    population BIGINT,
    new_vaccinations BIGINT,
    RollingPeopleVaccinated BIGINT
);

-- Insert data into the temporary table


INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    TRY_CAST(dea.population AS BIGINT) AS population, 
    TRY_CAST(vac.new_vaccinations AS BIGINT) AS new_vaccinations,
    SUM(TRY_CAST(vac.new_vaccinations AS BIGINT)) OVER (
        PARTITION BY dea.Location 
        ORDER BY dea.location, dea.Date
    ) AS RollingPeopleVaccinated
FROM 
    CovidProject..CovidDeaths dea
JOIN 
    CovidProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
    AND TRY_CAST(vac.new_vaccinations AS BIGINT) IS NOT NULL;


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Stored View for Future Visualizations


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

