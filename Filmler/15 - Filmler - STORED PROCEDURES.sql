-- STORED PROCEDURES --
use Filmler
-- Stored Procedures sorgulardan daha hýzlý çalýþýr.
-- Saklý yordamlardýr, sorgularý saklamamýzý saðlar, böylece daha etkili ve syntax hatasýz çalýþabiliriz.
-- Stored Procedures üzerinden herþeyi yapabiliriz (tablo ekleme, güncelleme, silme, vs.)
--create procedure
--veya
--create proc
--olarak yazabiliyoruz.
--create procedure sp_prosedüradý parametreleri
--as
--sorgu
-- yazýlým þekli budur.
---------------------------------------------------------------------------------------------------------
go
create proc sp_filmselect @id int
as
select * from Film where id = @id
---------------------------------------------------------------------------------------------------------
go
sp_filmselect 1
---------------------------------------------------------------------------------------------------------
go
execute sp_filmselect 2
---------------------------------------------------------------------------------------------------------
go
exec sp_filmselect 4
---------------------------------------------------------------------------------------------------------
go
exec ('select * from Film where id = 4')
---------------------------------------------------------------------------------------------------------
go
drop proc sp_filmselect
---------------------------------------------------------------------------------------------------------
-- execute veya exec stored procedure'lar için kullanýlýyor. 
-- Önemli çünkü bir stored procedure içinde baþka bir stored procedure çalýþtýrmak 
-- istiyorsak kullanmamýz gerekiyor.
-- Kullanma alýþkanlýðý edinirsek iyi olur.
---------------------------------------------------------------------------------------------------------
go
create proc sp_yonetmenselect @deger varchar(20)
as
select * from Yonetmen where adi like @deger + '%'
---------------------------------------------------------------------------------------------------------
go
alter proc sp_yonetmenselect @adi varchar(20), @soyadi varchar(20)
as
select * from Yonetmen where adi like @adi + '%' and soyadi like '%' + @soyadi
---------------------------------------------------------------------------------------------------------
go
exec sp_yonetmenselect 'jam', 'ron'
---------------------------------------------------------------------------------------------------------
go
exec sp_yonetmenselect @soyadi = 'ott', @adi = 'rid'
---------------------------------------------------------------------------------------------------------
go
drop proc sp_yonetmenselect
---------------------------------------------------------------------------------------------------------
go
truncate table Filmyedek
---------------------------------------------------------------------------------------------------------
go
create proc sp_filmyedekinsert @id int, @adi varchar(300), 
	@yapimyili char(4), @yonetmen_id int, @gisesi money
as
insert into Filmyedek (id, adi, yapimyili, yonetmen_id, gisesi) 
	values (@id, @adi, @yapimyili, @yonetmen_id, @gisesi)
---------------------------------------------------------------------------------------------------------
go
exec sp_filmyedekinsert 7, 'Titanic', NULL, 1, NULL
---------------------------------------------------------------------------------------------------------
go
select * from Filmyedek
---------------------------------------------------------------------------------------------------------
go
drop proc sp_filmyedekinsert
---------------------------------------------------------------------------------------------------------
go
truncate table Oyuncuyedek
---------------------------------------------------------------------------------------------------------
go
create proc sp_oyuncuyedekinsert @adi varchar(10) = 'Cem', @soyadi varchar(10) = 'Yýlmaz'
as
insert into Oyuncuyedek (adi, soyadi) values (@adi, @soyadi)
-- Default deðerler tanýmladýk. Eðer exec prosedür ile hiç parametre gelmezse bu deðerler atanacak.
---------------------------------------------------------------------------------------------------------
go
exec sp_oyuncuyedekinsert
---------------------------------------------------------------------------------------------------------
go
exec sp_oyuncuyedekinsert @soyadi = 'Özer'
---------------------------------------------------------------------------------------------------------
go
drop proc sp_oyuncuyedekinsert
---------------------------------------------------------------------------------------------------------
go
select * from Oyuncuyedek
---------------------------------------------------------------------------------------------------------
-- Prosedürler methodlar gibi geriye deðer döndürebiliyor. output kullanýyoruz.
go
create proc sp_idoyuncuyedekinsert @isim varchar(10), @soyisim varchar(10), @id int output
as
insert into Oyuncuyedek (adi, soyadi) values (@isim, @soyisim)
select @id = @@IDENTITY
---------------------------------------------------------------------------------------------------------
go
declare @idno int
exec sp_idoyuncuyedekinsert 'Robert', 'DeNiro', @idno output
select @idno
---------------------------------------------------------------------------------------------------------
go
select * from Oyuncuyedek
---------------------------------------------------------------------------------------------------------
go
drop proc sp_idoyuncuyedekinsert
---------------------------------------------------------------------------------------------------------
-- Yönetmen adý ve soyadýna göre yönetmenin yaptýðý film sayýsý ve filmlerinin toplam giþe hasýlatý?
go
create proc sp_yonetmenfilmsayilaritoplamgiseleri @adi varchar(20), @soyadi varchar(20),
	@adisoyadi varchar(40) output, @filmsayisi int output, @toplamgisesi money output
as
select @adisoyadi = Yonetmen.adi + ' ' + Yonetmen.soyadi, 
	@filmsayisi = COUNT(*), @toplamgisesi = SUM(Film.gisesi)
from Yonetmen inner join Film on Yonetmen.id = Film.yonetmen_id
where Yonetmen.adi = @adi and Yonetmen.soyadi = @soyadi
group by Yonetmen.adi, Yonetmen.soyadi
---------------------------------------------------------------------------------------------------------
go
declare @adi1 varchar(20), @soyadi1 varchar(20), @adisoyadi1 varchar(40)
declare @filmsayisi1 int, @toplamgisesi1 money
set @adi1 = 'James'
set @soyadi1 = 'Cameron'
exec sp_yonetmenfilmsayilaritoplamgiseleri @adi1, @soyadi1, 
	@adisoyadi1 output, @filmsayisi1 output, @toplamgisesi1 output
