-- Sample MS SQL INSERT Statements for Personal Insolvency Project

USE personal_insolvency; 

-- 1. Populate DimDate (Manually for a few key dates for demonstration)
-- In a real scenario, you'd have a date dimension table populated for many years using a script.
INSERT INTO DimDate (DateKey, FullDate, DayOfMonth, DayName, Month, MonthName, Quarter, Year, IsWeekday, WeekOfYear) VALUES
(20230115, '2023-01-15', 15, 'Sunday', 1, 'January', 1, 2023, 0, 3),
(20230220, '2023-02-20', 20, 'Monday', 2, 'February', 1, 2023, 1, 8),
(20230325, '2023-03-25', 25, 'Saturday', 3, 'March', 1, 2023, 0, 12),
(20230410, '2023-04-10', 10, 'Monday', 4, 'April', 2, 2023, 1, 15),
(20230501, '2023-05-01', 1, 'Monday', 5, 'May', 2, 2023, 1, 18),
(20230615, '2023-06-15', 15, 'Thursday', 6, 'June', 2, 2023, 1, 24),
(20230701, '2023-07-01', 1, 'Saturday', 7, 'July', 3, 2023, 0, 26),
(20230810, '2023-08-10', 10, 'Thursday', 8, 'August', 3, 2023, 1, 32),
(20230905, '2023-09-05', 5, 'Tuesday', 9, 'September', 3, 2023, 1, 36),
(20240120, '2024-01-20', 20, 'Saturday', 1, 'January', 1, 2024, 0, 3),
(20240210, '2024-02-10', 10, 'Saturday', 2, 'February', 1, 2024, 0, 6),
(20240301, '2024-03-01', 1, 'Friday', 3, 'March', 1, 2024, 1, 9),
(20240405, '2024-04-05', 5, 'Friday', 4, 'April', 2, 2024, 1, 14),
(20240520, '2024-05-20', 20, 'Monday', 5, 'May', 2, 2024, 1, 21),
(20240630, '2024-06-30', 30, 'Sunday', 6, 'June', 2, 2024, 0, 26),
(20240715, '2024-07-15', 15, 'Monday', 7, 'July', 3, 2024, 1, 29),
(20240801, '2024-08-01', 1, 'Thursday', 8, 'August', 3, 2024, 1, 31),
(20240901, '2024-09-01', 1, 'Sunday', 9, 'September', 3, 2024, 0, 35),
(20250105, '2025-01-05', 5, 'Sunday', 1, 'January', 1, 2025, 0, 1),
(20250218, '2025-02-18', 18, 'Tuesday', 2, 'February', 1, 2025, 1, 8),
(20250310, '2025-03-10', 10, 'Monday', 3, 'March', 1, 2025, 1, 11);


-- 2. Populate DimClient (Sample of diverse clients, including some from Glasgow)
INSERT INTO DimClient (ClientID, FirstName, LastName, DateOfBirth, Gender, Postcode, InitialIncome, InitialExpenses, MaritalStatus) VALUES
('CL001', 'John', 'Doe', '1985-04-12', 'Male', 'G1 1AA', 2500.00, 2600.00, 'Single'),
('CL002', 'Jane', 'Smith', '1990-08-20', 'Female', 'G3 7BB', 1800.00, 2000.00, 'Married'),
('CL003', 'Robert', 'Brown', '1972-11-03', 'Male', 'PA1 2CC', 3500.00, 3000.00, 'Married'),
('CL004', 'Alice', 'White', '1995-01-22', 'Female', 'G42 8DD', 1600.00, 1800.00, 'Single'),
('CL005', 'Michael', 'Green', '1980-06-01', 'Male', 'EH1 1EE', 2800.00, 2900.00, 'Divorced'),
('CL006', 'Sarah', 'Black', '1988-09-10', 'Female', 'G2 5FF', 2200.00, 2500.00, 'Married'),
('CL007', 'David', 'Taylor', '1975-03-18', 'Male', 'G5 0GG', 2000.00, 2200.00, 'Single'),
('CL008', 'Emily', 'Clark', '1992-07-05', 'Female', 'KY1 4HH', 2100.00, 2050.00, 'Married'),
('CL009', 'Chris', 'Wilson', '1968-02-28', 'Male', 'G33 3II', 1900.00, 2100.00, 'Divorced'),
('CL010', 'Olivia', 'Moore', '1983-12-11', 'Female', 'AB10 1JJ', 2700.00, 2800.00, 'Single');

