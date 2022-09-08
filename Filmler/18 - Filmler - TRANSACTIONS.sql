-- TRANSACTIONS --
-- begin tran (veya begin transaction)
-- commit tran (veya commit transaction)
-- rollback tran (veya rollback transaction)
use Filmler
go
truncate table Filmyedek
go
insert into Filmyedek select * from Film
go
select * from Filmyedek
go
begin tran
declare @silinensatirsayisi1 int
delete from Filmyedek where id > 4
select @silinensatirsayisi1 = @@ROWCOUNT
if @silinensatirsayisi1 > 1
begin
	print 'Bir kayýttan (satýrdan) daha fazla kayýt (satýr) silemezsiniz!'
	rollback tran
end
else
begin
	print 'Silme iþlemi baþarýlý!'
	commit tran
end
go
select * from Filmyedek
go
begin tran
declare @silinensatirsayisi2 int
delete from Filmyedek where id = 4
select @silinensatirsayisi2 = @@ROWCOUNT
if @silinensatirsayisi2 > 1
begin
	print 'Bir kayýttan (satýrdan) daha fazla kayýt (satýr) silemezsiniz!'
	rollback tran
end
else
begin
	print 'Silme iþlemi baþarýlý!'
	commit tran
end
go
select * from Filmyedek
-- begin tran ile sorguya baþladýk.
-- begin tran ile baþladýðýmýz sorgu sonucu commit tran'i görmeden fiziksel ortama alýnmaz.
-- rollback tran yaptýðý iþlemi (sorguyu) iptal eder yani sorgunun sonucunun fiziksel ortama 
-- yansýmasýný iptal eder.
-- commit tran ise fiziksel veritabanýnda iþlemi gerçekleþtirir.
--------------------------------------------------------------------------------------------------------
go
begin tran
insert into Filmyedek values (3, 'Ejder Kapaný', 2009, 0, 900000)
if (select COUNT(*) from Filmyedek) > 5
begin
	print 'Tablo dolu!, Yeni kayýt ekleyemezsiniz!'
	rollback tran
end
else
begin	
	print 'Ekleme iþlemi baþarýlý!'
	commit tran
end
go
select * from Filmyedek
go
begin tran
insert into Filmyedek values (3, 'Ejder Kapaný', 2009, 0, 900000)
if (select COUNT(*) from Filmyedek) > 6
begin
	print 'Tablo dolu!, Yeni kayýt ekleyemezsiniz!'
	rollback tran
end
else
begin	
	print 'Ekleme iþlemi baþarýlý!'
	commit tran
end
go
select * from Filmyedek
--------------------------------------------------------------------------------------------------------
-- Try Catch
begin transaction myTransaction
begin try
	insert into Film values ('Organize Ýþler 2', 2018, 1, 8900000) 
	update Oyuncu set adi = 'Ms Zoe' where adi = 'Zoe' and soyadi = 'Saldana'
	insert into Tur (adi) values ('Fantastik')
	delete from Tur where id = 'Fantastik' -- yanlýþ sorgu, hata verecek, catch'e düþecek, transaction rollback olacak!
	--delete from Tur where adi = 'Fantastik' -- doðru sorgu, transaction commit olacak.
	commit transaction myTransaction
end try
begin catch
	SELECT ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage
	rollback transaction myTransaction
end catch