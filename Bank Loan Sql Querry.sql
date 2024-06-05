use [Bank Loan DB];

select * from dbo.financial_loan;

SELECT COUNT(id) AS Total_Applications FROM dbo.financial_loan;

SELECT COUNT(*) AS MTD_Total_Applications
FROM dbo.financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT COUNT(*) AS PMTD_Total_Applications
FROM dbo.financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

WITH CurrentMonth AS (
    SELECT COUNT(*) AS MTD_Total_Applications
    FROM dbo.financial_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PreviousMonth AS (
    SELECT COUNT(*) AS PMTD_Total_Applications
    FROM dbo.financial_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT
    CASE
        WHEN PreviousMonth.PMTD_Total_Applications = 0 THEN NULL
        ELSE ((CurrentMonth.MTD_Total_Applications - PreviousMonth.PMTD_Total_Applications) / CAST(PreviousMonth.PMTD_Total_Applications AS FLOAT)) * 100
    END AS Month_Over_Month_Percentage
FROM
    CurrentMonth,
    PreviousMonth;

SELECT SUM(loan_amount) AS Total_Funded_Amount FROM dbo.financial_loan;

SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM dbo.financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT SUM(loan_amount) AS PMTD_Total_Loan_Amount FROM dbo.financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

WITH CurrentMonth AS (
    SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
    FROM dbo.financial_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PreviousMonth AS (
    SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
    FROM dbo.financial_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT
    CASE
        WHEN PreviousMonth.PMTD_Total_Funded_Amount = 0 THEN NULL
        ELSE ((CurrentMonth.MTD_Total_Funded_Amount - PreviousMonth.PMTD_Total_Funded_Amount) / CAST(PreviousMonth.PMTD_Total_Funded_Amount AS FLOAT)) * 100
    END AS Month_Over_Month_Percentage
FROM
    CurrentMonth,
    PreviousMonth;

SELECT SUM(total_payment) AS Total_Amout_Recived FROM dbo.financial_loan;

SELECT SUM(total_payment) AS MTD_Total_Amout_Recived FROM dbo.financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT SUM(total_payment) AS MTD_Total_Amout_Recived FROM dbo.financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(int_rate),4) * 100 AS Avg_Interest_Rate FROM dbo.financial_loan;

SELECT ROUND(AVG(int_rate),4) * 100 AS MTD_Avg_Interest_Rate FROM dbo.financial_loan 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(int_rate),4) * 100 AS PMTD_Avg_Interest_Rate FROM dbo.financial_loan 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Subquery to calculate the average interest rate for December 2021
WITH December2021 AS (
    SELECT ROUND(AVG(int_rate), 4) * 100 AS Avg_Interest_Rate
    FROM dbo.financial_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
-- Subquery to calculate the average interest rate for November 2021
November2021 AS (
    SELECT ROUND(AVG(int_rate), 4) * 100 AS Avg_Interest_Rate
    FROM dbo.financial_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
-- Main query to calculate the MoM percentage change
SELECT 
    December2021.Avg_Interest_Rate AS MTD_Avg_Interest_Rate,
    November2021.Avg_Interest_Rate AS PMTD_Avg_Interest_Rate,
    ((December2021.Avg_Interest_Rate - November2021.Avg_Interest_Rate) / November2021.Avg_Interest_Rate) * 100 AS MoM_Percent_Change
FROM 
    December2021, November2021;

SELECT ROUND(AVG(dti),4) * 100 AS Avg_DTI FROM dbo.financial_loan;


SELECT ROUND(AVG(dti),4) * 100 AS MTD_Avg_DTI FROM dbo.financial_loan 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(dti),4) * 100 AS PMTD_Avg_DTI FROM dbo.financial_loan 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

SELECT (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)* 100)
/ COUNT(id) AS Good_loan_percentage
	FROM dbo.financial_loan;

SELECT COUNT(id) As Good_Loan_Applications FROM dbo.financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; 

SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount FROM dbo.financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

SELECT SUM(total_payment) AS Good_Loan_Recived_Amount FROM dbo.financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';



SELECT (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)* 100)
/ COUNT(id) AS Bad_loan_percentage
	FROM dbo.financial_loan;

SELECT COUNT(id) As Bad_Loan_Applications FROM dbo.financial_loan
WHERE loan_status = 'Charged Off' ; 

SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount FROM dbo.financial_loan
WHERE loan_status = 'Charged Off';

SELECT SUM(total_payment) AS Bad_Loan_Recived_Amount FROM dbo.financial_loan
WHERE loan_status = 'Charged Off';

SELECT 
	loan_status,
	COUNT(id) AS Total_Loan_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Recived,
	ROUND(AVG(int_rate * 100),2) AS Interest_Rate,
	AVG(dti* 100) AS DTI
	FROM dbo.financial_loan
	GROUP BY loan_status;

SElECT 
	loan_status,
	SUM(loan_amount) as MTD_Total_Funded_Amount,
	SUM(total_payment) as MTD_Total_Amount_Recived
from dbo.financial_loan
where month(issue_date) = 12
group by loan_status;

select 
	month(issue_date) as Month_Number,
	datename(month, issue_date) as Month_Nmae,
	count(id) as Total_Loan_Application,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Recived_Amount
from dbo.financial_loan 
group by month(issue_date), datename(month, issue_date)
order by month(issue_date)

select
	address_state,
	count(id) as Total_Loan_Application,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Recived_Amount
from dbo.financial_loan 
group by address_state
order by sum(loan_amount) desc;

select 
	term,
	count(id) as Total_Loan_Application,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Recived_Amount
from dbo.financial_loan 
group by term
order by term;

select 
	emp_length,
	count(id) as Total_Loan_Application,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Recived_Amount
from dbo.financial_loan 
group by emp_length
order by count(id) desc;

select 
	purpose,
	count(id) as Total_Loan_Application,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Recived_Amount
from dbo.financial_loan 
group by purpose
order by count(id) desc;

select 
	home_ownership,
	count(id) as Total_Loan_Application,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Recived_Amount
from dbo.financial_loan 
group by home_ownership
order by count(id) desc;

select * from dbo.financial_loan;































