-- SELECT FONKSIYONLARI --
-- select i�erisinde kullan�lan fonksiyonlar where ile de kullan�labilir.
use Filmler
-- Oyuncu ad�ndan soldan 2, soyad�ndan sa�dan 4 karakter al ve getir.
-- LEFT: soldan ba�la, RIGHT: sa�dan ba�la.
select LEFT(adi, 2) as adisoldaniki, RIGHT(soyadi, 4) as soyadisagdandort from Oyuncu
-- Oyuncu ad�n�n karakterlerini k���lt, soyad�n�n karakterlerini b�y�t.
-- LOWER: harfleri k���lt, UPPER: harfleri b�y�t.
select LOWER(adi) as adikucuk, UPPER(soyadi) as soyadibuyuk from Oyuncu
-- Oyuncu ad�n�n 2. karakterini getir.
-- SUBSTRING(input parametresi, 
--			 ba�lang�� karakteri indexi, 
--			 ba�lang�� karakterinden itibaren ka� karakter alaca��)
select SUBSTRING(adi,2,1) as ikincikarakter from Oyuncu
-- Oyuncu ad�n� ve soyad�n� virg�l ile birle�tir, 3. karakter ile (3. karakter dahil) 
-- 7. karakter (7. karakter dahil de�il) aras�n� getir.
-- SQL String'lerde saymaya 1'den ba�lar yani ilk index 1'dir, 0 de�il.
select SUBSTRING(adi + ',' + soyadi, 3, 4) as ucilealtiarasi from Oyuncu
-- Oyuncu ad�n� tersten yaz.
select REVERSE(adi) as terstenadi from Oyuncu
-- Oyuncu ad�n� ve soyad�n� virg�l ile birle�tir, 3. karakter ile (3. karakter dahil) 
-- 7. karakter (7. karakter dahil de�il) aras�n� tersten yazarak getir.
select REVERSE(SUBSTRING(adi + ',' + soyadi, 3, 4)) as terstenucilealtiarasi from Oyuncu
-- LEN: Length.
select adi, LEN(adi) as adikarakteruzunlugu from Oyuncu
-- ROUND: Yuvarla. Parametresi 0 ise virg�lden �nceki de�ere, 
-- 1 ise virg�lden sonraki de�ere yuvarlama yapar.
select ROUND(1.22, 0)
select ROUND(1.66, 0)
select ROUND(1.22, 1)
select ROUND(1.66, 1)
-- SPACE: Bo�luk b�rak. Parametresi kadar bo�luk b�rak�r.
select adi + SPACE(1) + soyadi as adisoyadi from Oyuncu 
select adi + SPACE(20) + soyadi as adisoyadi from Oyuncu
-- Bug�n�n tarihi ve saati:
select GETDATE() as bugununtarihivesaati
select convert(varchar, getdate(), 104) + ' ' + convert(varchar, getdate(), 24) bugununtarihivesaati -- T�rk�e format�nda bug�n�n tarihi ve saati
-- Bug�n�n tarih ve saatine 2 g�n eklenmi� tarih ve saat:
select DATEADD(day, 2, GETDATE()) as ikigunsonrakitarihvesaat
-- Bug�n�n tarih ve saatine 3 ay eklenmi� tarih ve saat:
select DATEADD(month, 3, GETDATE()) as ucaysonrakitarihvesaat
-- Bug�n�n tarih ve saatine 4 y�l eklenmi� tarih ve saat:
select DATEADD(year, 4, GETDATE()) as dortyilsonrakitarihvesaat
-- Bug�n�n tarih ve saatine 5 saat eklenmi� tarih ve saat:
select DATEADD(hour, 5, GETDATE()) as bessaatsonrakitarihvesaat
-- Y�l�n hangi �eyre�indeyiz?
select DATENAME(QUARTER, GETDATE()) as yilinhangiceyregindeyiz
-- Haftan�n hangi g�n�ndeyiz?
select DATENAME(WEEKDAY, GETDATE()) as haftaninhangigunundeyiz
-- Y�l�n hangi ay�nday�z?
select DATENAME(MONTH, GETDATE()) as yilinhangiayindayiz
-- Hangi y�lday�z?
select DATENAME(YEAR, GETDATE()) as hangiyildayiz
-- Tarih farklar�n� bulma:
set dateformat dmy
-- tarih (dateformat) format�n� belirler. d: g�n, m: ay, y: y�l.
select DATEDIFF(DAY, '17.05.1980', GETDATE()) as dogumumdanberikacgungecmis
select DATEDIFF(MONTH, '17.05.1980', GETDATE()) as dogumumdanberikacaygecmis
select DATEDIFF(YEAR, '17.05.1980', GETDATE()) as dogumumdanberikacyilgecmis
select DATEDIFF(HOUR, '17.05.1980', GETDATE()) / ((365 * 24) + 6) as yas -- en do�ru hesap
set dateformat ymd
select DATEPART(DAY, '1980-05-17') -- g�n: 17
select DATEPART(MONTH, '1980-05-17') -- ay: 5
select DATEPART(YEAR, '1980-05-17') -- y�l: 1980
select DATEPART(HOUR, '1980-05-17 11:58:59') -- saat: 11
select DATEPART(MINUTE, '1980-05-17 11:58:59') -- dakika: 58
select DATEPART(SECOND, '1980-05-17 11:58:59') -- saniye: 59
select DAY(GETDATE()) -- g�n
select MONTH(GETDATE()) -- ay
select YEAR(GETDATE()) -- y�l
select TRIM(' �A�IL ALSA� ') -- ba�taki ve sondaki t�m bo� karakterleri kald�r
select LTRIM(RTRIM(' �A�IL ALSA� ')) -- �nce sondaki sonra ba�taki t�m bo� karakterleri kald�r
-- ROW_NUMBER()
select * from (
select ROW_NUMBER() over (order by adi) as sira, adi, soyadi from Oyuncu
) tmp
-- where'de fonksiyon kullan�mlar�
select * from Oyuncu where YEAR(dogumtarihi) >= 1970 and DATEPART(MONTH, dogumtarihi) >= 1 and DAY(dogumtarihi) >= 1
select UPPER(adi) adibuyukharf, UPPER(soyadi) soyadibuyukharf, * from Yonetmen where UPPER(adi) = UPPER('james') and UPPER(soyadi) = UPPER('cameron')
set dateformat dmy
select * from oyuncu where dogumtarihi < '01.01.1970'
select * from oyuncu where dogumtarihi < convert(varchar(10), '1970-01-01', 104)
select * from yonetmen where adi + ' ' + soyadi = ' james cameron ' -- ba��nda ve sonunda bo�luk oldu�undan veri d�nmez
select * from yonetmen where adi + ' ' + soyadi = trim(' james cameron ')
select * from yonetmen where adi + ' ' + soyadi = trim('     guy ritchie     ')
select * from yonetmen where adi + ' ' + soyadi = ltrim(rtrim('     guy ritchie     '))