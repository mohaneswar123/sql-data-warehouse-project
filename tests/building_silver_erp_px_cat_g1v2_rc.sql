

-- check duplicated and nulls 
select 
id,
count(*)
from silver.erp_px_cat_g1v2
group by id
having count(*)>1;

select 
*
from bronze.erp_px_cat_g1v2
where id is null;

 -- check with prd details in crm 

select 
id
from silver.erp_px_cat_g1v2
where id not in (select cat_id from silver.crm_prd_info)

select 
* 
from bronze.erp_px_cat_g1v2
where id='CO_PD';


-- normalize the string fromat values

select 
* 
from bronze.erp_px_cat_g1v2
where trim(cat) != cat;

select 
* 
from bronze.erp_px_cat_g1v2
where trim(SUBCAT) != SUBCAT;

-- handle yes/no 
select 
distinct MAINTENANCE
from silver.erp_px_cat_g1v2;

select 
* 
from silver.erp_px_cat_g1v2;