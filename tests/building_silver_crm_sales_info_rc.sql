

--use DataWarehouseProject;

select 
sls_ord_num,
count(*)
from bronze.crm_sales_details
group by sls_ord_num;

select 
* 
from bronze.crm_sales_details
where sls_ord_num='SO55367';

-- handling white spaces
select 
*
from bronze.crm_sales_details
where trim(sls_ord_num) != sls_ord_num;

select 
*
from bronze.crm_sales_details
where trim(sls_prd_key) != sls_prd_key;

-- formating date 

select 
nullif(sls_order_dt,0)
from bronze.crm_sales_details
where sls_order_dt <= 0 
	or len(sls_order_dt) !=8
	or sls_order_dt > 20500101
	or sls_order_dt < 19970101;

--date checking

select 
*
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_ship_dt > sls_due_dt;

--checking sales = quan*price

--handling null and 0's 
-- excepted : no result

select
(
case  
	when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity*abs(sls_price)
		then sls_quantity*abs(sls_price)
	else sls_sales
end
) as sls_sales,
sls_quantity,
(
case
	when sls_price is null or sls_price <= 0 then cast(sls_sales/sls_quantity as int )
	else sls_price
end
) as sls_price
from silver.crm_sales_details
where sls_sales is null or sls_sales <=0 
	  or sls_price is null or sls_price <=0
	  or sls_quantity is null or sls_quantity <=0;


select 
*
from silver.crm_sales_details;
