Healthcare Operations Analysis Using SQL
Project Overview

This project analyzes over 2.6 million hospital discharge records using SQL Server to uncover trends in healthcare utilization, patient outcomes, costs, diagnosis patterns, payer performance, and facility-level operations.

The goal was to simulate the type of exploratory and operational analysis performed by healthcare data analysts and business intelligence teams to support decision-making within hospitals and healthcare systems.

Dataset

Source: Kaggle Healthcare Discharge Dataset

Size: ~2.6 Million Records

Database: SQL Server

Key Fields
Length of Stay (LOS)
Total Charges
Total Costs
Diagnosis Description
Procedure Description
Hospital County
Facility Name
Age Group
Gender
Race
Admission Type
Patient Disposition
Primary Payer
Severity of Illness
Data Import Process

Because the dataset contained over 2.6 million records and included text fields with embedded commas, the standard SQL Server import wizard was not sufficient.

The data was successfully imported using BULK INSERT with CSV formatting and field quote handling.

BULK INSERT Discharges
FROM 'medical11.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
Business Questions Answered
Descriptive Analysis
Average length of stay by diagnosis
Most common diagnoses by discharge volume
Patient distribution by age group
Average hospital charges by county
Discharges by gender
Facilities with the highest average LOS
Average charges by primary payer
LOS by patient disposition
Most common procedures
Emergency vs Non-Emergency LOS comparison
Multi-Dimensional Analysis
Diagnosis and age groups with the highest charges
Charges by race and payer combination
Relationship between illness severity and charges
Admission type vs medical/surgical category
Diagnoses generating the highest healthcare costs
Primary payers associated with the longest LOS
Advanced Analytics
Facility-level LOS outlier detection using standard deviation analysis
Business & Operational Insights
Diagnoses with both high LOS and high charges
Counties generating the highest discharge volume and healthcare spending
Key Findings
High-Cost Diagnoses

Several diagnoses were associated with exceptionally long hospital stays and high healthcare spending:

Diagnosis	Avg LOS
Short Gestation / Low Birth Weight	25.13 days
Respiratory Distress Syndrome	23.51 days
Leukemias	18.69 days
Schizophrenia & Other Psych Disorders	18.07 days
Tuberculosis	17.78 days
Most Common Diagnoses

The highest-volume diagnoses included:

Diagnosis	Discharges
Liveborn	241,123
Mood Disorders	63,068
CHF	62,241
Septicemia	60,989
Chest Pain	60,055
Age Distribution

Hospital utilization increases significantly with age.

Age Group	Discharges
70+	725,253
50–69	680,166
30–49	547,383
0–17	387,353
18–29	281,978
Geographic Cost Differences

Average hospital charges varied considerably by county.

Top counties included:

Manhattan
Nassau
Rockland
Suffolk
Westchester

Manhattan recorded the highest average charges at approximately $43,167 per discharge.

Severity Drives Cost

A strong relationship exists between illness severity and hospital charges.

Severity	Avg Charges
Extreme	$109,425
Major	$40,769
Moderate	$24,277
Minor	$15,704
Emergency Admissions Stay Longer
Admission Type	Avg LOS
Emergency	5.77 days
Non-Emergency	4.76 days

Emergency patients remained hospitalized approximately 21% longer than non-emergency patients.

Largest Cost Drivers

The diagnoses generating the highest overall healthcare costs were:

Septicemia
Liveborn
Congestive Heart Failure (CHF)
Coronary Atherosclerosis
Device / Implant Complications
County-Level Utilization

The counties with the highest healthcare utilization and spending were:

Manhattan
Kings
Queens
Nassau
Bronx

These counties represented the largest concentration of hospital activity within the dataset.

Outlier Facilities

Using standard deviation analysis, several facilities were identified as significant LOS outliers compared to diagnosis-specific averages.

Examples included:

St Joseph's Hospital Health Center
Calvary Hospital
Interfaith Medical Center
Blythedale Children's Hospital
Summit Park Hospital

These facilities exhibited LOS values substantially higher than peer hospitals treating similar diagnoses.

SQL Skills Demonstrated
Aggregate Functions
COUNT()
AVG()
SUM()
Data Type Conversion
TRY_CAST()
Common Table Expressions (CTEs)
Multi-Level Grouping
Conditional Logic
CASE Statements
Outlier Detection
Standard Deviation Analysis
STDEV()
Data Cleaning Techniques
Operational KPI Development
Repository Structure
Healthcare-Operations-Analysis-Using-SQL/
│
├── Healthcare_Discharge_Analysis.sql
├── README.md
└── screenshots/
Tools Used
SQL Server
SQL Server Management Studio (SSMS)
Kaggle
GitHub
Author

Oluwatosin Thomas

Data Analyst | SQL | Python | Power BI | Business Intelligence
