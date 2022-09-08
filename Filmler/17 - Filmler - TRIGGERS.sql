-- TRIGGERS --
-- Trigger: Tetikleyici
use Filmler
go
--create trigger tg_tetikleyiciismi on tabloadi for <ne için gerekli>
--as
--...
--...
--sorgu kodlarý
--...
truncate table Filmyedek
go
insert into Filmyedek select * from Film
go
select id, adi, yapimyili, gisesi into Filmyedek_log from Filmyedek
go
select * from Filmyedek_log
go
truncate table Filmyedek_log
go
alter table Filmyedek_log
add durum varchar(125)
go
alter table Filmyedek_log
add kullanici varchar(30)
go
alter table Filmyedek_log
add tarih smalldatetime
go
select * from Filmyedek_log
go
create trigger tg_filmekle on Filmyedek for insert
as
declare @id int, @adi varchar(300), @yapimyili char(4), @gisesi money
select @id = id, @adi = adi, @yapimyili = yapimyili, @gisesi = gisesi from inserted
insert into Filmyedek_log values (@id, @adi, @yapimyili, @gisesi, 'Kaydedildi!', SUSER_SNAME(), GETDATE()) 
-- Filmyedek tablosuna tetikleyici ekledik. Filmyedek tablosuna insert iþlemi gerçekleþtiðinde 
-- çalýþacak. Ne yapacak? Bunu as'dan sonra belirtiyoruz. Ekleme yaptýðýmýz zaman ilk önce 
-- inserted diye bir tabloya ekleme yapýlýyor. inserted'dan aldýðýmýz bilgileri Filmyedek_log
-- tablosuna bizim parametrelerimizi de ekleyerek insert ediyoruz.
-- suser_sname(): Session kullanici adi (burada sa).
go
create trigger tg_filmsil on Filmyedek for delete
as
declare @id int, @adi varchar(300), @yapimyili char(4), @gisesi money
select @id = id, @adi = adi, @yapimyili = yapimyili, @gisesi = gisesi from deleted
insert into Filmyedek_log values (@id, @adi, @yapimyili, @gisesi, 'Silindi!', SUSER_SNAME(), GETDATE())
go
create trigger tg_filmguncelle on Filmyedek for update
as
declare @eskiid int, @eskiadi varchar(300), @eskiyapimyili char(4), @eskigisesi money
declare @yeniid int, @yeniadi varchar(300), @yeniyapimyili char(4), @yenigisesi money
select @eskiid = id, @eskiadi = adi, @eskiyapimyili = yapimyili, @eskigisesi = gisesi from deleted
select @yeniid = id, @yeniadi = adi, @yeniyapimyili = yapimyili, @yenigisesi = gisesi from inserted
insert into Filmyedek_log values (@yeniid, @yeniadi, @yeniyapimyili, @yenigisesi,
'Güncellenmemiþ hali: ' + CAST(@eskiid as varchar(3)) + '; ' + @eskiadi + '; ' + @eskiyapimyili + '; '
+ CAST(@eskigisesi as varchar(25)),
SUSER_SNAME(), GETDATE())
go
insert into Filmyedek values (8, 'Ejder Kapaný', '2009', 0, 900000)
go
select * from Filmyedek
go
select * from Filmyedek_log
go
update Filmyedek set id = 3, gisesi = 600000 where id = 8
go
select * from Filmyedek
go
select * from Filmyedek_log
go
delete from Filmyedek where id = 3
go
select * from Filmyedek
go
select * from Filmyedek_log
go
drop trigger tg_filmguncelle
go
drop trigger tg_filmsil
go
drop trigger tg_filmekle
go
drop table Filmyedek_log
----------------------------------------------------------------------------------------------------------
-- Oyuncuyedek tablosuna insert, update ve delete iþlemleri için sadece tek bir trigger yaz?
go
truncate table Oyuncuyedek
go
insert into Oyuncuyedek (adi, soyadi, dogumtarihi) select adi, soyadi, dogumtarihi from Oyuncu
go
select * from OyuncuYedek
go
select id, adi, soyadi into Oyuncuyedek_log from Oyuncuyedek
go
truncate table Oyuncuyedek_log
go
alter table Oyuncuyedek_log
add durum varchar(125)
go
alter table Oyuncuyedek_log
add kullanici varchar(30)
go
alter table Oyuncuyedek_log
add tarih smalldatetime
go
select * from Oyuncuyedek_log
go
create trigger tg_oyuncuekleguncellesil on Oyuncuyedek for insert, update, delete
as
declare @islem int -- insert: 1, delete: 2, update: 3
set @islem = 0
if (select COUNT(*) from inserted) > 0
begin
	set @islem = @islem + 1
