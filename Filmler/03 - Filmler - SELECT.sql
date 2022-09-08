-- SELECT --
use Filmler
-- Filmler veritabanýný kullan
--: yorum satýrý, *: tüm sütunlar, select: nelerin döneceði, from: hangi tablodan
select * from Film
select id, adi, yapimyili, yonetmen_id, gisesi from Film
-- SQL sorgularýnda sadece ihtiyacýmýz olan sütunlarý getirmekte fayda var.
-- Bir tablo kendi kendine de iliþki kurabilir.
select id as [Film ID], adi as [Film Adi], yapimyili as [Yapim Yili], yonetmen_id as YonetmenID,
gisesi as [Gisesi] from Film
-- as ile yapýlan iþlem alias tanýmlama'dýr. sütunlara alias tanýmlayabildiðimiz gibi alias'larý 
-- tablolara da tanýmlayabiliriz.
select adi + ' ' + soyadi as oyuncuadisoyadi, dogumtarihi from Oyuncu
-- metinsel ifadeler tek týrnakla ifade edilir. burda adi ile soyadi sütunlarýný arada boþluk ile 
-- birleþtiriyoruz, oyuncuadisoyadi isimli bir sütuna alias vererek dogumtarihi ile birlikte çekiyoruz.
-- Not: SQL Server Profiler ile SQL Server'da yaptýðýmýz bütün iþlemleri görebiliyoruz!
select adi + ' ' + soyadi as oyuncuadisoyadi, CONVERT(varchar(10), dogumtarihi, 104) as oyuncudogumtarihi
from Oyuncu
-- CONVERT(neye çevireceði, neyi çevireceði, formatý)
-- 104: tarih formatý (Alman tarih formatý)
select CAST(id as varchar(5)) + ' - ' + adi + ' ' + soyadi as oyuncu from Oyuncu 
-- CAST(neyi çevireceði as neye çevireceði)
select * from Oyuncu order by adi
-- order by: sütun adýna göre sýralama, default'u ascending (asc)
select * from Oyuncu order by adi desc
-- descending (desc)
select * from Oyuncu order by adi, soyadi
-- önce adi sütununa göre artan sýralama yapar, sonra adi sütununa göre sýraladýklarýný soyadi sütununa göre artan sýralar.
select * from Yonetmen order by adi, soyadi desc
-- önce adi sütununa göre artan sýralama yapar, sonra adi sütununa göre sýraladýklarýný soyadi sütununa göre azalan sýralar.
select * from Oyuncu order by 2
-- 2: sütun adý (adi)
select * from Oyuncu order by 3 desc
-- 3: sütun adý (soyadi)
select COUNT(*) from Oyuncu
select COUNT(adi) as toplamfilm from Film
-- COUNT(sütun adý) veya COUNT(*): row sayýsýný verir
select COUNT(dogumtarihi) from Oyuncu
-- COUNT(sütun adý): NULL olanlarý saymaz
select MAX(gisesi) as [En Cok Gise] from Film
-- MAX(sütun adý): o sütundaki verilerden en büyük deðeri ver
select MIN(gisesi) as [En Az Gise] from Film
-- MIN(sütun adý): o sütundaki verilerden en küçük deðeri ver
select SUM(gisesi) as [Toplam Gise] from Film
-- SUM(sütun adý): o sütundaki verilerin toplamýný ver
select AVG(gisesi) as [Ortalama Gise] from Film
-- AVG(sütun adý): o sütundaki verilerin ortalama deðerini ver
select top 5 * from Oyuncu
-- TOP sayý sütun adý: ilk beþ kaydý getirir
select top 5 * from Oyuncu order by 1 desc
-- Burda order by desc'den dolayý son 5 kaydý getirir
-- Eðer tablo veya sütun adlarýnda boþluk varsa [] kullanýlmasý gerek!
select top 1 * from film order by id 
-- film tablosundaki ilk kaydý getirir
select top 1 * from film order by id desc 
-- film tablosundaki son kaydý getirir
use master
select * from Filmler.dbo.Film
-- dbo: schema
use Filmler
select * from Oyuncu where id = 5
select * from Oyuncu where id = '5'
-- id'si 5 olan kayýtlarý getir. ikisi de çalýþýr, kendi kendine convert yapar (where clause'unun içinde)
select * from Oyuncu where id != 5
select * from Oyuncu where id <> 5
select * from Oyuncu where not id = 5
-- id'si 5 olmayan kayýtlarý getir
select * from Oyuncu where id < 4 order by id desc 
select * from Oyuncu where id > 4 -- id'ye göre artan sýralama için order by id yazmaya gerek yoktur çünkü id primary key ve index olduðundan otomatikman id'ye göre artan sýralý gelir
-- where: þart belirtir
/* Yorum satýrý 1 
 * Yorum satýrý 2
 * Yorum satýrý 3
 * Yorum satýrý 4
 */
