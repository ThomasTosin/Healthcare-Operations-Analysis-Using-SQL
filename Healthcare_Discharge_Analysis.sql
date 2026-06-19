/* =========================================================
   HEALTHCARE DISCHARGE DATA ANALYSIS
   ========================================================= */

Use HospitalData;

/* =========================================================
            DESCRIPTIVE ANALYSIS (Question 1-10)
   ========================================================= */

--1. What is the average length of stay (LOS) by diagnosis description?
SELECT CCS_Diagnosis_Description,
       Round(AVG(TRY_CAST(Length_Of_Stay AS FLOAT)), 2) AS Avg_LOS
FROM dbo.Discharges
GROUP BY CCS_Diagnosis_Description
ORDER BY Avg_LOS Desc;

--2. What are the top 10 most common diagnoses by total discharges?
Select Top 10
       CCS_Diagnosis_Description,
	   Count(*) as Tot_Dis
From dbo.Discharges
Group by CCS_Diagnosis_Description
ORDER by Tot_Dis Desc;


--3. What is the distribution of patients by age group?
Select Age_Group,
       Count(*) as Tot_Discharge
From dbo.Discharges
Group by Age_Group
Order by Tot_Discharge Desc;

--Another option for the order by 
Select Age_Group,
       Count(*) as Tot_Discharge
From dbo.Discharges
Group by Age_Group
ORDER BY 
    CASE Age_Group
        WHEN '0 to 17' THEN 1
        WHEN '18 to 29' THEN 2
        WHEN '30 to 49' THEN 3
        WHEN '50 to 69' THEN 4
        WHEN '70 or Older' THEN 5
    END;

--4. What is the average total charges by hospital county?
Select Hospital_County,
       Round(Avg(Try_cast (Total_Charges as float)), 2) as Avg_Charges
from dbo.Discharges
Group by Hospital_County
Order by Avg_Charges Desc;


--5. What is the total number of discharges by gender?
Select 
      Gender,
      Count(*) as Tot_discharge
From dbo.Discharges
Group by Gender
Order by Tot_discharge Desc;


-- 6. Which facilities have the highest average length of stay?
Select Facility_Name,
       Round(AVG(TRY_CAST(Length_Of_Stay AS FLOAT)), 2) AS Avg_LOS
From dbo.Discharges
Group by Facility_Name
Order by Avg_LOS Desc;

--7.  What is the average total charges by primary payer?
Select Source_of_Payment_1 as Primary_Payer,
       Round(Avg(Try_cast (Total_Charges as float)), 2) as Avg_Charges
from dbo.Discharges
Group by Source_of_Payment_1
Order by Avg_Charges Desc;

--8.  How does average length of stay vary by patient disposition?
Select Patient_Disposition,
       Round(Avg(Try_Cast(Length_of_Stay as Float)), 2) as Avg_LOS
From dbo.Discharges
Group by Patient_Disposition
Order by Avg_LOS Desc;

--9.  What are the top 5 procedures by total discharges?
Select Top 5 
       CCS_Procedure_Description,
       Count(*) as Tot_Discharge
from dbo.Discharges
Group by CCS_Procedure_Description
Order by Tot_Discharge desc;


--10. What is the average length of stay for emergency vs. non-emergency admissions?
SELECT
    CASE
        WHEN Type_of_Admission = 'Emergency' THEN 'Emergency'
        ELSE 'Non-Emergency'
    END AS Type_of_Admission,
    ROUND(AVG(TRY_CAST(Length_of_Stay AS FLOAT)), 2) AS Avg_LOS
FROM dbo.Discharges
GROUP BY
    CASE
        WHEN Type_of_Admission = 'Emergency' THEN 'Emergency'
        ELSE 'Non-Emergency'
    END
ORDER BY Avg_LOS desc;

/* =========================================================
               MULTI-DIMENSIONAL ANALYSIS 
   ========================================================= */

--11. Which diagnosis and age group combinations have the highest average total charges?
Select Top 10
       CCS_Diagnosis_Description,
       Age_Group,
	   Round(Avg(Try_cast(Total_Charges as float)), 2) as Avg_Charges
from dbo.Discharges
Group by CCS_Diagnosis_Description,
       Age_Group
Order by Avg_Charges desc;

--12.  How do total charges vary by race and primary payer?
Select Race,
       Source_of_Payment_1 as Primary_Payer,
	   Round(Avg(Try_Cast(Total_Charges as float)), 2) as Avg_Charges
from dbo.Discharges
group by Race,
         Source_of_Payment_1
Order by Avg_Charges desc;

