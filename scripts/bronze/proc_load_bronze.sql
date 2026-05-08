/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @count_total_rows INT, @start_time DATETIME, @end_time DATETIME, @start_batch_time DATETIME, @end_batch_time DATETIME
    BEGIN TRY
        SET @start_batch_time = GETDATE();
        PRINT '==================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '==================================================';

        PRINT '--------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '--------------------------------------------------';


    ----NEW TABLE
        SET @start_time = GETDATE()
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM '/home/stefan/Projects/Barra-SQL/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SELECT @count_total_rows = COUNT(*) FROM bronze.crm_cust_info;
        PRINT '>> Insering Data Into: bronze.crm_cust_info - ' + CAST(@count_total_rows AS VARCHAR) + ' Rows';
        SET @end_time = GETDATE()
        PRINT '>> Load Duration for bronze.crm_cust_info:: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '';


    ----NEW TABLE
        SET @start_time = GETDATE()
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM '/home/stefan/Projects/Barra-SQL/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SELECT @count_total_rows = COUNT(*) FROM bronze.crm_prd_info;
        PRINT '>> Insering Data Into: bronze.crm_prd_info - ' + CAST(@count_total_rows AS VARCHAR) + ' Rows';
        SET @end_time = GETDATE()
        PRINT '>> Load Duration for bronze.crm_prd_info:: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '';

    ----NEW TABLE
        SET @start_time = GETDATE()
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details

        FROM '/home/stefan/Projects/Barra-SQL/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SELECT @count_total_rows = COUNT(*) FROM bronze.crm_sales_details;
        PRINT '>> Insering Data Into: bronze.crm_sales_details - ' + CAST(@count_total_rows AS VARCHAR) + ' Rows';
        SET @end_time = GETDATE()
        PRINT '>> Load Duration for bronze.crm_sales_details:: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '';


    ----PRINT
        PRINT '--------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '--------------------------------------------------';


    ----NEW TABLE
        SET @start_time = GETDATE()
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2

        FROM '/home/stefan/Projects/Barra-SQL/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SELECT @count_total_rows = COUNT(*) FROM bronze.erp_px_cat_g1v2;
        PRINT '>> Insering Data Into: bronze.erp_px_cat_g1v2 - ' + CAST(@count_total_rows AS VARCHAR) + ' Rows';
        SET @end_time = GETDATE()
        PRINT '>> Load Duration for bronze.erp_px_cat_g1v2:: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '';


    ----NEW TABLE
        SET @start_time = GETDATE()
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101

        FROM '/home/stefan/Projects/Barra-SQL/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SELECT @count_total_rows = COUNT(*) FROM bronze.erp_loc_a101;
        PRINT '>> Insering Data Into: bronze.erp_loc_a101 - ' + CAST(@count_total_rows AS VARCHAR) + ' Rows';
        SET @end_time = GETDATE()
        PRINT '>> Load Duration for bronze.erp_loc_a101:: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '';


    ----NEW TABLE
        SET @start_time = GETDATE()
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12

        FROM '/home/stefan/Projects/Barra-SQL/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SELECT @count_total_rows = COUNT(*) FROM bronze.erp_cust_az12;
        PRINT '>> Insering Data Into: bronze.erp_cust_az12 - ' + CAST(@count_total_rows AS VARCHAR) + ' Rows';
        SET @end_time = GETDATE()
        PRINT '>> Load Duration for bronze.erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '';


    ----PRINT BATCH LOAD TIME
        SET @end_batch_time = GETDATE()
        PRINT '==================================================';
        PRINT 'Loading Bronze Later is Completed:';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @start_batch_time, @end_batch_time) AS NVARCHAR) + ' seconds';
        PRINT '==================================================';
    END TRY

    ----PRINT ERROR
    BEGIN CATCH
        PRINT '==================================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
        PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==================================================';
    END CATCH
END
GO
