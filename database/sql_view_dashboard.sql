-- SQL Server View Schema for Insolvency Dashboard

USE [personal_insolvency]; 

GO -- Separates batches in SQL Server

-- Drop the view if it already exists (useful for re-running the script during development)
IF OBJECT_ID('dbo.vw_InsolvencyDashboardData', 'V') IS NOT NULL
    DROP VIEW dbo.vw_InsolvencyDashboardData;
GO

-- Create the view
CREATE VIEW dbo.vw_InsolvencyDashboardData AS
SELECT
    -- FactInsolvencyCase fields
    FIC.InsolvencyCaseKey,
    FIC.InitialTotalDebt,
    FIC.NumberOfCreditors,
    FIC.AmountWrittenOff,
    FIC.AmountPaidToCreditors,

    -- Client Dimensions (from DimClient)
    DC.ClientID,
    DC.FirstName,
    DC.LastName,
    DC.DateOfBirth,
    DC.Gender,
    DC.Postcode,
    DC.InitialIncome AS ClientInitialIncome, -- Renamed to avoid confusion with case income
    DC.InitialExpenses AS ClientInitialExpenses, -- Renamed to avoid confusion with case expenses
    DC.MaritalStatus,

    -- Admission Date Dimensions (from DimDate)
    DA.FullDate AS AdmissionDate,
    DA.DayOfMonth AS AdmissionDayOfMonth,
    DA.DayName AS AdmissionDayName,
    DA.Month AS AdmissionMonth,
    DA.MonthName AS AdmissionMonthName,
    DA.Quarter AS AdmissionQuarter,
    DA.Year AS AdmissionYear,
    DA.IsWeekday AS AdmissionIsWeekday,
    DA.WeekOfYear AS AdmissionWeekOfYear,

    -- Solution Dimensions (from DimSolution)
    DS.SolutionName,
    DS.SolutionDescription,

    -- Resolution Date Dimensions (from DimDate - aliased differently)
    DR.FullDate AS ResolutionDate,
    DR.DayOfMonth AS ResolutionDayOfMonth,
    DR.DayName AS ResolutionDayName,
    DR.Month AS ResolutionMonth,
    DR.MonthName AS ResolutionMonthName,
    DR.Quarter AS ResolutionQuarter,
    DR.Year AS ResolutionYear,
    DR.IsWeekday AS ResolutionIsWeekday,
    DR.WeekOfYear AS ResolutionWeekOfYear,

    -- Debt Details (aggregated or joined, depending on granularity)
    -- For this view, we'll sum up the debt details for each case.
    -- If you want granular debt per type per case, you'd make a separate view or handle in Power BI.
    ISNULL(SUM(FCD.DebtAmount), 0) AS TotalDebtBreakdownAmount -- Total from FactCaseDebtDetails
    -- If you need individual DebtTypeNames, you might need to use STRING_AGG or a subquery
    -- e.g., STRING_AGG(DDT.DebtTypeName, ', ') WITHIN GROUP (ORDER BY DDT.DebtTypeName) AS DebtTypesInCase

FROM
    FactInsolvencyCase AS FIC
INNER JOIN
    DimClient AS DC ON FIC.ClientKey = DC.ClientKey
INNER JOIN
    DimDate AS DA ON FIC.AdmissionDateKey = DA.DateKey
INNER JOIN
    DimSolution AS DS ON FIC.SolutionKey = DS.SolutionKey
LEFT JOIN -- Use LEFT JOIN for ResolutionDate as it can be NULL (case not resolved yet)
    DimDate AS DR ON FIC.ResolutionDateKey = DR.DateKey
LEFT JOIN -- Use LEFT JOIN for FactCaseDebtDetails as not all cases might have granular debt breakdown
    FactCaseDebtDetails AS FCD ON FIC.InsolvencyCaseKey = FCD.InsolvencyCaseKey
-- This join is for the DebtType Name itself if needed in the main view
LEFT JOIN
    DimDebtType AS DDT ON FCD.DebtTypeKey = DDT.DebtTypeKey
GROUP BY -- Group by all non-aggregated columns from the fact and dimension tables
    FIC.InsolvencyCaseKey,
    FIC.InitialTotalDebt,
    FIC.NumberOfCreditors,
    FIC.AmountWrittenOff,
    FIC.AmountPaidToCreditors,
    DC.ClientID,
    DC.FirstName,
    DC.LastName,
    DC.DateOfBirth,
    DC.Gender,
    DC.Postcode,
    DC.InitialIncome,
    DC.InitialExpenses,
    DC.MaritalStatus,
    DA.FullDate, DA.DayOfMonth, DA.DayName, DA.Month, DA.MonthName, DA.Quarter, DA.Year, DA.IsWeekday, DA.WeekOfYear,
    DS.SolutionName,
    DS.SolutionDescription,
    DR.FullDate, DR.DayOfMonth, DR.DayName, DR.Month, DR.MonthName, DR.Quarter, DR.Year, DR.IsWeekday, DR.WeekOfYear;

GO
