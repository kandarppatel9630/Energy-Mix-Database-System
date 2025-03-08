/*
-- ---------------------------------------------------------------------------------------------------------------------------
-- Project: "Energy Mix Database System"
-- Description: Database schema designed to store and analyze country-specific data related to energy consumption, electricity demand, renewable and non-renewable energy shares, and greenhouse gas (GHG) emissions. 
				It provides insights into historical and current trends, comparative analysis between developed and developing countries, and the impact of renewable energy adoption on carbon intensity and GHG emissions.
-- Author: Kandarp Patel
-- Creation Period: March 2025 
*/

-- ----------------------------------------------------------------------
-- DATABASE CREATION
-- ----------------------------------------------------------------------

CREATE DATABASE energy_mix;
USE energy_mix;

-- ----------------------------------------------------------------------
-- TABLE CREATION
-- ----------------------------------------------------------------------

CREATE TABLE energy_share ( 
    id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(100),
    year INT,
    iso_code VARCHAR(10),
    biofuel_share_elec FLOAT,
    biofuel_share_energy FLOAT,
    carbon_intensity_elec FLOAT,
    coal_share_elec FLOAT,
    coal_share_energy FLOAT,
    electricity_demand FLOAT,
    electricity_generation FLOAT,
    electricity_share_energy FLOAT,
    energy_per_gdp FLOAT,
    fossil_share_elec FLOAT,
    fossil_share_energy FLOAT,
    gas_share_elec FLOAT,
    gas_share_energy FLOAT,
    greenhouse_gas_emissions FLOAT,
    hydro_share_elec FLOAT,
    hydro_share_energy FLOAT,
    low_carbon_share_elec FLOAT,
    low_carbon_share_energy FLOAT,
    net_elec_imports FLOAT,
    net_elec_imports_share_demand FLOAT,
    nuclear_share_elec FLOAT,
    nuclear_share_energy FLOAT,
    oil_share_elec FLOAT,
    oil_share_energy FLOAT,
    primary_energy_consumption FLOAT,
    renewables_share_elec FLOAT,
    renewables_share_energy FLOAT,
    solar_share_elec FLOAT,
    solar_share_energy FLOAT,
    wind_share_elec FLOAT,
    wind_share_energy FLOAT
);

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE country_classification (
	country VARCHAR(100) PRIMARY KEY,
    category ENUM('Developed', 'Developing')
    );

INSERT INTO country_classification (country, category) VALUES
-- Developed Countries
('Australia', 'Developed'),
('Belgium', 'Developed'),
('Canada', 'Developed'),
('Czechia', 'Developed'),
('Denmark', 'Developed'),
('Finland', 'Developed'),
('France', 'Developed'),
('Germany', 'Developed'),
('Hungary', 'Developed'),
('Israel', 'Developed'),
('Italy', 'Developed'),
('Japan', 'Developed'),
('Netherlands', 'Developed'),
('New Zealand', 'Developed'),
('Norway', 'Developed'),
('Poland', 'Developed'),
('Portugal', 'Developed'),
('Slovakia', 'Developed'),
('South Korea', 'Developed'),
('Spain', 'Developed'),
('Sweden', 'Developed'),
('Switzerland', 'Developed'),
('United Kingdom', 'Developed'),
('United States', 'Developed'),

-- Developing Countries
('Brazil', 'Developing'),
('Chile', 'Developing'),
('China', 'Developing'),
('India', 'Developing'),
('Iran', 'Developing'),
('Pakistan', 'Developing'),
('Philippines', 'Developing'),
('Russia', 'Developing'),
('Saudi Arabia', 'Developing'),
('South Africa', 'Developing'),
('Ukraine', 'Developing');

-- ----------------------------------------------------------------------
-- Analytical Queries Section
-- ----------------------------------------------------------------------

# Q1. How have fossil fuel and renewable energy trends changed over time across all countries?
-- This query calculates the average share of fossil fuels and renewable energy in total primary energy consumption for each year, aggregated across all countries.