select * from Oyuncu where id >= 2 and id <= 4
select * from Oyuncu where id < 2 or id > 4 -- 1. sorgu
select * from Oyuncu where not (id >= 2 and id <= 4) -- 2. sorgu
-- üstteki iki sorgu ayný sonucu verir çünkü 1. sorgu 2. sorgunun deðil operatörü parantez içerisindeki koþullara daðýtýlmýþ halidir
/*
Koþul 1 		and			Koþul 2				Sonuç Koþulu		Örnek Tabloda Aranan Veriler	Örnek Tablodan Dönen Sonuç Verileri
id >= 3						id <= 5
1 (true)					1 (true)			1 (true)			3, 4, 5							3, 4, 5
1 (true)					0 (false)			0 (false)			11								Veri dönmez
0 (false)					1 (true)			0 (false)			2								Veri dönmez
id > 5						id < 3
0 (false)					0 (false)			0 (false)			4								Veri dönmez
*/
/*
Koþul 1 		or			Koþul 2				Sonuç Koþulu		Örnek Tabloda Aranan Veriler	Örnek Tablodan Dönen Sonuç Verileri
id >= 3						id <= 5
1 (true)					1 (true)			1 (true)			3, 4, 5							3, 4, 5
1 (true)					0 (false)			1 (true)			11, Diðer veriler				11, Diðer veriler
0 (false)					1 (true)			1 (true)			2, Diðer veriler				2, Diðer veriler
id > 5						id < 3
0 (false)					0 (false)			0 (false)			4								Veri dönmez
*/
select * from Oyuncu where id < 2 and id > 4
-- veri dönmez
select * from Oyuncu where adi = 'Sigourney' and soyadi = 'Weaver' and dogumtarihi = '1949-10-08'
select * from Oyuncu where (adi = 'Sigourney' and soyadi = 'Weaver') or adi = 'Zoe'
-- adý Sigourney ve soyadý Weaver olan veya adý Zoe olan kayýtlarý getir
select * from Oyuncu where (adi = 'Sigourney' and soyadi = 'Weaver') or (adi = 'Zoe' and soyadi = 'Saldana')
-- adý Sigourney ve soyadý Weaver olan veya adý Zoe ve soyadý Saldana olan kayýtlarý getir
select * from Oyuncu where ((adi = 'Sigourney' and soyadi = 'Weaver') or (adi = 'Zoe' and soyadi = 'Saldana')) and dogumtarihi > '1970-01-01'
-- adý Sigourney ve soyadý Weaver olan veya adý Zoe ve soyadý Saldana olan ve doðum tarihi 01.01.1970'ten büyük olan kayýtlarý getir
-- eðer koþullarda hem and hem de or kullanýlýyorsa ilgili koþullar mutlaka paranteze alýnmalýdýr
select * from Tur where id = 1 or id = 3 or id = 5
select * from Tur where id in (1, 3, 5)
-- in (deðerler): küme içerisinden seçim yapar, deðerleri parantez içindeki parametreler olanlarý getir
select * from Tur where id not in (1, 3, 5)
--not in (deðerler): küme dýþýndan seçim yapar, deðerleri parantez dýþýndaki parametreler olanlarý getir
select * from Tur where id between 2 and 4
select * from Film where yapimyili is NULL
select * from Film where yapimyili is not null
select * from Film where adi = 'Avatar'
select * from Film where adi like 'Avatar'
-- üstteki iki sorgu ayný sonucu verir çünkü like içerisinde % kullanýlmazsa = gibi davranýr
select * from Film where adi like 'a%'
-- a ile baþlayan sonu ne olursa olsun getir
select * from Film where adi like '%ata%'
-- içinde ata geçenleri getir, baþý ve sonu önemli deðil
select * from Film where adi like '%de'
-- sonu de ile bitenleri getir
select * from Film where adi like 'yar%'
-- yar ile baþlayanlarý getir 
select * from Film where adi not like 'yar%'
-- yar ile baþlamayanlarý getir
select * from Film where adi like '%týk'
-- týk ile bitenleri getir
select * from Film where adi like '%at%'
-- içinde at geçenleri getir
select * from Film where adi like '%av%'
-- içinde av geçenleri getir, baþýnda veya sonunda geçse de veri döner
select * from Film where adi like '___r%'
-- ilk 3 karakteri ne olursa olsun 4. karakteri r olan ve sonrasý ne olursa olsun getir 
-- (sonunda hiçbir þey de olmayabilir, birþeyler de)
select * from Oyuncu where adi like '[jr]%' order by adi
-- r veya j ile baþlayan kayýtlarý getir
select * from Oyuncu where adi like '[j-r]%' order by adi
-- baþ harfi j ve r arasýndaki karakterlerle baþlayanlarý getir
select * from Oyuncu where adi like '[r-j]%' order by adi
-- [] içindeki karakterler sýralý olmalý yoksa boþ tablo döner
select * from Oyuncu where adi like '[rj]_[^c]%e'
-- r ya da j harfinden biri ile baþlayacak, ikinci harf önemli deðil, üçüncü c olmayacak 
-- ve arada ne geçerse geçsin son harfi e olacak
-- burda karakterleri 1'den saymaya baþlýyoruz
select 'Çaðýl' + ' ' + 'Alsaç' AdýSoyadý
select 1 + 2 + 3 as Toplam
-- select her zaman bir tablo ile kullanýlmaz, istenilen veriler yazýlýp ihtiyaca göre üzerinde iþlemler yapýlarak çekilebilir
select adi, soyadi, 'Oyuncu' [Tablo Adý] from oyuncu
-- select ile adi ve soyadi ile birlikte 'Oyuncu' metinsel verisini de tablo adý olarak getir