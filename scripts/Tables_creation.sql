

/*
Script Purpose : creation of tables according to the source system objects 

Warning : By running this script all existing tables will get droped anlong with data
and new tables will be created

*/




use DataWarehouseProject

--1
if OBJECT_ID ('bronze.crm_cust_info','U') is not null
	drop table bronze.crm_cust_info
create table bronze.crm_cust_info(
	cust_id int,
	cust_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(10),
	cst_create_date datetime
);

--2
if OBJECT_ID ('bronze.crm_prd_info','U') is not null
	drop table bronze.crm_prd_info
create table bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);

--3
if OBJECT_ID ('bronze.crm_sales_details','U') is not null
	drop table bronze.crm_sales_details
create table bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);

--4
if OBJECT_ID ('bronze.erp_cust_az12','U') is not null
	drop table bronze.erp_cust_az12
create table bronze.erp_cust_az12(
	CID nvarchar(50),
	BDATE datetime,
	GEN nvarchar(30)
);

--5
if OBJECT_ID ('bronze.erp_loc_a101','U') is not null
	drop table bronze.erp_loc_a101
create table bronze.erp_loc_a101(
	CID nvarchar(50),
	CNTRY nvarchar(50)
);

--6
if OBJECT_ID ('bronze.erp_px_cat_g1v2','U') is not null
	drop table bronze.erp_px_cat_g1v2
create table bronze.erp_px_cat_g1v2(
	ID nvarchar(30),
	CAT nvarchar(30),
	SUBCAT nvarchar(30),
	MAINTENANCE nvarchar(10)
);


EXEC sp_help 'bronze.crm_prd_info'
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'crm_prd_info';



SELECT 
    prd_end_dt,
    LEN(prd_end_dt) AS len
FROM staging_prd
WHERE TRY_CONVERT(DATE, prd_end_dt, 105) IS NULL;