SELECT 
	year AS `Year`, 
	ROUND(AVG(renewables_share_energy), 2) AS `Avg. Renewable Energy Share (%)`, 
	ROUND(AVG(fossil_share_energy), 2) AS `Avg. Fossil Fuel Share (%)`
FROM energy_share
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q2. Top 15 countries by highest renewable energy share in total energy consumption in 2023
-- This query retrieves the 15 countries with the highest percentage share of renewable energy in their total primary energy consumption for the year 2023.

SELECT 
	country AS `Country`, 
    ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`
FROM energy_share
WHERE year = (SELECT MAX(year) from energy_share)
ORDER BY renewables_share_energy DESC
LIMIT 15;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q3. Top 10 countries with highest renewable energy growth from 2000 to the year 2023
-- This query identifies countries with the most significant growth in renewable energy share by comparing values from the year 2000 to the year 2023.

SELECT 
	country AS `Country`,
	MAX(CASE WHEN year = (SELECT MIN(year) FROM energy_share) THEN ROUND(renewables_share_energy, 2) END) AS `Renewable Energy Share in 2000 (%)`,
	MAX(CASE WHEN year = (SELECT MAX(year) FROM energy_share) THEN ROUND(renewables_share_energy, 2) END) AS `Renewable Energy Share in 2023 (%)`,
	ROUND(
	(MAX(CASE WHEN year = (SELECT MAX(year) FROM energy_share) THEN renewables_share_energy END) -
	MAX(CASE WHEN year = (SELECT MIN(year) FROM energy_share) THEN renewables_share_energy END)), 2
	) AS `Renewable Energy Growth (%)`
FROM energy_share
GROUP BY country
HAVING `Renewable Energy Share in 2000 (%)` > 0 AND `Renewable Energy Share in 2023 (%)` > 0 -- Exclude cases where either year had 0%
ORDER BY `Renewable Energy Growth (%)` DESC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q4. How have fossil fuel and renewable energy trends changed over time for Germany?
-- This query shows the annual renewable and fossil fuel energy shares for Germany, highlighting how Germany’s energy mix has evolved over time.

SELECT 
	year AS `Year`, 
	ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`, 
	ROUND(fossil_share_energy, 2) AS `Fossil Fuel Share (%)`
FROM energy_share
WHERE country = 'Germany'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q5. How have fossil fuel and renewable energy trends changed over time for India?
-- This query shows the annual renewable and fossil fuel energy shares for India, highlighting how India’s energy mix has evolved over time.

