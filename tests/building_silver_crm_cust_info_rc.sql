

--use DataWarehouseProject
--handling null and duplicates in primarykeys
-- Exception : No result

select 
cust_id,
count(*)
from silver.crm_cust_info
group by cust_id
having count(*) >1 or cust_id is null;

--handling unwanted spaces in string type columns
--Excepted : No Result
select 
cst_firstname
from silver.crm_cust_info
where cst_firstname!=trim(cst_firstname);

select 
cst_lastname
from silver.crm_cust_info
where cst_lastname!=trim(cst_lastname);


--Data Standardization and consistency 
select 
distinct cst_gndr
from silver.crm_cust_info;

select 
distinct cst_marital_status
from silver.crm_cust_info;


select * from silver.crm_cust_info
where cst_marital_status is null;

