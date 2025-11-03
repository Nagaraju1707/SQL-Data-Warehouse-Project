/* 
===============================================================
Quality checks
===============================================================
script purpose: 
     This script performs various quality checks for data consistency, accuracy,and standardization across the 'silver' schemas.
    it includes checks for :
- null or duplicate primary keys.
- unwanted spaces in string fields
- Data standardization and consistency.
- invalid date ranges and orders
-Data consistency between related fields.

usage notes:
            - run these checks after data loading silver layer.
            - Investigate and resolve any discrepancies found during the checks.
==================================================================================
*/
-- =========================================================
-- checking 'silver.crm_cust_info'
-- =========================================================
-- check for NULLS or duplicates   in primary key 
-- Expectation: No results 


SELECT 
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 cst_id IS NULL;



---check for invalid dates -Bronze.crm_sales

SELECT 
     NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 OR LEN(sls_order_dt) !=8

SELECT 
NULLIF(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <=0 OR LEN(sls_ship_dt) !=8

SELECT 
NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <=0 OR LEN(sls_due_dt) !=8

-- check for invalid date orders 
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

SELECT *
FROM bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price or sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_Sales != sls_quantity * sls_price

-- identify out of range dates

SELECT
bdate
FROM silver.erp_cust_az12
WHERE  bdate > GETDATE() 

----Data standardization and consistency

SELECT distinct cntry as old_cntry,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN('US','USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
     ELSE TRIM(cntry)
END AS cntry
FROM silver.erp_loc_a1o1
order by cntry

OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