SELECT 
	year AS `Year`, 
	ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`, 
	ROUND(fossil_share_energy, 2) AS `Fossil Fuel Share (%)`
FROM energy_share
WHERE country = 'India'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q6. Contribution of different renewable energy sources (Solar, Wind, Hydro, Bioenergy) to total energy consumption over time across all countries
-- This query calculates annual average contributions (%) of each renewable energy source across all analyzed countries, highlighting the evolution of renewable energy mix.

SELECT 
	year AS `Year`, 
	ROUND(AVG(solar_share_energy), 3) AS `Avg. Solar Energy Share (%)`, 
	ROUND(AVG(wind_share_energy), 3) AS `Avg. Wind Energy Share (%)`, 
	ROUND(AVG(hydro_share_energy), 3) AS `Avg. Hydropower Share (%)`, 
	ROUND(AVG(biofuel_share_energy), 3) AS `Avg. Bioenergy Share (%)`
FROM energy_share
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q7. How much has nuclear power contributed (%) to primary energy consumption across all countries over time?
-- This query calculates the annual average share of nuclear energy in primary energy consumption, aggregated across all countries, highlighting the trend of nuclear energy usage over the analyzed period.

SELECT 
	year AS `Year`, 
	ROUND(AVG(nuclear_share_energy), 2) AS `Avg. Nuclear Energy Share (%)`
FROM energy_share
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q8. What is the share (%) of electricity in total energy consumption for each country over time?
-- This query retrieves the annual percentage share of electricity within total energy consumption for each country. It is useful for analyzing country-level trends in electrification and energy transition patterns.

SELECT 
	country AS `Country`, 
	year AS `Year`,
	Round(electricity_share_energy, 2) AS `Electricity Share in Total Energy (%)`
FROM energy_share
ORDER BY country, year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q9. Top 10 countries with highest growth in electricity share within total energy consumption
-- This query identifies the top 10 countries with the greatest increase in electricity's share (%) of their total energy consumption, highlighting significant electrification trends from 2000 to 2023.

SELECT 
	country AS `Country`,
	MAX(CASE WHEN year = (SELECT MIN(year) FROM energy_share) THEN Round(electricity_share_energy, 2) END) AS `Electricity Share in 2000 (%)`,
	MAX(CASE WHEN year = (SELECT MAX(year) FROM energy_share) THEN Round(electricity_share_energy, 2) END) AS `Electricity Share in 2023 (%)`,
	ROUND(
	(MAX(CASE WHEN year = (SELECT MAX(year) FROM energy_share) THEN electricity_share_energy END) -
	MAX(CASE WHEN year = (SELECT MIN(year) FROM energy_share) THEN electricity_share_energy END)), 2
	) AS `Growth in Electricity Share (%)`
FROM energy_share
GROUP BY country
HAVING `Electricity Share in 2000 (%)` > 0 AND `Electricity Share in 2023 (%)` > 0  -- Exclude cases where either year had 0
ORDER BY `Growth in Electricity Share (%)` DESC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q10. Electricity generation share (%) from fossil fuels, renewable energy, and nuclear power for Germany and India over the analyzed period
-- This query retrieves yearly data showing the percentage contributions of fossil fuels, renewable sources, and nuclear energy specifically in electricity generation for Germany and India.

SELECT
    country AS `Country`,
    year AS `Year`,
    Round(fossil_share_elec, 2) AS `Fossil Fuel Share (%)`,
    Round(renewables_share_elec, 2) AS `Renewable Energy Share (%)`,
    Round(nuclear_share_elec, 2) AS `Nuclear Energy Share (%)` 
FROM energy_share 
WHERE country = 'Germany'
OR country = 'India'
ORDER BY country, year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q11. How has carbon intensity of electricity changed as renewable energy share in electricity has increased, aggregated across all countries?
/* "This query calculates annual average values for renewable energy’s share in electricity generation and the carbon intensity of electricity generation (grams of CO2 equivalents per kilowatt hour - gCO2/kWh), 
	aggregated across all analyzed countries, to illustrate how increasing renewable energy share affects carbon intensity over time. */

SELECT
    year AS `Year`,
    ROUND(AVG(renewables_share_elec), 2) AS `Avg. Renewable Electricity Share (%)`,
    ROUND(AVG(carbon_intensity_elec), 2) AS `Avg. Carbon Intensity (gCO2/kWh)`
FROM energy_share 
GROUP BY year 
ORDER BY year;	

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Q12. How has greenhouse gas emissions changed as renewable energy share in total energy consumption has increased for Germany?
/* "This query calculates annual average values for renewable energy’s share in total energy consumption and the GHG emissions (million tonnes of CO2 equivalents - MtCO2e), for Germany, 
	to illustrate how increasing renewable energy share affects GHG emissions over time. */

SELECT
    year AS `Year`,
    ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`,
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share 
Where country = 'Germany'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q13. How has the share of renewable energy evolved over time for Developed vs. Developing countries?
-- This query calculates the annual average renewable energy share (%) separately for developed and developing countries to illustrate their differing renewable energy adoption trends over time.

SELECT 
	year AS `Year`, 
	ROUND(AVG(CASE WHEN c.category = 'Developed' THEN e.renewables_share_energy END), 2) AS  `Developed Countries (%)`,
	ROUND(AVG(CASE WHEN c.category = 'Developing' THEN e.renewables_share_energy END), 2) AS `Developing Countries (%)`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q14. How has primary energy consumption evolved over time for Developed and Developing countries?
