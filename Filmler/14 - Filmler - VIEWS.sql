-- VIEWS --
-- VIEW: Sanal tablolard�r ve daha yava� �al���rlar. 
-- Do�ru haz�rlanan bir view �zerinden insert, delete ve update �ekebiliriz.
-------------------------------------------------------------------------------------------------------
use Filmler
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
create view vw_oyuncu
as
select adi, soyadi from Oyuncu
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
alter view vw_oyuncu
as
select adi as oyuncuadi, soyadi as oyuncusoyadi from Oyuncu
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select * from vw_oyuncu
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
drop view vw_oyuncu
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
--create view vw_film 
--as 
--select * from Film order by adi
-- View olu�turulurken order by'a m�saade etmez, bu kod hata verir. Ama top'a izin verir.
-------------------------------------------------------------------------------------------------------
create view vw_film
as
select top 50 percent * from Film
-- Sonucun % 50'sini getir.
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select * from vw_film
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
drop view vw_film
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
create view vw_yonetmen with schemabinding
as
select adi, soyadi from dbo.Yonetmen
-------------------------------------------------------------------------------------------------------
-- with schemabinding ile dbo'ya dikkat!
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select * from vw_yonetmen
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
drop view vw_yonetmen
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
-- with schemabinding: Kendinden sonraki s�tunlarda kilitleme yap�yor, b�ylece bu s�tunlar silinemiyor.
-- Ge�ici g�venlik sa�lar.
-------------------------------------------------------------------------------------------------------
--===================================================================================================--
-- SQL Server'a direkt olarak ba�lan�rken: 
-- 1- Makine ad�, 2- Database, 3- Schema (dbo), 4- Tablo ad�, 5- S�tun ad�
-- Schema'lar �zerinden kullan�c�lara g�re i�lemler sa�layabiliriz.
-- dbo: Schema ad�
-------------------------------------------------------------------------------------------------------
use master
-------------------------------------------------------------------------------------------------------
select Filmler.dbo.Film.adi from Filmler.dbo.Film
-------------------------------------------------------------------------------------------------------
use Filmler
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
--===================================================================================================--
-------------------------------------------------------------------------------------------------------
create view vw_film
as
select adi, yapimyili, SUM(gisesi) as gisesi from Film group by adi, yapimyili
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
alter view vw_film with encryption
as
select adi, yapimyili, SUM(gisesi) as gisesi from Film group by adi, yapimyili
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select adi, yapimyili, gisesi from vw_film order by gisesi desc
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
drop view vw_film
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
-- with encryption: Sorgunun do�rudan Query Designer ile d�zenlenmesine m�saade etmez.
-- Kald�rmak i�in with encryption olmadan sorgunun yeniden ayn� �ekilde yaz�l�p �al��t�r�lmas� gerekir.
-------------------------------------------------------------------------------------------------------
create view vw_film
as
select adi, yapimyili, SUM(gisesi) as gisesi from Film group by adi, yapimyili
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
alter view vw_film
as
select adi, yapimyili, SUM(gisesi) as gisesi from Film group by adi, yapimyili
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select adi, yapimyili, gisesi from vw_film order by gisesi desc
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
--===================================================================================================--
sp_helptext vw_film
-- Bize vw_film i�in yaz�lan sorguyu getirir.
--===================================================================================================--
-------------------------------------------------------------------------------------------------------
drop view vw_film
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
truncate table Oyuncuyedek
insert into Oyuncuyedek (adi, soyadi, dogumtarihi)  select adi, soyadi, dogumtarihi from Oyuncu
select * from Oyuncuyedek
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
create view vw_oyuncuyedek
as
select adi, soyadi from Oyuncuyedek where adi like 'r%' with check option
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select * from vw_oyuncuyedek
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
--insert into vw_oyuncuyedek (adi, soyadi) values ('Michael', 'Jackson')
-- Hata verir ��nk� with check option var.
-- with check option oldu�unda view'a sadece select'in i�indeki where �art�na g�re insert yap�labilir.
-------------------------------------------------------------------------------------------------------
insert into vw_oyuncuyedek (adi, soyadi) values ('Robin', 'Williams')
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select * from vw_oyuncuyedek
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
select * from Oyuncuyedek
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
truncate table Oyuncuyedek
-------------------------------------------------------------------------------------------------------
go
-------------------------------------------------------------------------------------------------------
drop view vw_oyuncuyedek
-------------------------------------------------------------------------------------------------------
-- ROW_NUMBER():
create view vw_filmYonetmenTur
as
select ISNULL(ROW_NUMBER() over (order by f.adi), -1) as id, f.adi as Film, y.adi + ' ' + y.soyadi 
as Yonetmen, t.adi as Turu from Film f, Yonetmen y, FilmTur ft, Tur t where f.yonetmen_id = y.id
and f.id = ft.film_id and ft.tur_id = t.id