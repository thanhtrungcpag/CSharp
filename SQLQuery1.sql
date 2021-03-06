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
while @i < 20
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
	insert dbo.Food(name, idCategory, price) values (N'Mực nướng', 2, 120000  )
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
	alter proc USP_InsertBill
	@idTable int
	as
	begin
		insert dbo.bill(DataCheckIn, DataCheckOut, idTable, status, discount)
		values (GETDATE(), NULL,@idTable, 0, 0 )
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
	
	alter trigger UTG_UpdateBillInfo
	ON BillInfo for	insert, update
	as 
	begin
		declare @idBill int
		select @idBill = idbill from inserted
		
		declare @idTable int
		select @idTable = idTable from bill where id = @idBill and status = 0
		declare @count int
		select @count = COUNT(*) from billInfo where idBill = @idBill
		if(@count > 0) 
			update TableFood set status = N'Có người' where id = @idTable
		else
			update TableFood set status = N'Trống' where id = @idTable
	end
	go
	
	delete billInfo
	delete bill
	go
	create trigger UTG_UpdateBill
	ON Bill for update
	as
	begin
		declare @idBill int
		select @idBill = id from inserted
		
		declare @idTable int
		select @idTable = idTable from bill where id = @idBill
		
		declare @count int = 0
		select @count = COUNT(*) from bill where idTable = @idTable and status = 0
		if(@count = 0)
			update TableFood set status = N'Trống' where id = @idTable
	end
	go
	alter trigger UTG_UpdateBill
	ON Bill for update
	as
	begin
		declare @idBill int
		select @idBill = id from inserted
		
		declare @idTable int
		select @idTable = idTable from bill where id = @idBill
		
		declare @count int = 0
		select @count = COUNT(*) from bill where idTable = @idTable and status = 0
		if(@count = 0)
			update TableFood set status = N'Trống' where id = @idTable
	end
	go
	
	alter table bill
	add discount int
	
	update bill set discount = 0
	
	select * from bill
	go
	alter proc USP_SwitchTable
	@idTable1 int, @idTable2 int
	as
	begin
		declare @idFirstBill int
		declare @idSecondBill int
		declare @isFirstTableEmpty int = 1
		declare @isSecondTableEmpty int = 1
		select @idFirstBill = id from bill where idTable = @idTable1 and status = 0
		select @idSecondBill = id from bill where idTable = @idTable2 and status = 0
		if(@idFirstBill is NULL)
		begin
			insert dbo.bill(DataCheckIn, DataCheckOut, idTable, status, discount)
			values (GETDATE(), NULL, @idTable1, 0,0 )
			select @idFirstBill = MAX(id) from bill where idTable = @idTable1 and status = 0
		end
		select @isFirstTableEmpty = COUNT(*) from billInfo where idBill = @idFirstBill
		if(@idSecondBill is NULL)
		begin
			insert dbo.bill(DataCheckIn, DataCheckOut, idTable, status, discount)
			values (GETDATE(), NULL, @idTable2, 0,0 )
			select @idSecondBill = MAX(id) from bill where idTable = @idTable2 and status = 0
		end
		select @isSecondTableEmpty = COUNT(*) from billInfo where idBill = @idSecondBill
		select id into IDBillInfoTable from billInfo where idBill = @idSecondBill
		update billInfo set idBill = @idSecondBill where idBill = @idFirstBill
		update billInfo set idBill =@idFirstBill where id IN (select * from IDBillInfoTable)
		drop table IDBillInfoTable
		if(@isFirstTableEmpty = 0)
			update TableFood set status = N'Trống' where id = @idTable2
		if(@isSecondTableEmpty = 0)
			update TableFood set status = N'Trống' where id = @idTable1
	end
	go
	
		
	
	select * from bill
	
	select t.name, DataCheckIn, DataCheckOut, discount, b.totalPrice 
	from bill as b, TableFood as t
	where DataCheckIn >= '20191123' and DataCheckOut <= '20191123' 
	and b.status = 1 and t.id = b.idTable
	go
	alter proc USP_GetListBillByDate
	@checkIn date, @checkOut date
	as
	begin
		select t.name as [Tên bàn], DataCheckIn as [Ngày vào], DataCheckOut as [Ngày ra], discount as [Giảm giá %], b.totalPrice as [Tổng tiền] 
		from bill as b, TableFood as t
		where DataCheckIn >= @checkIn and DataCheckOut <= @checkOut 
		and b.status = 1 and t.id = b.idTable
	end
	go
	
	select * from Account
	go
	create proc USP_UpdateAccount
	@username nvarchar(100), @displayName nvarchar(100), @passWord nvarchar(100), @newPassWord nvarchar(100)
	as
	begin
		declare @isRightPass int = 0;
		select @isRightPass = COUNT(*) from Account where Username = @username 
			and PassWord = @passWord
		if(@isRightPass = 1)
		begin
			if(@newPassWord	= NULL or @newPassWord = '')
			begin
				update Account set DisplayName = @displayName where Username = @username
			end
			else
				update Account set DisplayName = @displayName , PassWord = @passWord where Username = @username
		end
	end
	go
	
	update Food set Name = N'' , idCategory = 5 , price = 0 where id = 1
	go
	create trigger DeleteBillInfo
	on dbo.billInfo for delete
	as
	begin
		declare @idBillInfo int
		declare @idbill int
		select @idBillInfo = ID , @idbill = deleted.idBill from deleted
		declare @idTable int
		select @idTable = idTable from bill where id = @idbill
		declare @count int  = 0
		select @count = COUNT(*) from billInfo as bi, bill as b 
			where b.id = bi.idBill and b.id = @idbill and b.status = 0
		if(@count = 0)
			update TableFood set status = N'Trống' where id = @idTable
	end
	go
	
go	
CREATE FUNCTION [dbo].[fChuyenCoDauThanhKhongDau](@inputVar NVARCHAR(MAX) )
RETURNS NVARCHAR(MAX)
AS
BEGIN    
    IF (@inputVar IS NULL OR @inputVar = '')  RETURN ''
   
    DECLARE @RT NVARCHAR(MAX)
    DECLARE @SIGN_CHARS NCHAR(256)
    DECLARE @UNSIGN_CHARS NCHAR (256)
 
    SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'
 
    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
   
    SET @COUNTER = 1
    WHILE (@COUNTER <= LEN(@inputVar))
    BEGIN  
        SET @COUNTER1 = 1
        WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1)
        BEGIN
            IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@inputVar,@COUNTER ,1))
            BEGIN          
                IF @COUNTER = 1
                    SET @inputVar = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)-1)      
                ELSE
                    SET @inputVar = SUBSTRING(@inputVar, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)- @COUNTER)
                BREAK
            END
            SET @COUNTER1 = @COUNTER1 +1
        END
        SET @COUNTER = @COUNTER +1
    END
    -- SET @inputVar = replace(@inputVar,' ','-')
    RETURN @inputVar
END
select * from food where dbo.fChuyenCoDauThanhKhongDau(name) like N'%muc%'

select * from Account