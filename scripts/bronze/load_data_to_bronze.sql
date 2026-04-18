

/*
Script Purpose : to bulk insert the data from the source files to database table 

Warning : by executing the script the entire data in table will be deleted and again scouce
file data will be added to database table due truncate table before bulk insert
*/

--use DataWarehouseProject;

create or alter procedure bronze.load_bronze as 
begin
	declare @batch_st_time datetime, @batch_end_time datetime;
	declare @start_time datetime, @end_time datetime;
	set @batch_st_time=GETDATE();

	begin try
		print'==================================================================';
		print'Extracting of data started from the source system TYPE:Bulk Insert';
		print'==================================================================';

		print'------------------------------------------------------------------';
		print'Extracting of CRM data to tables';
		print'------------------------------------------------------------------';

		set @start_time=GETDATE();
		print'Truncating data in the table :bronze.crm_cust_info';
		truncate table bronze.crm_cust_info
		print'Inserting the data into : bronze.crm_cust_info'
		Bulk insert bronze.crm_cust_info
		from 'E:\Desktop\LearnDataStuff\Projects\First_DWH_Project\datasets\source_crm\cust_info.csv'
		with (
			FirstRow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time=GETDATE();
		print'Load duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
		print'------------------------';

		--select * from bronze.crm_cust_info
		--select count(*) from bronze.crm_cust_info


		set @start_time=GETDATE();
		print'Truncating data in the table :bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		print'Inserting the data into : bronze.crm_prd_info'
		Bulk insert bronze.crm_prd_info
		from 'E:\Desktop\LearnDataStuff\Projects\First_DWH_Project\datasets\source_crm\prd_info.csv'
		with (
			FirstRow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time=GETDATE();
		print'Load duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
		print'------------------------';

		--select * from bronze.crm_prd_info
		--select count(*) from bronze.crm_prd_info


		set @start_time=GETDATE();
		print'Truncating data in the table :bronze.crm_sales_details';
		truncate table bronze.crm_sales_details
		print'Inserting the data into : bronze.crm_sales_details'
		Bulk insert bronze.crm_sales_details
		from 'E:\Desktop\LearnDataStuff\Projects\First_DWH_Project\datasets\source_crm\sales_details.csv'
		with (
			FirstRow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time=GETDATE();
		print'Load duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
		print'------------------------';

		--select * from bronze.crm_sales_details
		--select count(*) from bronze.crm_sales_details


		print'------------------------------------------------------------------';
		print'Extracting of ERP data to tables';
		print'------------------------------------------------------------------';

		set @start_time=GETDATE();
		print'Truncating data in the table :bronze.erp_CUST_AZ12';
		truncate table bronze.erp_CUST_AZ12
		print'Inserting the data into : bronze.erp_CUST_AZ12'
		Bulk insert bronze.erp_CUST_AZ12
		from 'E:\Desktop\LearnDataStuff\Projects\First_DWH_Project\datasets\source_erp\CUST_AZ12.csv'
		with (
			FirstRow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time=GETDATE();
		print'Load duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
		print'------------------------';

		--select * from bronze.erp_CUST_AZ12
		--select count(*) from bronze.erp_CUST_AZ12

		set @start_time=GETDATE();
		print'Truncating data in the table :bronze.erp_LOC_A101';
		truncate table bronze.erp_LOC_A101
		print'Inserting the data into : bronze.erp_LOC_A101'
		Bulk insert bronze.erp_LOC_A101
		from 'E:\Desktop\LearnDataStuff\Projects\First_DWH_Project\datasets\source_erp\LOC_A101.csv'
		with (
			FirstRow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time=GETDATE();
		print'Load duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
		print'------------------------';

		--select * from bronze.erp_LOC_A101
		--select count(*) from bronze.erp_LOC_A101

		set @start_time=GETDATE();
		print'Truncating data in the table :bronze.erp_PX_CAT_G1V2';
		truncate table bronze.erp_PX_CAT_G1V2
		print'Inserting the data into : bronze.erp_PX_CAT_G1V2'
		Bulk insert bronze.erp_PX_CAT_G1V2
		from 'E:\Desktop\LearnDataStuff\Projects\First_DWH_Project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			FirstRow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time=GETDATE();
		print'Load duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
		print'------------------------';

		--select * from bronze.erp_PX_CAT_G1V2
		--select count(*) from bronze.erp_PX_CAT_G1V2


		print'Completed exracting of data from source to database tables'
	end try
	begin catch
		print'==================================================================';
		print'Error occured during the inserting data';
		print'Error Message: '+ERROR_MESSAGE();
		print'Error Message: '+cast (ERROR_NUMBER() as nvarchar);
		print'Error Message: '+cast (ERROR_STATE() as nvarchar);
		print'==================================================================';
	end catch
	
	set @batch_end_time=GETDATE();
	print'>>Entire Batch time duration: '+cast(datediff(second,@batch_st_time,@batch_end_time) as nvarchar);
end
