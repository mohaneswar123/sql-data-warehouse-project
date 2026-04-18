

--use DataWarehouseProject


--handling null & duplicate values
--Excepted: No result
select
prd_key,
count(prd_key)
from silver.crm_prd_info
group by prd_key
having count(prd_key) >1 or prd_key is null;

select
prd_key
from silver.crm_prd_info
where prd_cost is null or prd_cost <0;

--handling unwanted spaces for string columns

select 
prd_nm
from silver.crm_prd_info
where trim(prd_nm)!= prd_nm;

select distinct 
prd_line
from silver.crm_prd_info;

select 
* 
from silver.crm_prd_info
where prd_start_dt>=prd_end_dt;

select * from silver.crm_prd_info;

-- formating dates 
select 
* ,
LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as prd_end_dt
from bronze.crm_prd_info
where prd_key= 'AC-HE-HL-U509'