end
if (select COUNT(*) from deleted) > 0
begin
	set @islem = @islem + 2
end
if @islem = 1
begin
	declare @id1 int, @adi1 varchar(50), @soyadi1 varchar(50)
	select @id1 = id, @adi1 = adi, @soyadi1 = soyadi from inserted
	insert into Oyuncuyedek_log values (@adi1, @soyadi1, 'Kaydedildi!', SUSER_SNAME(), GETDATE())
end
else if @islem = 2
begin
	declare @id2 int, @adi2 varchar(50), @soyadi2 varchar(50)
	select @id2 = id, @adi2 = adi, @soyadi2 = soyadi from deleted
	insert into Oyuncuyedek_log values (@adi2, @soyadi2, 'Silindi!', SUSER_SNAME(), GETDATE())
end
else if @islem = 3
begin
	declare @eskiid int, @eskiadi varchar(50), @eskisoyadi varchar(50)
	declare @yeniid int, @yeniadi varchar(50), @yenisoyadi varchar(50)
	select @eskiid = id, @eskiadi = adi, @eskisoyadi = soyadi from deleted
	select @yeniid = id, @yeniadi = adi, @yenisoyadi = soyadi from inserted
	insert into Oyuncuyedek_log values (@yeniadi, @yenisoyadi, 
'Güncellenmemiþ hali: ' + CAST(@eskiid as varchar(3)) + '; ' + @eskiadi + '; ' + @eskisoyadi,
SUSER_SNAME(), GETDATE())
end
go
set dateformat dmy
insert into Oyuncuyedek values ('Çaðýl', 'Alsaç', '17.05.1980')
go
select * from Oyuncuyedek
go
select * from Oyuncuyedek_log
go
set dateformat dmy
update Oyuncuyedek set adi = 'Kenan', soyadi = 'Ýmirzalýoðlu', dogumtarihi = '18.06.1974'
where adi = 'Çaðýl' and soyadi = 'Alsaç'
go
select * from Oyuncuyedek
go
select * from Oyuncuyedek_log
go
delete from Oyuncuyedek where adi = 'Kenan' and soyadi = 'Ýmirzalýoðlu'
go
select * from Oyuncuyedek
go
select * from Oyuncuyedek_log
go
drop trigger tg_oyuncuekleguncellesil
go
drop table Oyuncuyedek_log
----------------------------------------------------------------------------------------------------------
-- Yeni bir kullanýcý tablosu oluþtur. 3 tane veri ekle. Bu verilerden herhangi biri silindiðinde o veriye
-- ait satýrý silme, sadece aktivitesi sütununu 0 yap?
go
create table Kullanici
(
	id int primary key identity(1, 1),
	adi varchar(25) not null,
	sifresi varchar(20) not null,
	aktivitesi bit not null
)
go
insert into Kullanici values ('MasqueR', '123', 1)
go
insert into Kullanici values ('Skulky', '135', 1)
go
insert into Kullanici values ('Pioneer', '246', 1)
go
select * from Kullanici
go
create trigger tg_kullanicisil on Kullanici instead of delete
as
declare @id int
select @id = id from deleted
update Kullanici set aktivitesi = 0 where id = @id
go
delete from Kullanici where adi = 'Skulky' and sifresi = '135'
go
select * from Kullanici
go
drop trigger tg_kullanicisil
go
drop table Kullanici
----------------------------------------------------------------------------------------------------------
-- Veritabanýndan tablo silinmesini engelleme?
--go
--create trigger tg_tablosildirme on database for drop_table
--as
--print 'Bu veritabanýndan tablo silmenize izin yoktur!'
--rollback tran
--go
--drop table Oyuncuyedek
----------------------------------------------------------------------------------------------------------
-- Filmyedek tablosuna giriþ yapýldýðýnda eðer yonetmen_id sütununa 0 veya NULL deðer girilirse 
-- iþlemi iptal et?
go
create trigger tg_filmekle on Filmyedek for insert
as
declare @yonetmenid int
select @yonetmenid = yonetmen_id from inserted
if @yonetmenid = 0
begin	
	print 'Lütfen filmin yönetmenini belirtiniz!'
	rollback tran
