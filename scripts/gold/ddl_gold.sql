/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- ====================================================================
-- gold.dim_customers
-- ====================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
  
CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr !='n/a' THEN ci.cst_gndr -- CRM is the Master for gender info
         ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca ON ca.cid = ci.cst_key
LEFT JOIN silver.erp_loc_a101 AS la ON la.cid = ci.cst_key;
GO
  
-- ====================================================================
-- gold.dim_products
-- ====================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
  
CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key,
    pi.prd_id AS product_id,
    pi.prd_key AS product_number,
    pi.prd_nm AS product_name,
    pi.cat_id AS category_id,
    pcg.cat AS category,
    pcg.subcat AS subcategory,
    pcg.maintenance,
    pi.prd_cost AS cost,
    pi.prd_line AS product_line,
    pi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pi
LEFT JOIN silver.erp_px_cat_g1v2 AS pcg ON pcg.id = pi.cat_id
WHERE pi.prt_end_dt IS NULL
GO
  
-- ====================================================================
-- gold.fact_sales
-- ====================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
  
CREATE VIEW gold.fact_sales AS
SELECT
     sls_ord_num AS order_number,
     pr.product_key,
     cu.customer_key,
     sls_order_dt AS order_date,
     sls_ship_dt AS shipping_date,
     sls_due_dt AS due_date,
     sls_sales AS sales_amount,
     sls_quantity AS quantity,
     sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr ON pr.product_number = sd.sls_prd_key
LEFT JOIN gold.dim_customers cu ON cu.customer_id = sd.sls_cust_id
GO
