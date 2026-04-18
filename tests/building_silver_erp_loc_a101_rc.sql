



--handle the null and duplicate
select 
cid,
count(cid)
from bronze.erp_loc_a101
group by cid
having count(*) >1;

select 
cid 
from bronze.erp_loc_a101
where cid is null;

-- check with cust data from crm
--Excepted no result

select 
cid
from silver.erp_loc_a101
where cid not in (select distinct cid from silver.crm_cust_info)

--handle country

select distinct CNTRY
from silver.erp_loc_a101;