end
go
insert into Filmyedek values (3, 'Ejder Kapaný', '2009', 0, 900000)
--go
--insert into Filmyedek (id, adi, yapimyili, gisesi) values (3, 'Ejder Kapaný', '2009', 900000)
-- Bu sorgu hata verir çünkü Filmyedek tablosu yonetmen_id sütununun boþ býrakýlmasýna izin vermez. 
-- Bir sütunun NULL deðer alýp alamayacaðýný tablo yaratýrken de belirleyebiliriz ve 
-- öyle kontrol saðlayabiliriz! (Bu sorguda olduðu gibi.) 
go
select * from Filmyedek
go
drop trigger tg_filmekle
----------------------------------------------------------------------------------------------------------
-- Log Trigger:
create trigger [dbo].[tg_filmLogla] on [dbo].[Film] after insert, update, delete
as
declare @islem varchar(50)
if exists (select 1 from inserted) and exists(select 1 from deleted)
begin
	set @islem = 'update (old)'
	insert into FilmLog ([adi],[yapimyili],[yonetmen_id],[gisesi],[islemtarihi],[islemyapan],islem,[film_id]) 
	select [adi],[yapimyili],[yonetmen_id],[gisesi],getdate(),SUSER_SNAME(),@islem,id from deleted
	set @islem = 'update (new)'
	insert into FilmLog ([adi],[yapimyili],[yonetmen_id],[gisesi],[islemtarihi],[islemyapan],islem,[film_id]) 
	select [adi],[yapimyili],[yonetmen_id],[gisesi],getdate(),SUSER_SNAME(),@islem,id from inserted
end
else if exists (select 1 from inserted)
begin
	set @islem = 'insert'
	insert into FilmLog ([adi],[yapimyili],[yonetmen_id],[gisesi],[islemtarihi],[islemyapan],islem,[film_id]) 
	select [adi],[yapimyili],[yonetmen_id],[gisesi],getdate(),SUSER_SNAME(),@islem,id from inserted
end
else	
begin
	set @islem = 'delete'
	insert into FilmLog ([adi],[yapimyili],[yonetmen_id],[gisesi],[islemtarihi],[islemyapan],islem,[film_id]) 
	select [adi],[yapimyili],[yonetmen_id],[gisesi],getdate(),SUSER_SNAME(),@islem,id from deleted
end
----------------------------------------------------------------------------------------------------------
-- INSTEAD OF Trigger:
create table Test1 (
	id int not null,
	ad varchar(50) not null,
	tarih datetime null
)
alter table Test1 add silindi bit null

create trigger tg_Test1updateTarih on Test1 instead of insert
as
insert into Test1 (id, ad, tarih) select id, ad, GETDATE() from inserted

insert into Test1 (id, ad) values (2, 'Leo')
select * from Test1

create trigger tg_Test1preventDelete on Test1 instead of delete
as
declare @id int
select @id = Test1.id from Test1 inner join deleted on Test1.id = deleted.id
update Test1 set silindi = 1 where id = @id

delete from Test1 where id = 2
select * from Test1
select * from Test1 where silindi is null or silindi = 0