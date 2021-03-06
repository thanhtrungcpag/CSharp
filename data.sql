create database QuanLyQuanCafe
go

use QuanLyQuanCafe
go

-- Food 
-- table
-- FoodCategory
-- Account
-- Bill
-- BillInfo

CREATE table TableFood
(
	id int identity primary key,
	name nvarchar(100) not null default N'chưa đặt tên',
	status nvarchar(100)not null default N'Trống'--Trong 
)
go

CREATE table Account(
	--id int identity primary key
	Username nvarchar(100) primary key,
	DisplayName nvarchar(100) not null default N'user',
	PassWord nvarchar(1000) not null,
	Type int not null default 0
)go

CREATE table FoodCategory(
	id int identity primary key,
	Name nvarchar(100) not null default N'chưa đặt tên',
	
)go

CREATE table Food(
	id int identity primary key,
	Name nvarchar(100) not null default N'chưa đặt tên',
	idCategory int not null,
	price float not null,
	foreign key (idCategory) references FoodCategory(id)
)go

CREATE table bill(
	id int identity primary key
	DataCheckIn Date not null,
	DataCheckOut Date,
	idTable int not null,
	status int not null default 0
	foreign key (idTable) references TableFood(id)
)go

CREATE table billInfo(
	id int identity primary key,
	idBill int not null,
	idFood int not null,
	count int not null default 0
	foreign key (idBill) references bill(id),
	foreign key (idFood) references Food(id)
)go