-- 3. Populate DimDebtType
INSERT INTO DimDebtType (DebtTypeName, DebtCategory) VALUES
('Credit Card', 'Unsecured'),
('Personal Loan', 'Unsecured'),
('Mortgage Arrears', 'Secured'),
('Council Tax Arrears', 'Priority'),
('Utility Bill Arrears', 'Priority'),
('Store Card', 'Unsecured'),
('Payday Loan', 'Unsecured');

-- 4. Populate DimSolution
INSERT INTO DimSolution (SolutionName, SolutionDescription) VALUES
('IVA', 'Individual Voluntary Arrangement - Formal debt solution'),
('DMP', 'Debt Management Plan - Informal debt solution'),
('Bankruptcy', 'Formal insolvency process'),
('DAS', 'Debt Arrangement Scheme - Scottish formal debt solution'); -- Relevant for Glasgow

-- 5. Populate FactInsolvencyCase
-- This data reflects various scenarios, including some cases still open (ResolutionDateKey is NULL)
INSERT INTO FactInsolvencyCase (ClientKey, AdmissionDateKey, SolutionKey, InitialTotalDebt, NumberOfCreditors, ResolutionDateKey, AmountWrittenOff, AmountPaidToCreditors) VALUES
(1, 20230115, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'IVA'), 45000.00, 5, 20240715, 15000.00, 30000.00), -- John Doe, IVA, Resolved
(2, 20230220, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'DMP'), 22000.00, 3, NULL, NULL, NULL), -- Jane Smith, DMP, Ongoing
(3, 20230325, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'Bankruptcy'), 75000.00, 8, 20240301, 75000.00, 0.00), -- Robert Brown, Bankruptcy, Resolved
(4, 20230410, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'DMP'), 18000.00, 2, NULL, NULL, NULL), -- Alice White, DMP, Ongoing
(5, 20230501, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'IVA'), 60000.00, 7, 20250105, 20000.00, 40000.00), -- Michael Green, IVA, Resolved (recently)
(6, 20230615, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'DAS'), 30000.00, 4, NULL, NULL, NULL), -- Sarah Black, DAS (Glasgow), Ongoing
(7, 20230701, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'DMP'), 25000.00, 3, NULL, NULL, NULL), -- David Taylor, DMP, Ongoing
(8, 20240120, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'IVA'), 55000.00, 6, NULL, NULL, NULL), -- Emily Clark, IVA, Ongoing
(9, 20240210, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'DAS'), 40000.00, 5, NULL, NULL, NULL), -- Chris Wilson, DAS (Glasgow), Ongoing
(10, 20240301, (SELECT SolutionKey FROM DimSolution WHERE SolutionName = 'Bankruptcy'), 80000.00, 9, NULL, NULL, NULL); -- Olivia Moore, Bankruptcy, Ongoing

-- 6. Populate FactCaseDebtDetails (Granular breakdown of debt for selected cases)
INSERT INTO FactCaseDebtDetails (InsolvencyCaseKey, DebtTypeKey, DebtAmount) VALUES
((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 1), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Credit Card'), 20000.00),
((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 1), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Personal Loan'), 25000.00),

((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 2), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Credit Card'), 15000.00),
((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 2), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Utility Bill Arrears'), 7000.00),

((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 3), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Mortgage Arrears'), 50000.00),
((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 3), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Credit Card'), 25000.00),

((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 6), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Personal Loan'), 20000.00),
((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 6), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Council Tax Arrears'), 10000.00),

((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 9), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Credit Card'), 25000.00),
((SELECT InsolvencyCaseKey FROM FactInsolvencyCase WHERE ClientKey = 9), (SELECT DebtTypeKey FROM DimDebtType WHERE DebtTypeName = 'Payday Loan'), 15000.00);
