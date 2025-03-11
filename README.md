# 🌍 **Energy Mix Database System**

## **📌 Project Overview**
- The Energy Mix Database System is a structured SQL-based database designed to store, manage, and analyze energy sources data efficiently. This system provides an organized way to track different energy sources, their production, consumption, and distribution patterns, facilitating better decision-making in energy management, policy-making, and sustainability efforts.
- With a focus on both developed and developing countries, this database allows users to analyze trends in renewable energy, fossil fuels, nuclear energy, emissions, and carbon intensity, contributing to a data-driven approach to energy transition strategies.
  
## **📂 Repository Contents**
- Energy Mix Database System.sql - The SQL script to set up the database schema, including tables, relationships, and data.
- filtered_data.xlsx - A structured dataset containing processed or refined energy-related data for further use in the system.
- queries.sql - A collection of pre-written SQL queries to analyze energy data, covering consumption analysis, emissions insights, and comparisons across countries and regions.
- owid-energy-data.csv - Raw energy source data from Our World in Data (OWID), a comprehensive dataset covering historical and modern energy metrics.
- owid-energy-codebook.csv - A structured file detailing the units, descriptions, and sources for all columns in the dataset, ensuring proper understanding and use of the data.

## **🏗️ Key Features**
- Well-defined Relational Database Schema for energy mix data.
- Optimized SQL Queries to analyze energy sources, consumption, and emissions data.
- Support for Multiple Energy Sources, including Renewables (solar, wind, hydro, etc.), Fossil Fuels, and Nuclear energy.
- Covers both developed and developing countries to compare energy trends.

## **📝 Database Structure**
The database consists of key relational tables, designed for efficient energy data management:

### **Main Tables**
- energy_share
    - Stores data on energy production, consumption, energy mix, emissions, and carbon intensity.
    - Covers fossil fuels, renewables, and nuclear energy sources.
    - Allows comparisons across countries, regions, and time periods.
- country_classification
    - Categorizes countries as Developed or Developing for comparative analysis.

