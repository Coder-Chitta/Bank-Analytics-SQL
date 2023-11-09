use bank_analytics;

-- Q1. Year wise loan amount Stats
ALTER TABLE finance_data
ADD new_issue_date DATE;

UPDATE finance_data
SET new_issue_date = CONVERT(DATE, issue_d, 105);

SELECT YEAR(new_issue_date) AS year, SUM(loan_amnt) AS total_loan_amount
FROM finance_data
GROUP BY YEAR(new_issue_date)
ORDER BY YEAR(new_issue_date);

-- Q2. Grade and sub grade wise revol_bal
SELECT grade, sub_grade, SUM(revol_bal) AS total_revol_bal
FROM finance_data
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;

-- Q3. Total Payment for Verified Status Vs Total Payment for Non Verified Status
SELECT verification_status, ROUND(SUM(total_pymnt), 2) AS total_payment
FROM finance_data
GROUP BY verification_status;

-- Q4. State wise and month wise loan status
SELECT addr_state AS state,
       FORMAT(new_issue_date, 'yyyy-MM') AS month,
       loan_status,
       COUNT(*) AS no_of_loans_taken
FROM finance_data
GROUP BY addr_state, FORMAT(new_issue_date, 'yyyy-MM'), loan_status
ORDER BY addr_state, FORMAT(new_issue_date, 'yyyy-MM');

-- Q5. Home ownership Vs last payment date stats
SELECT home_ownership, 
       YEAR(CONVERT(DATE, last_pymnt_d, 105)) AS year, 
       MONTH(CONVERT(DATE, last_pymnt_d, 105)) AS month, 
       ROUND(SUM(CAST(last_pymnt_amnt AS DECIMAL(18, 2))), 2) AS total_last_payment
FROM finance_data
WHERE last_pymnt_d IS NOT NULL AND last_pymnt_d <> '' 
      AND ISDATE(last_pymnt_d) = 1 AND ISNUMERIC(last_pymnt_amnt) = 1
GROUP BY home_ownership, YEAR(CONVERT(DATE, last_pymnt_d, 105)), MONTH(CONVERT(DATE, last_pymnt_d, 105))
ORDER BY home_ownership, YEAR(CONVERT(DATE, last_pymnt_d, 105)), MONTH(CONVERT(DATE, last_pymnt_d, 105));



-- Q6. Loan Payment Ratio Over Time
SELECT YEAR(new_issue_date) AS year,
       ROUND(SUM(total_pymnt) / SUM(loan_amnt), 2) AS payment_ratio
FROM finance_data
GROUP BY YEAR(new_issue_date);

-- Q7. Average Loan Amount by Purpose and Verification Status
SELECT purpose, verification_status,
       ROUND(AVG(loan_amnt), 2) AS avg_loan_amount
FROM finance_data
GROUP BY purpose, verification_status
ORDER BY verification_status;

-- Q8. Loan Approval Rate by Loan Purpose
SELECT purpose, ROUND(CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 END) AS FLOAT) / COUNT(*), 2) AS approval_rate
FROM finance_data
GROUP BY purpose
ORDER BY purpose;

-- Q9. Average Interest Rate by Grade
SELECT grade, ROUND(AVG(int_rate), 2) AS avg_interest_rate
FROM finance_data
GROUP BY grade
ORDER BY grade;

-- Q10. Loan Clear Rate by Term
SELECT term,
       ROUND(CAST(COUNT(CASE WHEN loan_status = 'Fully Paid' THEN 1 END) AS FLOAT) / COUNT(*), 2) AS clear_rate
FROM finance_data
GROUP BY term;
