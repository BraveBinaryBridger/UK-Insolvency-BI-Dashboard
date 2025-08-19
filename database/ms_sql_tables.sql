-- SQL Server (MS SQL) Table Creation for Insolvency Data Model


-- 1. DimDate Table
-- This table will store date-related information, useful for time-series analysis.
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,              -- YYYYMMDD format
    FullDate DATE NOT NULL,
    DayOfMonth INT NOT NULL,
    DayName NVARCHAR(10) NOT NULL,
    Month INT NOT NULL,
    MonthName NVARCHAR(10) NOT NULL,
    Quarter INT NOT NULL,
    Year INT NOT NULL,
    IsWeekday BIT NOT NULL,
    WeekOfYear INT NOT NULL
);

-- 2. DimClient Table
-- This table stores demographic and initial financial information about each client.
CREATE TABLE DimClient (
    ClientKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key for the client
    ClientID NVARCHAR(50) UNIQUE NOT NULL,   -- Original client ID from source system
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    DateOfBirth DATE,
    Gender NVARCHAR(10),
    Postcode NVARCHAR(10),                 -- For geographical analysis (e.g., Glasgow-specific trends)
    InitialIncome DECIMAL(18, 2),
    InitialExpenses DECIMAL(18, 2),
    MaritalStatus NVARCHAR(20)
);

-- 3. DimDebtType Table
-- This table categorizes different types of debt (e.g., credit card, personal loan, mortgage arrears).
CREATE TABLE DimDebtType (
    DebtTypeKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key for debt type
    DebtTypeName NVARCHAR(100) UNIQUE NOT NULL,
    DebtCategory NVARCHAR(50)                  -- e.g., 'Secured', 'Unsecured'
);

-- 4. DimSolution Table
-- This table lists the different insolvency solutions offered (e.g., IVA, DMP, Bankruptcy).
CREATE TABLE DimSolution (
    SolutionKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key for solution type
    SolutionName NVARCHAR(100) UNIQUE NOT NULL, -- e.g., 'IVA', 'DMP', 'Bankruptcy'
    SolutionDescription NVARCHAR(500)
);

-- 5. FactInsolvencyCase Table
-- This is the central fact table, storing metrics and linking to dimension tables.
CREATE TABLE FactInsolvencyCase (
    InsolvencyCaseKey INT IDENTITY(1,1) PRIMARY KEY,
    ClientKey INT NOT NULL,
    AdmissionDateKey INT NOT NULL,                 -- Foreign key to DimDate (date case was opened)
    SolutionKey INT NOT NULL,                      -- Foreign key to DimSolution
    InitialTotalDebt DECIMAL(18, 2) NOT NULL,
    NumberOfCreditors INT,
    ResolutionDateKey INT,                         -- Foreign key to DimDate (nullable if still open)
    AmountWrittenOff DECIMAL(18, 2),
    AmountPaidToCreditors DECIMAL(18, 2),

    -- Add foreign key constraints
    FOREIGN KEY (ClientKey) REFERENCES DimClient(ClientKey),
    FOREIGN KEY (AdmissionDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (SolutionKey) REFERENCES DimSolution(SolutionKey),
    FOREIGN KEY (ResolutionDateKey) REFERENCES DimDate(DateKey)
);

-- 6. FactCaseDebtDetails Table (Optional, for more granular debt breakdown per case)
-- This table could store the specific amounts for each debt type within a case.
CREATE TABLE FactCaseDebtDetails (
    CaseDebtDetailKey INT IDENTITY(1,1) PRIMARY KEY,
    InsolvencyCaseKey INT NOT NULL,                 -- Foreign key to FactInsolvencyCase
    DebtTypeKey INT NOT NULL,                       -- Foreign key to DimDebtType
    DebtAmount DECIMAL(18, 2) NOT NULL,
    -- Add foreign key constraints
    FOREIGN KEY (InsolvencyCaseKey) REFERENCES FactInsolvencyCase(InsolvencyCaseKey),
    FOREIGN KEY (DebtTypeKey) REFERENCES DimDebtType(DebtTypeKey)
);
