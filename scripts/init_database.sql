--Create DataBase and Schema


-- switch to master before creating DB
use master

-- Create DataBase 
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