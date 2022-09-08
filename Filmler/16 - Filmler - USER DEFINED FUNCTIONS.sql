-- KULLANICI TANIMLI FONKSÝYONLAR --
use Filmler
-- 1) Scalar Functions:
-- Geriye tek bir deðer döndüren fonksiyon.
--------------------------------------------------------------------------------------------------------
--create function fn_fonksiyonadi(parametreler) returns dönüþtipi
--as
--begin
--	...........................
--	return dönüþtipinde_deðer
--end
--------------------------------------------------------------------------------------------------------
-- Ýki parametrenin toplamýný geriye döndüren fonksiyon?
go
create function fn_topla(@sayi1 int, @sayi2 int) returns int
as
begin
	declare @toplam int
	set @toplam = @sayi1 + @sayi2
	return @toplam
end
-- Database'in içinde, Programmability içinde, Functions içinde, Scalar-values Function içinde tutulur!
--------------------------------------------------------------------------------------------------------
go
select dbo.fn_topla(12, 44) as ikisayitoplami
--------------------------------------------------------------------------------------------------------
go
drop function fn_topla
--------------------------------------------------------------------------------------------------------
-- Ýlk 3 filmin giþe ortalamasý?
go
select top 3 * from Film
go
create function fn_ilkucfilmingiseortalamasi (@gise1 money, @gise2 money, @gise3 money, @filmsayisi int) 
	returns money
as
begin
	declare @toplam money, @ortalamagise money
	set @toplam = @gise1 + @gise2 + @gise3
	set @ortalamagise = @toplam / @filmsayisi
	return @ortalamagise
end
--------------------------------------------------------------------------------------------------------
-- Bir sütun ve satýrda arada - býrakýlarak birleþtirilen ilk 3 film adý?
go
create function fn_ilkucfilmadinibirlestir (@ad1 varchar(30), @ad2 varchar(30), @ad3 varchar(30))
	returns varchar(100)
as
begin
	declare @adlarbirlesmis varchar(100)
	set @adlarbirlesmis = @ad1 + ' - ' + @ad2 + ' - ' + @ad3
	return @adlarbirlesmis
end
--------------------------------------------------------------------------------------------------------
go
declare @hasilat1 money, @hasilat2 money, @hasilat3 money, 
	@filmadi1 varchar(30), @filmadi2 varchar(30), @filmadi3 varchar(30),
	@ilkucfilmadi varchar(100)
select @hasilat1 = gisesi from Film where id = 1
select @hasilat2 = gisesi from Film where id = 2
select @hasilat3 = gisesi from Film where id = 4
select @filmadi1 = adi from Film where id = 1
select @filmadi2 = adi from Film where id = 2
select @filmadi3 = adi from Film where id = 4
select dbo.fn_ilkucfilmadinibirlestir (@filmadi1, @filmadi2, @filmadi3) as ilkucfilmadi, 
	   dbo.fn_ilkucfilmingiseortalamasi (@hasilat1, @hasilat2, @hasilat3, 3) as ilkucfilmortalamagisesi
go
drop function fn_ilkucfilmadinibirlestir
go
drop function fn_ilkucfilmingiseortalamasi
--------------------------------------------------------------------------------------------------------
-- Parametre olarak gönderilen ayraçla tarih yaz?
go
create function fn_tarihyaz (@tarih datetime, @ayrac char(1)) returns varchar(10)
as
begin
	declare @sonuc varchar(10), @gun varchar(2), @ay varchar(2), @yil varchar(4)
	select @gun = DAY(@tarih)
	select @ay = MONTH(@tarih)
	select @yil = YEAR(@tarih)
	set @sonuc = @gun + @ayrac + @ay + @ayrac + @yil
	return @sonuc
