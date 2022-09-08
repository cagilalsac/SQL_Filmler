-- SELECT --
use Filmler
-- Filmler veritaban�n� kullan
--: yorum sat�r�, *: t�m s�tunlar, select: nelerin d�nece�i, from: hangi tablodan
select * from Film
select id, adi, yapimyili, yonetmen_id, gisesi from Film
-- SQL sorgular�nda sadece ihtiyac�m�z olan s�tunlar� getirmekte fayda var.
-- Bir tablo kendi kendine de ili�ki kurabilir.
select id as [Film ID], adi as [Film Adi], yapimyili as [Yapim Yili], yonetmen_id as YonetmenID,
gisesi as [Gisesi] from Film
-- as ile yap�lan i�lem alias tan�mlama'd�r. s�tunlara alias tan�mlayabildi�imiz gibi alias'lar� 
-- tablolara da tan�mlayabiliriz.
select adi + ' ' + soyadi as oyuncuadisoyadi, dogumtarihi from Oyuncu
-- metinsel ifadeler tek t�rnakla ifade edilir. burda adi ile soyadi s�tunlar�n� arada bo�luk ile 
-- birle�tiriyoruz, oyuncuadisoyadi isimli bir s�tuna alias vererek dogumtarihi ile birlikte �ekiyoruz.
-- Not: SQL Server Profiler ile SQL Server'da yapt���m�z b�t�n i�lemleri g�rebiliyoruz!
select adi + ' ' + soyadi as oyuncuadisoyadi, CONVERT(varchar(10), dogumtarihi, 104) as oyuncudogumtarihi
from Oyuncu
-- CONVERT(neye �evirece�i, neyi �evirece�i, format�)
-- 104: tarih format� (Alman tarih format�)
select CAST(id as varchar(5)) + ' - ' + adi + ' ' + soyadi as oyuncu from Oyuncu 
-- CAST(neyi �evirece�i as neye �evirece�i)
select * from Oyuncu order by adi
-- order by: s�tun ad�na g�re s�ralama, default'u ascending (asc)
select * from Oyuncu order by adi desc
-- descending (desc)
select * from Oyuncu order by adi, soyadi
-- �nce adi s�tununa g�re artan s�ralama yapar, sonra adi s�tununa g�re s�ralad�klar�n� soyadi s�tununa g�re artan s�ralar.
select * from Yonetmen order by adi, soyadi desc
-- �nce adi s�tununa g�re artan s�ralama yapar, sonra adi s�tununa g�re s�ralad�klar�n� soyadi s�tununa g�re azalan s�ralar.
select * from Oyuncu order by 2
-- 2: s�tun ad� (adi)
select * from Oyuncu order by 3 desc
-- 3: s�tun ad� (soyadi)
select COUNT(*) from Oyuncu
select COUNT(adi) as toplamfilm from Film
-- COUNT(s�tun ad�) veya COUNT(*): row say�s�n� verir
select COUNT(dogumtarihi) from Oyuncu
-- COUNT(s�tun ad�): NULL olanlar� saymaz
select MAX(gisesi) as [En Cok Gise] from Film
-- MAX(s�tun ad�): o s�tundaki verilerden en b�y�k de�eri ver
select MIN(gisesi) as [En Az Gise] from Film
-- MIN(s�tun ad�): o s�tundaki verilerden en k���k de�eri ver
select SUM(gisesi) as [Toplam Gise] from Film
-- SUM(s�tun ad�): o s�tundaki verilerin toplam�n� ver
select AVG(gisesi) as [Ortalama Gise] from Film
-- AVG(s�tun ad�): o s�tundaki verilerin ortalama de�erini ver
select top 5 * from Oyuncu
-- TOP say� s�tun ad�: ilk be� kayd� getirir
select top 5 * from Oyuncu order by 1 desc
-- Burda order by desc'den dolay� son 5 kayd� getirir
-- E�er tablo veya s�tun adlar�nda bo�luk varsa [] kullan�lmas� gerek!
select top 1 * from film order by id 
-- film tablosundaki ilk kayd� getirir
select top 1 * from film order by id desc 
-- film tablosundaki son kayd� getirir
use master
select * from Filmler.dbo.Film
-- dbo: schema
use Filmler
select * from Oyuncu where id = 5
select * from Oyuncu where id = '5'
-- id'si 5 olan kay�tlar� getir. ikisi de �al���r, kendi kendine convert yapar (where clause'unun i�inde)
select * from Oyuncu where id != 5
select * from Oyuncu where id <> 5
select * from Oyuncu where not id = 5
-- id'si 5 olmayan kay�tlar� getir
select * from Oyuncu where id < 4 order by id desc 
select * from Oyuncu where id > 4 -- id'ye g�re artan s�ralama i�in order by id yazmaya gerek yoktur ��nk� id primary key ve index oldu�undan otomatikman id'ye g�re artan s�ral� gelir
-- where: �art belirtir
/* Yorum sat�r� 1 
 * Yorum sat�r� 2
 * Yorum sat�r� 3
 * Yorum sat�r� 4
 */
