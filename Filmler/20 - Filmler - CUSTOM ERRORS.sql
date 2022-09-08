-- CUSTOM ERRORS --
use Filmler
go
exec sp_addmessage @msgnum = 50001, @severity = 16, @msgtext = 'Bu bir hata mesajýdýr!', @with_log = 'true'
-- @msgnum: 0 - 49999 (Sistem mesajlarý)
--		    50000 - ... (raiserror kaynaklý bizim kendi ürettiðimiz hatalar)
-- @severity: 0 - 16 (Kullanýcý veri giriþinden kaynaklý hatalar, bu hatalarý kullanýcý düzeltebilir)
--			  17 (Disk dolu hatasý)
--			  18 (Yazýlýmdan kaynaklý bir hata)
--			  19 (constraint hatasý)
--			  20 - 25 (Çok kritik hatalar)
-- @msgtext: Mesaj string'i
-- @with_log: true (Windows tarafýndan log tutulup tutulmayacaðýný belirtir)
-----------------------------------------------------------------------------------------------------------
-- Hatayý kullanma:
go
create proc sp_hatayidene @id int
as
declare @count int
select @count = COUNT(*) from Film where id = @id
if @count = 0
begin	
	raiserror (50001, 16, 1)
end
else
begin
	select * from Film where id = @id
end
-----------------------------------------------------------------------------------------------------------
go
exec sp_hatayidene 1
-----------------------------------------------------------------------------------------------------------
go
exec sp_hatayidene 0
-----------------------------------------------------------------------------------------------------------
go
drop proc sp_hatayidene
go
exec sp_dropmessage 50001 -- oluþturulan hata mesajýný siler