select @adisoyadi1 as adisoyadi, @filmsayisi1 as toplamfilmsayisi, @toplamgisesi1 as toplamfilmgisesi
---------------------------------------------------------------------------------------------------------
go
drop proc sp_yonetmenfilmsayilaritoplamgiseleri
---------------------------------------------------------------------------------------------------------
-- ID'sini gönderdiðimiz oyuncunun adýný ve soyadýný döndüren prosedür?
go
create proc sp_idyegoreoyuncuadisoyadi @id int,
	@adi varchar(20) output, @soyadi varchar(20) output
as
select @adi = adi, @soyadi = soyadi from Oyuncu where id = @id
---------------------------------------------------------------------------------------------------------
go
declare @ismi varchar(20), @soyismi varchar(20)
exec sp_idyegoreoyuncuadisoyadi 7, @ismi output, @soyismi output
select @ismi as ismi, @soyismi as soyismi
---------------------------------------------------------------------------------------------------------
go
drop proc sp_idyegoreoyuncuadisoyadi
---------------------------------------------------------------------------------------------------------
-- Hem prosedürü oluþtururken hem de prosedürü execute ederken output kullanmamýz gerekiyor.
---------------------------------------------------------------------------------------------------------
-- Geriye return ile de deðer döndürebiliyoruz.
---------------------------------------------------------------------------------------------------------
go
truncate table Oyuncuyedek
insert into Oyuncuyedek (adi, soyadi, dogumtarihi) select adi, soyadi, dogumtarihi from Oyuncu
---------------------------------------------------------------------------------------------------------
go
create proc sp_oyuncuyedekguncelle @id int, @adi varchar(20), @soyadi varchar(20)
as
update Oyuncuyedek set adi = @adi, soyadi = @soyadi
where id <= @id
return @@ROWCOUNT
-- @@ROWCOUNT genelde update, insert ve delete için kullanýlýyor.
---------------------------------------------------------------------------------------------------------
go
declare @satirsayisi int
exec @satirsayisi = sp_oyuncuyedekguncelle 5, 'Lt. Ellen', 'Ripley'
select * from Oyuncuyedek
select @satirsayisi as guncellenensatirsayisi
---------------------------------------------------------------------------------------------------------
go
drop proc sp_oyuncuyedekguncelle
---------------------------------------------------------------------------------------------------------
-- Tablo adý; 1., 2. sütun adlarý; 1., 2. sütun veri tipleri ile tablo oluþturacak stored procedure?
go
create proc sp_tabloyarat @tabloadi varchar(30), @sutun1adi varchar(25), @sutun2adi varchar(25),
	@sutun1veritipi varchar(20), @sutun2veritipi varchar(20)
as
exec ('create table ' + @tabloadi +
	 '(' + @sutun1adi + ' ' + @sutun1veritipi + ' primary key identity(1, 1), '
		 + @sutun2adi + ' ' + @sutun2veritipi + 
	 ')')
---------------------------------------------------------------------------------------------------------
go
exec sp_tabloyarat 'Besteci', 'id', 'adisoyadi', 'int', 'varchar(50)'
---------------------------------------------------------------------------------------------------------
go
select * from Besteci
---------------------------------------------------------------------------------------------------------
go
drop table Besteci
---------------------------------------------------------------------------------------------------------
go
drop proc sp_tabloyarat	 
---------------------------------------------------------------------------------------------------------
-- Film Yedekleme Prosedürü:
create proc [dbo].[p_filmYedekle]
as
begin
	--if exists(select 1 from sys.tables where name = 'FilmYedek')
	--	drop table FilmYedek
	--if OBJECT_ID('FilmYedek') is not null
	--	drop table FilmYedek
	if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'FilmYedek')
		drop table FilmYedek
	CREATE TABLE [dbo].[FilmYedek](
		[id] [int] primary key NOT NULL,
		[adi] [varchar](300) NOT NULL,
		[yapimyili] [char](4) NULL,
		[yonetmen_id] [int] NOT NULL,
		[gisesi] [money] NULL
	)
	truncate table FilmYedek
	insert into FilmYedek (id, adi, yapimyili, yonetmen_id, gisesi)
	select id, adi, yapimyili, yonetmen_id, gisesi from Film
	return 1
end

declare @result int
exec @result = p_filmYedekle
select @result

create proc p_tabloyaGoreFilmYedekle @tablo varchar(200) = 'Film', @yedek varchar(200) = 'Yedek'
as
begin
	if OBJECT_ID(@tablo + @yedek) is not null
		exec ('drop table ' + @tablo + @yedek)
	exec ('select * into ' + @tablo + @yedek + ' from ' + @tablo)
	return 1
end

declare @result int
exec @result = p_tabloyaGoreFilmYedekle 'Yonetmen', 'Backup'
select @result

---------------------------------------------------------------------------------------------------------
-- Oyuncu ekle ve id'sini geri dön:
create proc p_oyuncuEkle @adi varchar(50), @soyadi varchar(50), @dogumtarihi date, @id int output
as
begin
	insert into Oyuncu (adi, soyadi, dogumtarihi) values (@adi, @soyadi, @dogumtarihi)
	set @id = SCOPE_IDENTITY()
end

declare @id int
exec p_oyuncuEkle 'Çaðýl', 'Alsaç', '1980-05-01', @id output
select @id
select * from Oyuncu where id = @id