-- This query calculates the total primary energy consumption (aggregated annually) for Developed and Developing countries separately, highlighting trends and differences in energy consumption patterns over time.

SELECT 
	year AS `Year`, 
	ROUND(SUM(CASE WHEN c.category = 'Developed' THEN e.primary_energy_consumption END), 2) AS `Developed Countries (TWh)`,
	ROUND(SUM(CASE WHEN c.category = 'Developing' THEN e.primary_energy_consumption END), 2) AS `Developing Countries (TWh)`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q15. How has the share of electricity in total energy consumption evolved over time for Developed vs. Developing countries?
-- This query calculates the average share (%) of electricity within total primary energy consumption for Developed and Developing countries, illustrating differences and trends over time.

SELECT 
	year AS `Year`, 
	ROUND(AVG(CASE WHEN c.category = 'Developed' THEN e.electricity_share_energy END), 2) AS `Avg. Electricity Share (%) - Developed Countries`,
	ROUND(AVG(CASE WHEN c.category = 'Developing' THEN e.electricity_share_energy END), 2) AS `Avg. Electricity Share (%) - Developing Countries`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q16. How has electricity carbon intensity evolved over time for Developed vs. Developing countries?
-- This query calculates the annual average carbon intensity (gCO2/kWh) of electricity generation, for Developed and Developing countries, highlighting differences and trends in carbon intensity.

SELECT 
	year AS `Year`, 
	ROUND(AVG(CASE WHEN c.category = 'Developed' THEN e.carbon_intensity_elec END), 2) AS `Avg. Carbon Intensity (gCO2/kWh) - Developed Countries`,
	ROUND(AVG(CASE WHEN c.category = 'Developing' THEN e.carbon_intensity_elec END), 2) AS `Avg. Carbon Intensity (gCO2/kWh) - Developing Countries`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q17. Top 10 countries with the highest reliance on fossil fuels for total energy consumption (2023)
-- This query retrieves the 10 countries most dependent on fossil fuels in their total primary energy consumption for the latest available year (2023). It also includes their classification as Developed or Developing countries.

SELECT 
	e.country AS `Country`, 
    ROUND(e.fossil_share_energy, 2) AS `Fossil Fuel Share (%)`, 
    c.category AS `Country Classification`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE e.year = (SELECT MAX(year) FROM energy_share) 
ORDER BY e.fossil_share_energy DESC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q18. Top 10 countries with the least reliance on fossil fuels for total energy consumption (2023)
-- This query retrieves the 10 countries least dependent on fossil fuels in their total primary energy consumption for the latest available year (2023). It also includes their classification as Developed or Developing countries.

SELECT 
	e.country AS `Country`, 
    ROUND(e.fossil_share_energy, 2) AS `Fossil Fuel Share (%)`, 
    c.category AS `Country Classification`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE e.year = (SELECT MAX(year) FROM energy_share) AND e.fossil_share_energy > 0
ORDER BY e.fossil_share_energy ASC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q19. Which 10 countries had the highest reliance on fossil fuels for generating electricity in 2023?
-- This query retrieves the 10 countries most dependent on fossil fuels for electricity generation in the latest available year (2023). It also includes their classification as Developed or Developing countries.

SELECT 
	e.country AS `Country`, 
	ROUND(e.fossil_share_elec, 2) AS `Fossil Fuel Share in Electricity (%)`, 
	c.category AS `Country Classification`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE e.year = (SELECT MAX(year) FROM energy_share) 
ORDER BY e.fossil_share_elec DESC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q20. Which 10 countries had the least reliance on fossil fuels for generating electricity in 2023?
-- This query retrieves the 10 countries least dependent on fossil fuels for electricity generation in the latest available year (2023). It also includes their classification as Developed or Developing countries.

SELECT 
	e.country AS `Country`, 
	ROUND(e.fossil_share_elec, 2) AS `Fossil Fuel Share in Electricity (%)`, 
	c.category AS `Country Classification`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE e.year = (SELECT MAX(year) FROM energy_share) AND e.fossil_share_elec > 0  -- Excludes cases where fossil share is 0 to avoid misleading results
