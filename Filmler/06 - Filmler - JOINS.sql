-- JOINS --
-- 1) INNER JOIN:
-- eþleþen kayýtlarý getirir (eþleþen kayýtlar kuralý üzerinden)
-- iki veya daha fazla tabloyu eþleþen kayýtlar kuralý üzerinden tek bir tabloymuþ gibi birleþtiriyor
-- burda eþleþen kayýtlar kuralý: f.yonetmen_id = y.id
use Filmler
select f.id as filmid, f.adi as filmadi, f.yapimyili as filmyapimyili, f.gisesi as filmgisesi,
y.adi as filmyonetmenadi, y.soyadi as filmyonetmensoyadi
from Film as f inner join Yonetmen as y on f.yonetmen_id = y.id order by f.yapimyili
go
select Yonetmen.adi from Film inner join Yonetmen on Film.yonetmen_id = Yonetmen.id
go
select distinct Yonetmen.adi from Film inner join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- distinct kendisinden sonraki sütun adýna göre tekrarlayan satýrlar yerine unique satýrlar getirir
-- (ilk karþýlaþtýðý unique satýrlarý getirir, diðer ayný deðerdeki satýrlarý getirmez)
select f.id as filmid, f.adi as filmadi, f.yapimyili as filmyapimyili, f.gisesi as filmgisesi,
y.adi + ' ' + y.soyadi as filmyonetmeni, 
o.adi + ' ' + o.soyadi as filmoyuncusu
from Yonetmen as y, Film as f, FilmOyuncuKarakter as fok, Oyuncu as o
where y.id = f.yonetmen_id
and f.id = fok.film_id
and fok.oyuncu_id = o.id
go
select f.id as filmid, f.adi as filmadi, f.yapimyili as filmyapimyili, f.gisesi as filmgisesi,
y.adi + ' ' + y.soyadi as filmyonetmeni, 
o.adi + ' ' + o.soyadi as filmoyuncusu
from Yonetmen as y inner join Film as f on y.id = f.yonetmen_id 
inner join FilmOyuncuKarakter as fok on f.id = fok.film_id 
inner join Oyuncu as o on fok.oyuncu_id = o.id
-- iki komut da INNER JOIN! --
-- INNER JOIN eþleþme kuralýnda null olan kayýtlarý getirmez
-- bir tablo kendisine de INNER JOIN yapabilir
-- Soru: Adý M ile baþlayan oyuncularýn oynadýðý filmler?
select Oyuncu.adi + ' ' + Oyuncu.soyadi as oyuncu, Film.adi as filmadi 
from Film inner join FilmOyuncuKarakter on Film.id = FilmOyuncuKarakter.film_id
inner join Oyuncu on FilmOyuncuKarakter.oyuncu_id = Oyuncu.id
where Oyuncu.adi like 'm%'
go
select Oyuncu.adi + ' ' + Oyuncu.soyadi as oyuncu, Film.adi as filmadi 
from Film, FilmOyuncuKarakter, Oyuncu 
where Film.id = FilmOyuncuKarakter.film_id
and FilmOyuncuKarakter.oyuncu_id = Oyuncu.id
and Oyuncu.adi like 'm%'
-- Soru: James Cameron hangi türlerdeki filmleri yönetti? 
-- (Sorgudan yönetmen adý, soyadý, film adý ve film türü dönsün)
select y.adi as yonetmenadi, y.soyadi as yonetmensoyadi, f.adi as filmadi, t.adi as filmturu  
from Yonetmen as y inner join Film as f on y.id = f.yonetmen_id
inner join FilmTur as ft on f.id = ft.film_id
inner join Tur as t on ft.tur_id = t.id
where y.adi = 'james' and y.soyadi = 'cameron'
-- Soru: Filmler hakkýndaki tüm bilgileri getiren tablo?
select distinct f.id as filmid, f.adi as filmadi, f.yapimyili as filmyapimyili, f.gisesi as filmgisesi,
y.adi + ' ' + y.soyadi as filmyonetmeni,
o.adi + ' ' + o.soyadi as filmoyuncusu, o.dogumtarihi as filmoyuncusudogumtarihi,
k.adisoyadi as filmkarakteri,
t.adi as filmturu
from Film as f inner join Yonetmen as y on f.yonetmen_id = y.id
inner join FilmOyuncuKarakter as fok on fok.film_id = f.id
inner join Oyuncu as o on fok.oyuncu_id = o.id
inner join Karakter as k on fok.karakter_id = k.id
inner join FilmTur as ft on f.id = ft.film_id
inner join Tur as t on ft.tur_id = t.id
-- INNER JOIN her iki (veya daha fazla) tabloda da en az bir eþleþme olan satýrlarý döndürür.
-- Eðer soldaki tablonun saðdaki tabloda eþleþmesi yoksa o satýrlarý döndürmez. 
-- 2) OUTER JOIN:
-- eþleþmeyen kayýtlarý da getirir
-- 2.1) LEFT JOIN:
select f.id as filmid, f.adi as filmadi, 
o.id as oyuncuid, o.adi + ' ' + o.soyadi as oyuncuadisoyadi 
from Film as f left outer join FilmOyuncuKarakter as fok on f.id = fok.film_id
left join Oyuncu as o on fok.oyuncu_id = o.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film left join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- Soldaki tabloya göre saðdaki tablodan deðerleri getir:
-- Filmlere göre Oyuncularý getir, Filmlere göre Yönetmenleri getir.
-- LEFT JOIN soldaki tablodan bütün satýrlarý saðdaki tabloda eþleþmeleri olmasa da döndürür.
-- 2.2) RIGHT JOIN:
select f.id as filmid, f.adi as filmadi, 
o.id as oyuncuid, o.adi + ' ' + o.soyadi as oyuncuadisoyadi 
from Film as f right join FilmOyuncuKarakter as fok on f.id = fok.film_id
right outer join Oyuncu as o on fok.oyuncu_id = o.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film right join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- Saðdaki tabloya göre soldaki tablodan deðerleri getir: 
-- Oyunculara göre Filmleri getir, Yönetmenlere göre Filmleri getir.
-- RIGHT JOIN saðdaki tablodan bütün satýrlarý soldaki tabloda eþleþmeleri olmasa da döndürür.
-- 2.3) FULL JOIN:
select f.id as filmid, f.adi as filmadi, 
o.id as oyuncuid, o.adi + ' ' + o.soyadi as oyuncuadisoyadi 
from Film as f full outer join FilmOyuncuKarakter as fok on f.id = fok.film_id
full join Oyuncu as o on fok.oyuncu_id = o.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film full join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- Bu 2 sorguda FULL JOIN, LEFT JOIN gibi çalýþýyor.
-- FULL JOIN soldaki tablodan bütün satýrlarý döndürür ve saðdaki tablodan bütün satýrlarý döndürür.
-- Saðdaki tabloda eþleþmesi olmayan soldaki tablo deðerlerini ve soldaki tabloda eþleþmesi olmayan
-- saðdaki tablo deðerlerini de döndürür.
-- 2.4) CROSS JOIN:
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film cross join Yonetmen
-- WHERE kullanýlmadýðýnda CROSS JOIN iki (veya daha fazla) tablonun tüm satýrlarýna göre 
-- Cartesian Çarpýmlarý'ný döndürür.
-- 2 tablo için: 
-- Sonuç tablosu satýr sayýsý = 1. Tablo satýr sayýsý * 2. Tablo satýr sayýsý
-- Film tablosu satýr sayýsý:
select COUNT(*) from Film
-- 6
-- Yonetmen tablosu satýr sayýsý:
select COUNT(*) from Yonetmen
-- 5
-- Sonuç tablosu satýr sayýsý:
select COUNT(*) from Film cross join Yonetmen
-- 30
-- WHERE kullanýldýðýnda CROSS JOIN, INNER JOIN gibi davranýr.
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film cross join Yonetmen
where Film.yonetmen_id = Yonetmen.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film inner join Yonetmen
on Film.yonetmen_id = Yonetmen.id