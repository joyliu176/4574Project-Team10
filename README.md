# Data Pipeline for Analytics Dashboards

Welcome to the repository for our Data Pipeline project! This pipeline streamlines the process of importing, cleaning, and transforming data for visualization and analysis. Below is an overview of the project structure, technology stack, and step-by-step workflow.

## Project Overview
The goal of this project is to automate the data flow from storage to visualization dashboards. The pipeline includes the following stages:

1. **Data Import:** Import raw data from Google Drive into Snowflake and Preset.
2. **Data Cleaning & Transformation:** Clean and manipulate the data in Snowflake to create fact and intermediate tables following a star schema.
3. **Final Edits:** Use dbt Cloud to refine intermediate tables and generate dimensional (dim) tables.
4. **Visualization:** Import the final dim tables into Preset to create interactive dashboards for client review.

---

## Technology Stack

- **Data Storage:** Google Drive
- **Data Warehouse:** Snowflake
- **Data Transformation:** dbt Cloud
- **Dashboarding Tool:** Preset (Apache Superset)

---

## Workflow

### Step 1: Import Data to Snowflake
The first step involves extracting raw data stored in Google Drive and importing it into Snowflake for centralized storage and processing. 

**Tools:**
- Google Drive API
- Snowflake Python Connector

### Step 2: Data Cleaning and Transformation in Snowflake
Within Snowflake, we:
- Perform data cleaning to handle missing or inconsistent values.
- Create base and intermediate tables following a star schema design to optimize data querying.

**Tools:**
- Snowflake SQL scripts

### Step 3: Final Edits with dbt Cloud
Intermediate tables are exported to dbt Cloud for advanced data transformations. The final output consists of dim and facts tables, which are designed for end-user reporting and analysis.

**Tools:**
- dbt Cloud

### Step 4: Create Dashboards in Preset
The dim tables are imported into Preset, where interactive dashboards are built for clients to explore and analyze the data.

**Tools:**
- Preset

---

## Key Features
- **Scalable Data Pipeline:** Designed to handle large datasets efficiently.
- **Star Schema Design:** Ensures optimized query performance and easy data exploration.
- **Interactive Dashboards:** Provides actionable insights via user-friendly visualizations.

---

## How to Use
1. Clone this repository:
   ```bash
   git clone https://github.com/4574Project-Team10.git
   ```
2. Configure the environment variables for Snowflake, dbt Cloud, and Preset.
3. Run the scripts in sequence to process and visualize your data.

---

## Future Improvements
- Automate the pipeline using orchestration tools like Apache Airflow.
- Enhance dashboard interactivity with additional filters and visualizations.

---

## Contributors
- **Yuelin Shen**
- **Yaping Liu**
- **Ceclia Lin**
- **Yicheng Wang**
