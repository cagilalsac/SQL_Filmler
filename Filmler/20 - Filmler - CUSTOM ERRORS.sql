-- CUSTOM ERRORS --
use Filmler
go
exec sp_addmessage @msgnum = 50001, @severity = 16, @msgtext = 'Bu bir hata mesaj�d�r!', @with_log = 'true'
-- @msgnum: 0 - 49999 (Sistem mesajlar�)
--		    50000 - ... (raiserror kaynakl� bizim kendi �retti�imiz hatalar)
-- @severity: 0 - 16 (Kullan�c� veri giri�inden kaynakl� hatalar, bu hatalar� kullan�c� d�zeltebilir)
--			  17 (Disk dolu hatas�)
--			  18 (Yaz�l�mdan kaynakl� bir hata)
--			  19 (constraint hatas�)
--			  20 - 25 (�ok kritik hatalar)
-- @msgtext: Mesaj string'i
-- @with_log: true (Windows taraf�ndan log tutulup tutulmayaca��n� belirtir)
-----------------------------------------------------------------------------------------------------------
-- Hatay� kullanma:
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
exec sp_dropmessage 50001 -- olu�turulan hata mesaj�n� siler