/*
Script Purpose : to insert the data from the bronze layer to silver layer tables by data cleaning and data transforming 

Warning : by executing the script the entire data in table will be truncated and the again starts data processing by taking 
data from bronze layer than insert into silver layer tables
*/


create or alter procedure silver.load_silver as  
begin 
	declare @start_time datetime, @end_time datetime,@batch_start_time datetime, @batch_end_time datetime;
	set @batch_start_time=GETDATE();
	begin try 

	print'========================================================================================';
	print'Loading data to Silver Layer....';
	print'========================================================================================';
	print'Loading CRM Tables.....'
	print'========================================================================================';



		set @start_time=getdate();
		print'========================================================================================';
		print 'truncating the table : silver.crm_prd_info';
		truncate table silver.crm_prd_info
		print 'inserting the data into table silver.crm_prd_info';
		--loading data from bronze to silver of crm_prt_info
		insert into silver.crm_prd_info(
			prd_id,
			ctg_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt 
		)

		select 
		prd_id,
		--prd_key,
		replace(substring(prd_key,1,5),'-','_') as ctg_id,  --exract category id from prd_jey
		substring(prd_key,7,LEN(prd_key)) as prd_key, -- extract prd_key 
		prd_nm,
		(
		case when prd_cost is null then 0
			 else prd_cost
		end
		) as prd_cost,-- handle null and -ve values of cost
		(
		case UPPER(trim(prd_line)) 
			when 'M' then 'Montain'
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'T' then 'Touring'
			else 'N/A'
		end
		) as prd_line, -- normalize the short name to complete data
		cast (prd_start_dt as date), -- handle dates start_dt < end_dt by creating end date from one day before next start date
		cast(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt 
		from bronze.crm_prd_info
		order by prd_id;
		set @end_time=GETDATE()

		print'Time consumed to load data from bronze is :'+cast(datediff(second ,@start_time,@end_time)as nvarchar)+'.';

		print'========================================================================================'


		set @start_time=getdate();
		print 'truncating the table : silver.crm_cust_info';
		truncate table silver.crm_cust_info
		print 'inserting the data into table silver.crm_cust_info';
		--loading data from bronze to silver of crm_cust_info
		insert into silver.crm_cust_info (
			cust_id,
			cust_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)

		select 
		cust_id,
		cust_key,
		trim(cst_firstname) as cst_firstname, -- handling the unwanted spaces in firstname
		trim(cst_lastname) as cst_lastname,-- handling the unwanted spaces in lastname

		(case
		when upper(trim(cst_marital_status))='M' then 'Married' 
		when lower(trim(cst_marital_status))='s' then 'Single'
		else 'N/A' -- normalize marital_status to readable format
		end )  as cst_marital_status,

		(case
		when upper(trim(cst_gndr))='M' then 'Male' 
		when lower(trim(cst_gndr))='f' then 'Female'
		else 'N/A' --normalize the gender into readable format
		end )  as cst_gndr,
		cst_create_date
		from (
			select 
			*,
			ROW_NUMBER() over(partition by cust_id order by cst_create_date desc) as dup_rep
			from bronze.crm_cust_info
			where cust_id is not null -- handling the duplicate and nulls in primarykey
		) t 
		where t.dup_rep=1;

		set @end_time=GETDATE()

		print'Time consumed to load data from bronze is :'+cast(datediff(second ,@start_time,@end_time)as nvarchar)+'.';

		print'========================================================================================'


		set @start_time=getdate();
		print 'truncating the table : silver.crm_sales_details';
		truncate table silver.crm_sales_details
		print 'inserting the data into table silver.crm_sales_details';
		--loading data from bronze to silver of crm_sales_details
		insert into silver.crm_sales_details (
			sls_ord_num ,
			sls_prd_key ,
			sls_cust_id ,
			sls_order_dt ,
			sls_ship_dt ,
			sls_due_dt ,
			sls_sales ,
			sls_quantity ,
			sls_price 
		) 

		select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		(
		case when sls_order_dt <=0 or len(sls_order_dt) !=8 then null
			 else cast(cast(sls_order_dt as nvarchar) as date) 
		end
		) as sls_order_dt, -- cast orderdate -> nvarchar -> date

		(
		case when sls_ship_dt <=0 or len(sls_ship_dt) !=8 then null
			 else cast(cast(sls_ship_dt as nvarchar) as date) 
		end
		) as sls_ship_dt, -- cast ship date -> nvarchar -> date

		(
		case when sls_due_dt <=0 or len(sls_due_dt) !=8 then null
			 else cast(cast(sls_due_dt as nvarchar) as date) 
		end
		) as sls_due_dt, --cast due date -> nvarchar -> date

		(
		case  
			when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity*abs(sls_price)
				then sls_quantity*abs(sls_price)
			else sls_sales
		end
		) as sls_sales, -- fixed -ve and null perfeclt with sales = abs(price)*quantity

		sls_quantity,

		(
		case
			when sls_price is null or sls_price <= 0 then cast(sls_sales/sls_quantity as int )
			else sls_price
		end
		) as sls_price -- fixed the -ve and nulls perfectly with price = sales/quantity
		from bronze.crm_sales_details;

		set @end_time=GETDATE()

		print'Time consumed to load data from bronze is :'+cast(datediff(second ,@start_time,@end_time)as nvarchar)+'.';

		print'========================================================================================'
		print'========================================================================================';
		print'Loading ERP Tables.....'
		print'========================================================================================';

		set @start_time=getdate();
		print 'truncating the table : silver.erp_loc_a101';
		truncate table silver.erp_loc_a101
		print 'inserting the data into table silver.erp_loc_a101';
		--loading data from bronze to silver of erp_loc_a101
		insert into silver.erp_loc_a101
		(
		cid,
		CNTRY
		)

		select 
		REPLACE(cid, '-','') as cid,
		(case 
			when trim(CNTRY) ='DE' then 'Germany'
			when trim(CNTRY) in ('US','USA') then 'United States'
			when trim(CNTRY) = '' or CNTRY is null then 'N/A'
			else trim(CNTRY)
		end 
		) as cntry
		from bronze.erp_loc_a101;
		set @end_time=GETDATE()

		print'Time consumed to load data from bronze is :'+cast(datediff(second ,@start_time,@end_time)as nvarchar)+'.';

		print'========================================================================================'

		set @start_time=getdate();
		print 'truncating the table : silver.erp_cust_az12';
		truncate table silver.erp_cust_az12
		print 'inserting the data into table silver.erp_cust_az12';
		--loading data from bronze to silver of erp_cust_az12
		insert into silver.erp_cust_az12
		(
			CID,
			BDATE,
			GEN
		)

		select
		(
		case
			when cid like'NAS%' then substring(cid,4,len(cid))
			else cid
		end
		) as CID,-- remover nad at start
		(
		case
			when BDATE > GETDATE() then null
			else BDATE
			end
		) as BDATE, -- null the future date
		(
		case 
			when UPPER(trim(gen)) in ('M','MALE') then 'Male'
			when UPPER(trim(gen)) in ('F','FEMALE')  then 'Female'
			else 'N/A'
		end
		) as GEN -- normalize gen values and unknown data
		from bronze.erp_cust_az12

		set @end_time=GETDATE()
		print'Time consumed to load data from bronze is :'+cast(datediff(second ,@start_time,@end_time)as nvarchar)+'.';

		print'========================================================================================';

		set @start_time=getdate();
		print 'truncating the table : silver.erp_px_cat_g1v2';
		truncate table silver.erp_px_cat_g1v2
		print 'inserting the data into table silver.erp_px_cat_g1v2';
		--loading data from bronze to silver of erp_px_cat_g1v2
		insert into silver.erp_px_cat_g1v2
		(
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
		)
		select 
		id,
		cat,
		SUBCAT,
		MAINTENANCE
		from bronze.erp_px_cat_g1v2;
		set @end_time=GETDATE()
		print'Time consumed to load data from bronze is :'+cast(datediff(second ,@start_time,@end_time)as nvarchar)+'.';

		print'========================================================================================';

		print'Totoal time consumed for data loading from bronze to silver is'+cast(datediff(second ,@batch_start_time,@batch_end_time)as nvarchar);

	end try
	begin catch 
	print'============================================================================================';
		print'Error occured during the inserting data';
		print'Error Message: '+ERROR_MESSAGE();
		print'Error Message: '+cast (ERROR_NUMBER() as nvarchar);
		print'Error Message: '+cast (ERROR_STATE() as nvarchar);
		print'========================================================================================';
	end catch
	set @batch_end_time=GETDATE();
	print'>>Entire Batch time duration: '+cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar);
end
