create proc USP_GetAccountByUserName
@username nvarchar(100)
as 
begin
	select *from Account where Username = @username
end
go
select * from Account
exec dbo.USP_GetAccountByUserName @username = N'K9'
select * from Account where username = 'K9' and password = '1'

--create proc USP_GetAccountByUserName
--@username nvarchar(100)
--as 
--begin
--	select *from Account where Username = @username
--end
--go

declare @i int = 0
while @i < 10
begin
	insert dbo.TableFood (name)
		values (N'Ban ' + CAST(@i as Nvarchar(100)) )
		set @i = @i +1
end
go

select *from dbo.TableFood
go 
create proc USP_GetTableList
as select * from dbo.TableFood
go

exec dbo.USP_GetTableList



declare @i int = 0
while @i < 10
begin
	insert dbo.TableFood (name)
		values (N'Ban ' + CAST(@i as Nvarchar(100)) )
		set @i = @i +1
end
go
--category
		insert dbo.FoodCategory(name)
		values (N'Nông sản '  )
		insert dbo.FoodCategory(name)
		values (N'Hải sản '  )	
		insert dbo.FoodCategory(name)
		values (N'Nước '  )
		insert dbo.FoodCategory(name)
		values (N'Thịt '  )
		insert dbo.FoodCategory(name)
		values (N'Cá '  )
	-- thuc an
	insert dbo.Food(name, idCategory, price)
		values (N'Mực nướng', 2, 120000  )
	insert dbo.Food(name, idCategory, price)
		values (N'Nghêu nướng', 2, 50000  )
	insert dbo.Food(name, idCategory, price)
		values (N'Heo nướng', 1, 200000  )
	insert dbo.Food(name, idCategory, price)
		values (N'CAFE', 3, 20000  )
	insert dbo.Food(name, idCategory, price)
		values (N'7Up', 3, 25000  )
	-- bill
	insert dbo.bill(DataCheckIn, DataCheckOut, idTable, status)
		values (GETDATE(), NULL,1, 0 )
	insert dbo.bill(DataCheckIn, DataCheckOut, idTable, status)
		values (GETDATE(), NULL,2, 0 )
	insert dbo.bill(DataCheckIn, DataCheckOut, idTable, status)
		values (GETDATE(), NULL,3, 1 )
	-- them bill info
	insert dbo.billInfo(idBill, idFood, count)
		values (3,1,2 )
	insert dbo.billInfo(idBill, idFood, count)
		values (1,3,4 )
	insert dbo.billInfo(idBill, idFood, count)
		values (1,5,1 )
	insert dbo.billInfo(idBill, idFood, count)
		values (2,1,2 )
	insert dbo.billInfo(idBill, idFood, count)
		values (2,5,2 )
	insert dbo.billInfo(idBill, idFood, count)
		values (3,5,2 )
		
	select * from TableFood
	select * from dbo.bill where idTable = 1 and status = 1
	select * from dbo.billInfo where idBill = 1
	select * from dbo.billInfo where idBill = 2
	select * from dbo.bill where idTable = 1 and status = 0
	select * from dbo.billInfo where idBill = 1
	
	select f.name, bi.count, f.price, f.price*bi.count as totalPrice from billInfo as bi, bill as b, Food as f 
	where bi.idBill = b.id and bi.idFood = f.id and b.idTable = 1
	select * from FoodCategory
	select * from food
	go
	create proc USP_InsertBill
	@idTable int
	as
	begin
		insert dbo.bill(DataCheckIn, DataCheckOut, idTable, status)
		values (GETDATE(), NULL,@idTable, 0 )
	end
	go
	
	create proc USP_InsertBillInfo
	@idBill int,
	@idFood int,
	@count int
	as
	begin
	insert dbo.billInfo(idBill, idFood, count)
		values (@idBill, @idFood, @count)
	end
	go
	
	alter proc USP_InsertBillInfo
	@idBill int,
	@idFood int,
	@count int
	as
	begin
	declare @isExitsBillInfo int;
	declare @foodCount int =  1
	select @isExitsBillInfo = id, @foodCount = b.count from billInfo as b where idBill = @idBill and idFood = @idFood
	if(@isExitsBillInfo > 0)
	begin
		declare @newCount int =  @foodCount + @count
		if(@newCount >0)
			update billInfo	set count = @foodCount + @count where idFood = @idFood
		else
			delete billInfo where idBill = @idBill and idFood = @idFood
	end
	else
	begin
		insert dbo.billInfo(idBill, idFood, count)
			values (@idBill, @idFood, @count)
	end
	
	end
	go