end
--------------------------------------------------------------------------------------------------------
go
select dbo.fn_tarihyaz (GETDATE(), '=') as tarih
go
drop function fn_tarihyaz
--------------------------------------------------------------------------------------------------------
-- Fonksiyonlarý tablo yaratýrken de kullanabiliyoruz:
--create table Urun
--(
--	id int primary key identity(1, 1),
--	adi varchar(50),
--	fiyati money,
--	adeti int,
--	kdvlifiyati as dbo.fn_kdvlifiyati (fiyati, adeti)
--)
--------------------------------------------------------------------------------------------------------
-- Bir cümleyi þifreleyecek fonksiyon?
go
create function fn_sifrele (@input varchar(20)) returns varchar(20)
as
begin
	declare @i int, @output varchar(20)
	set @output = ''
	set @i = 1
	while @i <= LEN(@input)
	begin
		set @output = @output + char(ASCII(SUBSTRING(@input, @i, 1)) - 1)
		set @i = @i + 1
	end
	return @output
end
--------------------------------------------------------------------------------------------------------
go
create function fn_desifrele (@input varchar(20)) returns varchar(20)
as
begin
	declare @i int, @output varchar(20)
	set @output = ''
	set @i = 1
	while @i <= LEN(@input)
	begin
		set @output = @output + char(ASCII(SUBSTRING(@input, @i, 1)) + 1)
		set @i = @i + 1
	end
	return @output
end
--------------------------------------------------------------------------------------------------------
go
select dbo.fn_desifrele ('TRJTLQT') as desifrelenmis, dbo.fn_sifrele ('USKUMRU') as sifrelenmis
go
drop function fn_desifrele
go
drop function fn_sifrele
--------------------------------------------------------------------------------------------------------
-- 2) Inline Functions:
-- Geriye sadece tablo döndürür, içine attýðýmýz parametreler üzerinde oynamamýzý saðlamaz.
go
create function fn_inlinefilmtablo (@filmadi varchar(30)) returns table
as
	return (select * from Film where adi = @filmadi)
--------------------------------------------------------------------------------------------------------
go
select * from dbo.fn_inlinefilmtablo ('Avatar')
go
drop function fn_inlinefilmtablo
--------------------------------------------------------------------------------------------------------
-- 3) Multi-Statement Functions:
-- Geriye tablo döndürür, içine attýðýmýz parametreler üzerinde oynamamýzý saðlar.
-- Fonksiyonu çalýþtýrdýðýmýz zaman select * from @yedektablo otomatik olarak çalýþýr.
go
create function fn_multistatementtabloyedekle (@tabloadi varchar(10))
	returns @yedektablo table (id int, adi varchar(300))
as
begin
	if @tabloadi = 'Film'
	begin
		insert into @yedektablo select id, adi from Film
	end
	else if @tabloadi = 'Yonetmen'
	begin
		insert into @yedektablo select id, adi + SPACE(1) + soyadi from Yonetmen
	end
	else if @tabloadi = 'Oyuncu'
	begin
		insert into @yedektablo select id, adi + SPACE(1) + soyadi from Oyuncu
	end
	return
end
--------------------------------------------------------------------------------------------------------
go
select * from dbo.fn_multistatementtabloyedekle ('Film')
select * from dbo.fn_multistatementtabloyedekle ('Yonetmen')
select * from dbo.fn_multistatementtabloyedekle ('Oyuncu')
go
drop function fn_multistatementtabloyedekle
--------------------------------------------------------------------------------------------------------
-- Yapým yýlýna göre film adlarý ve toplam giþeleri:
create function fn_filmToplamGise(@yapimyili char(4))
returns @resulttable table (adi varchar(100), toplamgise float)
as
begin
if @yapimyili = '*'
begin
	insert into @resulttable (adi, toplamgise) 
	select adi, SUM(gisesi) from Film group by adi
end
else
begin
	insert into @resulttable select adi, SUM(gisesi) from Film 
	where yapimyili = @yapimyili
	group by adi
end
return
end 
select * from dbo.fn_filmToplamGise('2009')
select * from dbo.fn_filmToplamGise('*')