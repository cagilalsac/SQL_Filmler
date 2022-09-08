-- GEÇÝCÝ TABLOLAR --
use Filmler
-- Sadece kendi oturumumuz için geçici tablo oluþturma: Sadece kendimiz ulaþabiliriz.
select adi, soyadi into #GeciciTablo from Oyuncu
select * from #GeciciTablo
-- Geçici tablonun ömrü oturumumuz açýk kaldýðý müddetçedir.
drop table #GeciciTablo
go
select adi, soyadi into #GeciciTablo from Oyuncu
-- Geçici tablodaki verileri gerçek tabloya aktarma:
truncate table OyuncuYedek
insert into Oyuncuyedek (adi, soyadi) select adi, soyadi from #GeciciTablo
select * from Oyuncuyedek
drop table #GeciciTablo
go
-- Diðer kullanýcý oturumlarý için de geçici tablo oluþturma: Kendimiz ve tüm kullanýcýlar ulaþabilir.
-- Geçici tabloyu oluþturan kiþinin oturumu açýk kaldýðý müddetçe diðer kullanýcýlarýn da o geçici 
-- tabloyu görebilmeleri için aþaðýdaki tablo kullanýlýr:
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