select * from Oyuncu where id >= 2 and id <= 4
select * from Oyuncu where id < 2 or id > 4 -- 1. sorgu
select * from Oyuncu where not (id >= 2 and id <= 4) -- 2. sorgu
-- �stteki iki sorgu ayn� sonucu verir ��nk� 1. sorgu 2. sorgunun de�il operat�r� parantez i�erisindeki ko�ullara da��t�lm�� halidir
/*
Ko�ul 1 		and			Ko�ul 2				Sonu� Ko�ulu		�rnek Tabloda Aranan Veriler	�rnek Tablodan D�nen Sonu� Verileri
id >= 3						id <= 5
1 (true)					1 (true)			1 (true)			3, 4, 5							3, 4, 5
1 (true)					0 (false)			0 (false)			11								Veri d�nmez
0 (false)					1 (true)			0 (false)			2								Veri d�nmez
id > 5						id < 3
0 (false)					0 (false)			0 (false)			4								Veri d�nmez
*/
/*
Ko�ul 1 		or			Ko�ul 2				Sonu� Ko�ulu		�rnek Tabloda Aranan Veriler	�rnek Tablodan D�nen Sonu� Verileri
id >= 3						id <= 5
1 (true)					1 (true)			1 (true)			3, 4, 5							3, 4, 5
1 (true)					0 (false)			1 (true)			11, Di�er veriler				11, Di�er veriler
0 (false)					1 (true)			1 (true)			2, Di�er veriler				2, Di�er veriler
id > 5						id < 3
0 (false)					0 (false)			0 (false)			4								Veri d�nmez
*/
select * from Oyuncu where id < 2 and id > 4
-- veri d�nmez
select * from Oyuncu where adi = 'Sigourney' and soyadi = 'Weaver' and dogumtarihi = '1949-10-08'
select * from Oyuncu where (adi = 'Sigourney' and soyadi = 'Weaver') or adi = 'Zoe'
-- ad� Sigourney ve soyad� Weaver olan veya ad� Zoe olan kay�tlar� getir
select * from Oyuncu where (adi = 'Sigourney' and soyadi = 'Weaver') or (adi = 'Zoe' and soyadi = 'Saldana')
-- ad� Sigourney ve soyad� Weaver olan veya ad� Zoe ve soyad� Saldana olan kay�tlar� getir
select * from Oyuncu where ((adi = 'Sigourney' and soyadi = 'Weaver') or (adi = 'Zoe' and soyadi = 'Saldana')) and dogumtarihi > '1970-01-01'
-- ad� Sigourney ve soyad� Weaver olan veya ad� Zoe ve soyad� Saldana olan ve do�um tarihi 01.01.1970'ten b�y�k olan kay�tlar� getir
-- e�er ko�ullarda hem and hem de or kullan�l�yorsa ilgili ko�ullar mutlaka paranteze al�nmal�d�r
select * from Tur where id = 1 or id = 3 or id = 5
select * from Tur where id in (1, 3, 5)
-- in (de�erler): k�me i�erisinden se�im yapar, de�erleri parantez i�indeki parametreler olanlar� getir
select * from Tur where id not in (1, 3, 5)
--not in (de�erler): k�me d���ndan se�im yapar, de�erleri parantez d���ndaki parametreler olanlar� getir
select * from Tur where id between 2 and 4
select * from Film where yapimyili is NULL
select * from Film where yapimyili is not null
select * from Film where adi = 'Avatar'
select * from Film where adi like 'Avatar'
-- �stteki iki sorgu ayn� sonucu verir ��nk� like i�erisinde % kullan�lmazsa = gibi davran�r
select * from Film where adi like 'a%'
-- a ile ba�layan sonu ne olursa olsun getir
select * from Film where adi like '%ata%'
-- i�inde ata ge�enleri getir, ba�� ve sonu �nemli de�il
select * from Film where adi like '%de'
-- sonu de ile bitenleri getir
select * from Film where adi like 'yar%'
-- yar ile ba�layanlar� getir 
select * from Film where adi not like 'yar%'
-- yar ile ba�lamayanlar� getir
select * from Film where adi like '%t�k'
-- t�k ile bitenleri getir
select * from Film where adi like '%at%'
-- i�inde at ge�enleri getir
select * from Film where adi like '%av%'
-- i�inde av ge�enleri getir, ba��nda veya sonunda ge�se de veri d�ner
select * from Film where adi like '___r%'
-- ilk 3 karakteri ne olursa olsun 4. karakteri r olan ve sonras� ne olursa olsun getir 
-- (sonunda hi�bir �ey de olmayabilir, bir�eyler de)
select * from Oyuncu where adi like '[jr]%' order by adi
-- r veya j ile ba�layan kay�tlar� getir
select * from Oyuncu where adi like '[j-r]%' order by adi
-- ba� harfi j ve r aras�ndaki karakterlerle ba�layanlar� getir
select * from Oyuncu where adi like '[r-j]%' order by adi
-- [] i�indeki karakterler s�ral� olmal� yoksa bo� tablo d�ner
select * from Oyuncu where adi like '[rj]_[^c]%e'
-- r ya da j harfinden biri ile ba�layacak, ikinci harf �nemli de�il, ���nc� c olmayacak 
-- ve arada ne ge�erse ge�sin son harfi e olacak
-- burda karakterleri 1'den saymaya ba�l�yoruz
select '�a��l' + ' ' + 'Alsa�' Ad�Soyad�
select 1 + 2 + 3 as Toplam
-- select her zaman bir tablo ile kullan�lmaz, istenilen veriler yaz�l�p ihtiyaca g�re �zerinde i�lemler yap�larak �ekilebilir
select adi, soyadi, 'Oyuncu' [Tablo Ad�] from oyuncu
-- select ile adi ve soyadi ile birlikte 'Oyuncu' metinsel verisini de tablo ad� olarak getir