ORDER BY e.fossil_share_elec ASC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q21. Which 10 countries have the highest electricity demand in the year 2023?
-- This query retrieves the 10 countries with the highest total electricity demand (TWh) in the latest year. It also includes their classification as Developed or Developing countries.

SELECT 
	e.country AS `Country`, 
	ROUND(e.electricity_demand, 2) AS `Electricity demand (TWh)`, 
    c.category AS `Country Classification`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE e.year = (SELECT MAX(year) FROM energy_share)
ORDER BY e.electricity_demand DESC
LIMIT 10; 

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q22. Which 10 countries have the highest energy consumption in the year 2023?
-- This query retrieves the 10 countries with the highest energy consumption (TWh) in the latest year. It also includes their classification as Developed or Developing countries.

SELECT 
	e.country AS `Country`, 
    e.primary_energy_consumption AS `Energy Consumption (TWh)`, 
    c.category AS `Country Classification`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE e.year = (SELECT MAX(year) FROM energy_share) 
ORDER BY e.primary_energy_consumption DESC
LIMIT 10; 

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q23. Which countries have the highest greenhouse gas emissions in 2023?
-- This query retrieves the top 10 countries with the highest greenhouse gas emissions (MtCO2e) in 2023.

SELECT 
	country AS `Country`, 
	greenhouse_gas_emissions AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE year = (SELECT MAX(year) FROM energy_share)
ORDER BY greenhouse_gas_emissions DESC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q24. How have greenhouse gas emissions evolved over time across all analyzed countries?
-- This query calculates the annual average greenhouse gas (GHG) emissions (MtCO2e) across all analyzed countries to observe long-term trends in emissions.

SELECT 
	year AS `Year`, 
    ROUND(AVG(greenhouse_gas_emissions), 2) AS `Avg. GHG Emissions (MtCO2e)`
FROM energy_share
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q25. How have India's GHG emissions evolved over time?
-- This query retrieves India's annual greenhouse gas (GHG) emissions (MtCO2e) over time, allowing for an analysis of trends in emissions growth or reduction.

SELECT 
	year AS `Year`, 
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'India' 
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q26. How have Germany's GHG emissions evolved over time?
-- This query retrieves Germany's annual greenhouse gas (GHG) emissions (MtCO2e) over time, allowing for an analysis of trends in emissions growth or reduction.

SELECT 
	year AS `Year`, 
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'Germany' 
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q27. How have USA's GHG emissions evolved over time?
-- This query retrieves USA's annual greenhouse gas (GHG) emissions (MtCO2e) over time, allowing for an analysis of trends in emissions growth or reduction.

SELECT 
	year AS `Year`, 
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'United States' 
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q28. How have China's GHG emissions evolved over time?
-- This query retrieves China's annual greenhouse gas (GHG) emissions (MtCO2e) over time, allowing for an analysis of trends in emissions growth or reduction.

SELECT 
	year AS `Year`, 
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'China' 
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q29. How have Japan's GHG emissions evolved over time?
-- This query retrieves Japan's annual greenhouse gas (GHG) emissions (MtCO2e) over time, allowing for an analysis of trends in emissions growth or reduction.

SELECT 
	year AS `Year`, 
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'Japan' 
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q30. Comparison of GHG emissions between Dveloped and Developing countries
-- This query compares the total greenhouse gas (GHG) emissions (MtCO2e) of Developed and Developing countries over time. It helps in understanding emission trends based on economic classification.

SELECT 
	year AS `Year`, 
	ROUND(SUM(CASE WHEN c.category = 'Developed' THEN e.greenhouse_gas_emissions END), 2) AS `Total GHG Emissions (MtCO2e) - Developed Countries`,
	ROUND(SUM(CASE WHEN c.category = 'Developing' THEN e.greenhouse_gas_emissions END), 2) AS `Total GHG Emissions (MtCO2e) - Developing Countries`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
