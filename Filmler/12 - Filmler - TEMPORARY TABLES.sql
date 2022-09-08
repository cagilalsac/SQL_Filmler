-- GE��C� TABLOLAR --
use Filmler
-- Sadece kendi oturumumuz i�in ge�ici tablo olu�turma: Sadece kendimiz ula�abiliriz.
select adi, soyadi into #GeciciTablo from Oyuncu
select * from #GeciciTablo
-- Ge�ici tablonun �mr� oturumumuz a��k kald��� m�ddet�edir.
drop table #GeciciTablo
go
select adi, soyadi into #GeciciTablo from Oyuncu
-- Ge�ici tablodaki verileri ger�ek tabloya aktarma:
truncate table OyuncuYedek
insert into Oyuncuyedek (adi, soyadi) select adi, soyadi from #GeciciTablo
select * from Oyuncuyedek
drop table #GeciciTablo
go
-- Di�er kullan�c� oturumlar� i�in de ge�ici tablo olu�turma: Kendimiz ve t�m kullan�c�lar ula�abilir.
-- Ge�ici tabloyu olu�turan ki�inin oturumu a��k kald��� m�ddet�e di�er kullan�c�lar�n da o ge�ici 
-- tabloyu g�rebilmeleri i�in a�a��daki tablo kullan�l�r:
select adi, soyadi into ##GeciciTablo from Oyuncu
select * from ##GeciciTablo
drop table ##GeciciTablo

CREATE TABLE [dbo].[##FilmTMP](
	[id] [int] NOT NULL,
	[adi] [varchar](300) NOT NULL,
	[yapimyili] [char](4) NULL,
	[gisesi] [money] NULL
)
insert into ##FilmTMP (id, adi, yapimyili, gisesi) 
select id, adi, yapimyili, gisesi from Film
select * from ##FilmTMP

if OBJECT_ID('tempdb..#OyuncuTMP') is not null
	drop table #OyuncuTMP
select adi, soyadi into #OyuncuTMP from Oyuncu
select * from #OyuncuTMP
