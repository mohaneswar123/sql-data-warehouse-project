--Create DataBase and Schema


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