GROUP BY e.year
ORDER BY e.year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q31. How has the increase in renewable energy share impacted greenhouse gas emissions in Germany over time?
-- This query retrieves Germany's annual renewable energy share (%) and total GHG emissions over time. The results help analyze the relationship between increasing renewable energy adoption and changes in emissions.

SELECT 
	year AS `Year`,
    ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`,
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'Germany'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q32. How has the increase in renewable energy share impacted greenhouse gas emissions in the USA over time?
-- This query retrieves USA's annual renewable energy share (%) and total GHG emissions over time. The results help analyze the relationship between increasing renewable energy adoption and changes in emissions.

SELECT 
	year AS `Year`,
    ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`,
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'United States'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q33. How has the increase in renewable energy share impacted greenhouse gas emissions in India over time?
-- This query retrieves India's annual renewable energy share (%) and total GHG emissions over time. The results help analyze the relationship between increasing renewable energy adoption and changes in emissions.

SELECT 
	year AS `Year`,
    ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`,
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'India'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q34. How has the increase in renewable energy share impacted greenhouse gas emissions in China over time?
-- This query retrieves China's annual renewable energy share (%) and total GHG emissions over time. The results help analyze the relationship between increasing renewable energy adoption and changes in emissions.

SELECT 
	year AS `Year`,
    ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`,
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'China'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q35. How has the increase in renewable energy share impacted greenhouse gas emissions in Japan over time?
-- This query retrieves Japan's annual renewable energy share (%) and total GHG emissions over time. The results help analyze the relationship between increasing renewable energy adoption and changes in emissions.

SELECT 
	year AS `Year`,
    ROUND(renewables_share_energy, 2) AS `Renewable Energy Share (%)`,
    ROUND(greenhouse_gas_emissions, 2) AS `GHG Emissions (MtCO2e)`
FROM energy_share
WHERE country = 'Japan'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q36. How has the increase in renewable energy share impacted greenhouse gas emissions in Developing countries?
-- This query examines how the adoption of renewable energy has influenced GHG emissions in Developing countries over time. It calculates the average renewable energy share (%) and total emissions for each year.

SELECT 
	e.year AS `Year`,
    c.category AS 'Country Classification', 
    ROUND(AVG(e.renewables_share_energy), 2) AS `Avg. Renewable Energy Share (%)`,
    ROUND(SUM(e.greenhouse_gas_emissions), 2) AS `Total GHG Emissions (MtCO2e)`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE c.category = 'Developing'
GROUP BY e.year
ORDER BY e.year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q37. How has the increase in renewable energy share impacted greenhouse gas emissions in Developed countries?
-- This query examines how the adoption of renewable energy has influenced GHG emissions in Developed countries over time. It calculates the average renewable energy share (%) and total emissions for each year.

SELECT 
	e.year AS `Year`,
    c.category AS 'Country Classification', 
    ROUND(AVG(e.renewables_share_energy), 2) AS `Avg. Renewable Energy Share (%)`,
    ROUND(SUM(e.greenhouse_gas_emissions), 2) AS `Total GHG Emissions (MtCO2e)`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
WHERE c.category = 'Developed'
GROUP BY e.year
ORDER BY e.year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q38. Which countries import the most electricity (Top 10)?
-- This query retrieves the top 10 countries with the highest net electricity imports (TWh) in the latest available year (2023). The results help identify the largest electricity importers.

SELECT 
	country AS `Country`, 
    ROUND(net_elec_imports, 2) AS `Electricity Imported (TWh)`
FROM energy_share
WHERE year = (SELECT MAX(year) from energy_share)
ORDER BY net_elec_imports DESC
LIMIT 10; 

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q39. Which 10 countries have the highest share of electricity imports relative to their total electricity demand in 2023?
-- This query retrieves the 10 countries with the highest share of electricity imports as a percentage of their total electricity demand in 2023. It helps identify countries most reliant on imported electricity.

SELECT 	
	country AS `Country`, 
    ROUND(net_elec_imports_share_demand, 2) AS `Electricity Imports Share of Demand (%)`
