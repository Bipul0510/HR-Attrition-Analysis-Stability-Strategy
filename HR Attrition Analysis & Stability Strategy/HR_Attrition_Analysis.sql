-----PROJECT Title: HR Attrition Analysis & Stability Strategy
--
--Step-1: Create a database
CREATE DATABASE HRDATA 
--

--Step-2: Load Database
USE HRDATA

--Step-3: Retrive the required dataset
SELECT * FROM HR_Data



-- 1. OVERALL ATTRITION RATE: Provides the organization's single, most critical turnover metric.

SELECT CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS Overall_Attrition_Rate_Percent
FROM HR_Data


-- 2. ATTRITION RATE BY DEPARTMENT: Identifies which department has a disproportionately high turnover rate.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS Attrition_Rate_Percent
FROM HR_Data
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC


-- 3. IMPACT OF OVERTIME ON ATTRITION: Crucial finding: Compares attrition for employees who work overtime vs. those who do not.

SELECT
    CASE WHEN Over_Time = 1 THEN 'Yes' ELSE 'No' END AS Over_Time,
    COUNT(*) AS Total,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS Attrition_Rate_Percent
FROM HR_Data
GROUP BY Over_Time


-- 4. AVERAGE MONTHLY INCOME OF LEAVERS VS. STAYERS: Helps determine if compensation is a major factor in the decision to leave.

SELECT
    CASE WHEN Attrition = 'Yes' THEN 'Leavers' ELSE 'Stayers' END AS Attrition,
    AVG(Monthly_Income) AS Avg_Monthly_Income

FROM HR_Data
GROUP BY Attrition


-- 5. ATTRITION RATE BY JOB ROLE & JOB LEVEL: Pinpoints specific high-risk job roles/levels that need targeted attention.

SELECT
    Job_Role,
    Job_Level,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS Attrition_Rate_Percent

FROM HR_Data
GROUP BY Job_Role, Job_Level
HAVING COUNT(*) > 20 -- Filter out small groups for statistical significance
ORDER BY Attrition_Rate_Percent DESC


-- 6. "FIRST YEAR" ATTRITION (EARLY TURNOVER): Measures the failure of recruitment or the initial onboarding process (Years_At_Company <= 1).

SELECT
    COUNT(*) AS Early_Leavers_Count
FROM HR_Data
WHERE Attrition = 'Yes'AND Years_At_Company <= 1


-- 7. ATTRITION RATE BY JOB SATISFACTION LEVEL: Correlates internal sentiment scores with turnover likelihood.

SELECT
    Job_Satisfaction,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS Attrition_Rate_Percent
FROM HR_Data
GROUP BY Job_Satisfaction
ORDER BY Job_Satisfaction ASC


-- 8. ATTRITION RATE BY MARITAL STATUS: Often reveals higher risk among specific groups (e.g., Single employees).

SELECT
    Marital_Status,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS Attrition_Rate_Percent
FROM HR_Data
GROUP BY Marital_Status
ORDER BY Attrition_Rate_Percent DESC


-- 9. ATTRITION RATE BY AGE GROUP: Highlights which generation or age bracket is most prone to leaving.

SELECT
    CF_age_band,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS Attrition_Rate_Percent
FROM HR_Data
GROUP BY CF_age_band
ORDER BY MIN(Age) ASC


-- 10. HIGH-VALUE EMPLOYEES DUE FOR RECOGNITION/PROMOTION: Identifies valuable current employees who are performing well but may be feeling stagnant, making them a high retention priority.

SELECT
    Employee_Number,
    Job_Role,
    Monthly_Income,
    Years_Since_Last_Promotion,
    Years_In_Current_Role

FROM HR_Data
WHERE Attrition = 'No' -- Current Employees
    AND Years_Since_Last_Promotion >= 3 -- Stagnation risk (customize as needed)
    AND Performance_Rating IN (3, 4) -- High performers (assuming 3/4 are high ratings)
ORDER BY Years_Since_Last_Promotion DESC, Monthly_Income ASC


--------------------------------------------------END OF QUARY--------------------------------------------------------------------------------------