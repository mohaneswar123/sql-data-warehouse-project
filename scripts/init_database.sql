--Create DataBase and Schema

/*
Script Purpose : 
	1. Create DataBase "DataWarehouseProject" for the project if already exists it will be droped will be
	created as new one .
	2. Create Schema for every layer for "Bronze", "Silver" and "Gold" in the DataBase


WARNING :	 
	1. By Running this script "DataWarehouseProject" database will be permanently deleted and exising data and schemas
	aslo droped so make sure before running this script having backup of database
*/

-- switch to master before creating DB
use master

-- Create DataBase 
if exists (select 1 from sys.databases where name ='DataWarehouseProject')
Begin
	Alter database DataWarehouseProject set single_user with rollback immediate;
	Drop database DataWarehouseProject;
End;
go
  
create database DataWarehouseProject;

--Switch to Created DataBase
use DataWarehouseProject;
go

--Create Schema for every layer
create schema bronze;
go
create schema silver;
go 
create schema gold;