FROM energy_share
WHERE year = (SELECT MAX(year) FROM energy_share)
ORDER BY net_elec_imports_share_demand DESC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q40. How has India's reliance on electricity imports as a share of total demand evolved over time?
-- This query tracks India's electricity imports as a percentage of total electricity demand over time. It helps analyze whether India's dependency on imported electricity has increased or decreased.

SELECT 
	year AS `Year`, 
    ROUND(net_elec_imports_share_demand, 2) AS `Electricity Imports Share of Demand (%)`
FROM energy_share
WHERE country = 'India'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q41. How has Germany's reliance on electricity imports as a share of total demand changed over time?
-- This query tracks Germany's electricity imports as a percentage of total electricity demand over time. It helps analyze whether Germany's dependency on imported electricity has increased or decreased. 

SELECT 
	year AS `Year`, 
    ROUND(net_elec_imports_share_demand, 2) AS `Electricity Imports Share of Demand (%)`
FROM energy_share
WHERE country = 'Germany'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q42. Which 10 countries have the highest share of low-carbon energy in their total energy mix in the latest year?
-- This query retrieves the 10 countries with the highest share of low-carbon energy (including renewables and nuclear) in their total primary energy consumption for 2023. 

SELECT  
	country AS `Country`, 
    ROUND(low_carbon_share_energy, 2) AS `Low-Carbon Energy Share (%)`
FROM energy_share
WHERE year = (SELECT MAX(year) FROM energy_share)
ORDER BY low_carbon_share_energy DESC
LIMIT 10;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q43. How has the share of low-carbon sources evolved over time in total energy and electricity generation across all countries?
-- This query tracks the trend of low-carbon source adoption in both total primary energy consumption and electricity generation across all countries.

SELECT 
	year AS `Year`, 
    ROUND(AVG(low_carbon_share_energy), 2) AS `Avg. Low-Carbon Energy Share (%)`, 
    ROUND(AVG(low_carbon_share_elec), 2) AS `Avg. Low-Carbon Electricity Share (%)`
FROM energy_share
GROUP BY year
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q44. How does the share of low-carbon energy differ between developed and developing countries over time?
-- This query compares the average share of low-carbon energy (%) between Developed and Developing countries over time. It helps analyze how these two groups are adopting low-carbon energy at different rates.

SELECT 
	e.year AS `Year`, 
	ROUND(AVG(CASE WHEN c.category = 'Developed' THEN e.low_carbon_share_energy END), 2) AS `Low-Carbon Energy Share (%) - Developed Countries`,
	ROUND(AVG(CASE WHEN c.category = 'Developing' THEN e.low_carbon_share_energy END), 2) AS `Low-Carbon Energy Share (%) - Developing Countries`
FROM energy_share e
JOIN country_classification c ON e.country = c.country
GROUP BY e.year
ORDER BY e.year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q45. How has Germany's share of low-carbon sources evolved over time in total energy and electricity generation?
-- This query tracks Germany's adoption of low-carbon energy sources (nuclear + renewable) over time. It retrieves annual data on the share of low-carbon energy in total primary energy consumption and in electricity generation.

SELECT  
	year AS `Year`, 
    ROUND(low_carbon_share_energy, 2) AS `Low-Carbon Energy Share (%)`, 
    ROUND(low_carbon_share_elec, 2) AS `Low-Carbon Electricity Share (%)`
FROM energy_share
WHERE country = 'Germany'
ORDER BY year;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

# Q46. How has India's share of low-carbon sources evolved over time in total energy and electricity generation?
-- This query tracks India's adoption of low-carbon energy sources (nuclear + renewable) over time. It retrieves annual data on the share of low-carbon energy in total primary energy consumption and in electricity generation.

SELECT  
	year AS `Year`, 
    ROUND(low_carbon_share_energy, 2) AS `Low-Carbon Energy Share (%)`, 
    ROUND(low_carbon_share_elec, 2) AS `Low-Carbon Electricity Share (%)`
FROM energy_share
WHERE country = 'India'
ORDER BY year;

-- -x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-
