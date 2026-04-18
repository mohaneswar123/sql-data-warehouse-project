

--use DataWarehouseProject;

select 
* 
from silver.erp_cust_az12;

-- handle nulls or duplicates of CID

select 
CID,
count(*)
from silver.erp_cust_az12
group by CID
having count(*) > 1;

select
* 
from bronze.erp_cust_az12
where CID is null;

--handle date acc to range

select 
BDATE
from silver.erp_cust_az12
where BDATE > getdate()
order by BDATE desc


-- handling gender 

select 
distinct gen
from silver.erp_cust_az12;






