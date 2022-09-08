-- SELECT FONKSIYONLARI --
-- select içerisinde kullanýlan fonksiyonlar where ile de kullanýlabilir.
use Filmler
-- Oyuncu adýndan soldan 2, soyadýndan saðdan 4 karakter al ve getir.
-- LEFT: soldan baþla, RIGHT: saðdan baþla.
select LEFT(adi, 2) as adisoldaniki, RIGHT(soyadi, 4) as soyadisagdandort from Oyuncu
-- Oyuncu adýnýn karakterlerini küçült, soyadýnýn karakterlerini büyüt.
-- LOWER: harfleri küçült, UPPER: harfleri büyüt.
select LOWER(adi) as adikucuk, UPPER(soyadi) as soyadibuyuk from Oyuncu
-- Oyuncu adýnýn 2. karakterini getir.
-- SUBSTRING(input parametresi, 
--			 baþlangýç karakteri indexi, 
--			 baþlangýç karakterinden itibaren kaç karakter alacaðý)
select SUBSTRING(adi,2,1) as ikincikarakter from Oyuncu
-- Oyuncu adýný ve soyadýný virgül ile birleþtir, 3. karakter ile (3. karakter dahil) 
-- 7. karakter (7. karakter dahil deðil) arasýný getir.
-- SQL String'lerde saymaya 1'den baþlar yani ilk index 1'dir, 0 deðil.
select SUBSTRING(adi + ',' + soyadi, 3, 4) as ucilealtiarasi from Oyuncu
-- Oyuncu adýný tersten yaz.
select REVERSE(adi) as terstenadi from Oyuncu
-- Oyuncu adýný ve soyadýný virgül ile birleþtir, 3. karakter ile (3. karakter dahil) 
-- 7. karakter (7. karakter dahil deðil) arasýný tersten yazarak getir.
select REVERSE(SUBSTRING(adi + ',' + soyadi, 3, 4)) as terstenucilealtiarasi from Oyuncu
-- LEN: Length.
select adi, LEN(adi) as adikarakteruzunlugu from Oyuncu
-- ROUND: Yuvarla. Parametresi 0 ise virgülden önceki deðere, 
-- 1 ise virgülden sonraki deðere yuvarlama yapar.
select ROUND(1.22, 0)
select ROUND(1.66, 0)
select ROUND(1.22, 1)
select ROUND(1.66, 1)
-- SPACE: Boþluk býrak. Parametresi kadar boþluk býrakýr.
select adi + SPACE(1) + soyadi as adisoyadi from Oyuncu 
select adi + SPACE(20) + soyadi as adisoyadi from Oyuncu
-- Bugünün tarihi ve saati:
select GETDATE() as bugununtarihivesaati
select convert(varchar, getdate(), 104) + ' ' + convert(varchar, getdate(), 24) bugununtarihivesaati -- Türkçe formatýnda bugünün tarihi ve saati
-- Bugünün tarih ve saatine 2 gün eklenmiþ tarih ve saat:
select DATEADD(day, 2, GETDATE()) as ikigunsonrakitarihvesaat
-- Bugünün tarih ve saatine 3 ay eklenmiþ tarih ve saat:
select DATEADD(month, 3, GETDATE()) as ucaysonrakitarihvesaat
-- Bugünün tarih ve saatine 4 yýl eklenmiþ tarih ve saat:
select DATEADD(year, 4, GETDATE()) as dortyilsonrakitarihvesaat
-- Bugünün tarih ve saatine 5 saat eklenmiþ tarih ve saat:
select DATEADD(hour, 5, GETDATE()) as bessaatsonrakitarihvesaat
-- Yýlýn hangi çeyreðindeyiz?
select DATENAME(QUARTER, GETDATE()) as yilinhangiceyregindeyiz
-- Haftanýn hangi günündeyiz?
select DATENAME(WEEKDAY, GETDATE()) as haftaninhangigunundeyiz
-- Yýlýn hangi ayýndayýz?
select DATENAME(MONTH, GETDATE()) as yilinhangiayindayiz
-- Hangi yýldayýz?
select DATENAME(YEAR, GETDATE()) as hangiyildayiz
-- Tarih farklarýný bulma:
set dateformat dmy
-- tarih (dateformat) formatýný belirler. d: gün, m: ay, y: yýl.
select DATEDIFF(DAY, '17.05.1980', GETDATE()) as dogumumdanberikacgungecmis
select DATEDIFF(MONTH, '17.05.1980', GETDATE()) as dogumumdanberikacaygecmis
select DATEDIFF(YEAR, '17.05.1980', GETDATE()) as dogumumdanberikacyilgecmis
select DATEDIFF(HOUR, '17.05.1980', GETDATE()) / ((365 * 24) + 6) as yas -- en doðru hesap
set dateformat ymd
select DATEPART(DAY, '1980-05-17') -- gün: 17
select DATEPART(MONTH, '1980-05-17') -- ay: 5
select DATEPART(YEAR, '1980-05-17') -- yýl: 1980
select DATEPART(HOUR, '1980-05-17 11:58:59') -- saat: 11
select DATEPART(MINUTE, '1980-05-17 11:58:59') -- dakika: 58
select DATEPART(SECOND, '1980-05-17 11:58:59') -- saniye: 59
select DAY(GETDATE()) -- gün
select MONTH(GETDATE()) -- ay
select YEAR(GETDATE()) -- yýl
select TRIM(' ÇAÐIL ALSAÇ ') -- baþtaki ve sondaki tüm boþ karakterleri kaldýr
select LTRIM(RTRIM(' ÇAÐIL ALSAÇ ')) -- önce sondaki sonra baþtaki tüm boþ karakterleri kaldýr
-- ROW_NUMBER()
select * from (
select ROW_NUMBER() over (order by adi) as sira, adi, soyadi from Oyuncu
) tmp
-- where'de fonksiyon kullanýmlarý
select * from Oyuncu where YEAR(dogumtarihi) >= 1970 and DATEPART(MONTH, dogumtarihi) >= 1 and DAY(dogumtarihi) >= 1
select UPPER(adi) adibuyukharf, UPPER(soyadi) soyadibuyukharf, * from Yonetmen where UPPER(adi) = UPPER('james') and UPPER(soyadi) = UPPER('cameron')
set dateformat dmy
select * from oyuncu where dogumtarihi < '01.01.1970'
select * from oyuncu where dogumtarihi < convert(varchar(10), '1970-01-01', 104)
select * from yonetmen where adi + ' ' + soyadi = ' james cameron ' -- baþýnda ve sonunda boþluk olduðundan veri dönmez
select * from yonetmen where adi + ' ' + soyadi = trim(' james cameron ')
select * from yonetmen where adi + ' ' + soyadi = trim('     guy ritchie     ')
select * from yonetmen where adi + ' ' + soyadi = ltrim(rtrim('     guy ritchie     '))