-- 13.  What is the relationship between severity of illness and total charges?
Select APR_Severity_of_Illness_Description as Illness_Severity,
       Round(Avg(Try_cast(Total_Charges as float)), 2) as Avg_Charges
from dbo.Discharges
Group by APR_Severity_of_Illness_Description
Order by Avg_Charges desc;

-- 14. What is the distribution of discharges by admission type and medical/surgical category?
Select Type_of_Admission,
       APR_Medical_Surgical_Description as Category,
	   Count(*) as Tot_discharges
from dbo.Discharges
Group by Type_of_Admission,
         APR_Medical_Surgical_Description
Order by Tot_discharges desc;

--15.  Which diagnoses contribute the highest total healthcare costs?
Select Top 10
       CCS_Diagnosis_Description,
       Round(Sum(Try_Cast(Total_Costs as float)), 2) as Tot_Cost
From dbo.Discharges
Group by CCS_Diagnosis_Description
Order by Tot_Cost desc;

--16. Which primary payers are associated with the highest average LOS?
SELECT
    Source_of_Payment_1 AS Primary_Payer,
    COUNT(*) AS Total_Discharges,
    ROUND(AVG(TRY_CAST(Length_of_Stay AS FLOAT)), 2) AS Avg_LOS
FROM dbo.Discharges
GROUP BY Source_of_Payment_1
ORDER BY Avg_LOS DESC;

/* =========================================================
             ADVANCED ANALYTICS
   ========================================================= */

--17.  Which facilities are outliers in average length of stay for a given diagnosis?
WITH FacilityLOS AS
(
    SELECT
        Facility_Name,
        CCS_Diagnosis_Description,
        AVG(TRY_CAST(Length_of_Stay AS FLOAT)) AS Avg_LOS
    FROM dbo.Discharges
    GROUP BY Facility_Name, CCS_Diagnosis_Description
),
DiagnosisStats AS
(
    SELECT
        CCS_Diagnosis_Description,
        AVG(Avg_LOS) AS Diagnosis_Avg,
        STDEV(Avg_LOS) AS Diagnosis_StdDev
    FROM FacilityLOS
    GROUP BY CCS_Diagnosis_Description
)
SELECT
    f.Facility_Name,
    f.CCS_Diagnosis_Description,
    ROUND(f.Avg_LOS,2) AS Avg_LOS,
    ROUND(d.Diagnosis_Avg,2) AS Diagnosis_Avg,
    ROUND(d.Diagnosis_StdDev,2) AS StdDev
FROM FacilityLOS f
JOIN DiagnosisStats d
    ON f.CCS_Diagnosis_Description = d.CCS_Diagnosis_Description
WHERE ABS(f.Avg_LOS - d.Diagnosis_Avg) > 2 * d.Diagnosis_StdDev
ORDER BY f.Avg_LOS DESC;

/* =========================================================
               BUSINESS & OPERATIONAL INSIGHTS
   ========================================================= */

--18. Which diagnoses have both high average LOS and high average charges?
WITH DiagnosisStats AS
(
    SELECT
        CCS_Diagnosis_Description,
        COUNT(*) AS Total_Discharges,
        ROUND(AVG(TRY_CAST(Length_of_Stay AS FLOAT)), 2) AS Avg_LOS,
        ROUND(AVG(TRY_CAST(Total_Charges AS FLOAT)), 2) AS Avg_Charges
    FROM dbo.Discharges
    WHERE TRY_CAST(Length_of_Stay AS FLOAT) IS NOT NULL
      AND TRY_CAST(Total_Charges AS FLOAT) IS NOT NULL
    GROUP BY CCS_Diagnosis_Description
)
SELECT TOP 10
       CCS_Diagnosis_Description,
       Total_Discharges,
       Avg_LOS,
       Avg_Charges
FROM DiagnosisStats
WHERE Total_Discharges >= 100
ORDER BY Avg_LOS DESC, Avg_Charges DESC;

--19. Which counties have the highest discharge volume and total charges?
WITH CountyStats AS
(
    SELECT 
        Hospital_County,
        COUNT(*) AS Total_Discharges,
        ROUND(SUM(TRY_CAST(Total_Charges AS FLOAT)), 2) AS Total_Charges
    FROM dbo.Discharges
    WHERE TRY_CAST(Total_Charges AS FLOAT) IS NOT NULL
    GROUP BY Hospital_County
)
SELECT TOP 10
       Hospital_County,
       Total_Discharges,
       Total_Charges
FROM CountyStats
ORDER BY Total_Discharges DESC, Total_Charges DESC;