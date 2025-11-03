/* 
==========================================================================
Quality checks
==========================================================================
Script Purpose : 
         This script performs quality checks to validate the integrity,consistency,
and accuracy of the Gold Layer, These checks ensure:
- uniqueness of surrogate keys in dimension tables.
- Referential integrity between fact and dimension table.
- validation of relationships in the data model for analytical purposes.

usage notes: 
- run these checks after data loading   silver layer.
- investigate and resolve any discrepancies found during the checks.
================================================================================
*/
-- ============================================================
-- checking 'gold.dim_customers'
-- ============================================================
-- check for uniqueness of customer key in gold.dim_customers
-- Expectation : No results
SELECT 
   Customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) >1;

-- =================================================================
-- Checking 'gold.product_key'
-- =================================================================
-- check for uniqueness of product key in gold.dim_products
-- Expectation: NO RESULTS
SELECT 
   product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) >1;

-- ===========================================================================
-- Checking 'gold.fact_sales'
-- ============================================================================
-- check the data model connectivity between fact and dimension
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON C.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.proudct_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
