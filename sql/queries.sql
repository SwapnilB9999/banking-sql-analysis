-- ============================================
-- Banking Transactions Analysis - SQL Queries
-- ============================================

-- 1. Create the database
CREATE DATABASE banking_analysis;

USE banking_analysis;

-- 2. Create the table structure
CREATE TABLE transactions (
    account_id VARCHAR(20),
    customer_name VARCHAR(100),
    account_type VARCHAR(50),
    branch VARCHAR(50),
    transaction_type VARCHAR(20),
    transaction_amount DECIMAL(10,2),
    account_balance DECIMAL(10,2),
    currency VARCHAR(10)
);

-- Data was loaded into this table using the
-- MySQL Workbench Table Data Import Wizard (banking_dataset.csv, 10,000 rows)


-- 3. Sanity check: confirm row count after import
SELECT COUNT(*) FROM transactions;
-- Result: 10,000 rows


-- 4. Preview the data
SELECT * FROM transactions LIMIT 10;


-- 5. Total sales & transaction count by branch
SELECT 
    branch,
    SUM(transaction_amount) AS total_amount,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY branch
ORDER BY total_amount DESC;

-- Findings:
-- Phoenix leads (3,297,338.41 across 1,274 transactions)
-- San Diego lowest (2,958,886.25 across 1,183 transactions)
-- All 8 branches within ~11% of each other - balanced performance


-- 6. Credit vs Debit breakdown
SELECT 
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_amount,
    AVG(transaction_amount) AS avg_amount
FROM transactions
GROUP BY transaction_type;

-- Findings:
-- Credit: 5,114 transactions, total 12,895,418.33, avg 2,521.59
-- Debit:  4,886 transactions, total 12,350,224.65, avg 2,527.68
-- Nearly identical average transaction size between Credit and Debit


-- 7. Average account balance by account type
SELECT 
    account_type,
    AVG(account_balance) AS avg_balance,
    COUNT(*) AS num_accounts
FROM transactions
GROUP BY account_type
ORDER BY avg_balance DESC;

-- Findings:
-- Fixed Deposit:     avg 50,646.45 (2,489 accounts)
-- Savings:           avg 50,382.53 (2,580 accounts)
-- Recurring Deposit: avg 50,239.43 (2,402 accounts)
-- Current:           avg 49,812.92 (2,529 accounts)
-- Balances are close across all account types


-- 8. Filter example: high-value transactions (WHERE clause)
SELECT 
    account_id,
    customer_name,
    branch,
    transaction_amount
FROM transactions
WHERE transaction_amount > 4000
ORDER BY transaction_amount DESC;


-- 9. Count of high-value transactions
SELECT COUNT(*) AS high_value_count
FROM transactions
WHERE transaction_amount > 4000;

-- Result: 2,048 transactions (~20% of all transactions) are above 4000


-- 10. Filter after grouping (HAVING clause)
-- Find branches with more than 1,250 transactions
SELECT 
    branch, 
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY branch
HAVING total_transactions > 1250
ORDER BY total_transactions DESC;

-- Result: Philadelphia, Phoenix, Los Angeles, Houston, New York
-- qualify (out of 8 total branches)


-- ============================================
-- Utility query used during troubleshooting
-- ============================================
-- Used to clear a partial/failed import before retrying:
-- TRUNCATE TABLE transactions;
