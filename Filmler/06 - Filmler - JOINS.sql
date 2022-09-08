-- JOINS --
-- 1) INNER JOIN:
-- e�le�en kay�tlar� getirir (e�le�en kay�tlar kural� �zerinden)
-- iki veya daha fazla tabloyu e�le�en kay�tlar kural� �zerinden tek bir tabloymu� gibi birle�tiriyor
-- burda e�le�en kay�tlar kural�: f.yonetmen_id = y.id
use Filmler
select f.id as filmid, f.adi as filmadi, f.yapimyili as filmyapimyili, f.gisesi as filmgisesi,
y.adi as filmyonetmenadi, y.soyadi as filmyonetmensoyadi
from Film as f inner join Yonetmen as y on f.yonetmen_id = y.id order by f.yapimyili
go
select Yonetmen.adi from Film inner join Yonetmen on Film.yonetmen_id = Yonetmen.id
go
select distinct Yonetmen.adi from Film inner join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- distinct kendisinden sonraki s�tun ad�na g�re tekrarlayan sat�rlar yerine unique sat�rlar getirir
-- (ilk kar��la�t��� unique sat�rlar� getirir, di�er ayn� de�erdeki sat�rlar� getirmez)
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
-- INNER JOIN e�le�me kural�nda null olan kay�tlar� getirmez
-- bir tablo kendisine de INNER JOIN yapabilir
-- Soru: Ad� M ile ba�layan oyuncular�n oynad��� filmler?
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
-- Soru: James Cameron hangi t�rlerdeki filmleri y�netti? 
-- (Sorgudan y�netmen ad�, soyad�, film ad� ve film t�r� d�ns�n)
select y.adi as yonetmenadi, y.soyadi as yonetmensoyadi, f.adi as filmadi, t.adi as filmturu  
from Yonetmen as y inner join Film as f on y.id = f.yonetmen_id
inner join FilmTur as ft on f.id = ft.film_id
inner join Tur as t on ft.tur_id = t.id
where y.adi = 'james' and y.soyadi = 'cameron'
-- Soru: Filmler hakk�ndaki t�m bilgileri getiren tablo?
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
-- INNER JOIN her iki (veya daha fazla) tabloda da en az bir e�le�me olan sat�rlar� d�nd�r�r.
-- E�er soldaki tablonun sa�daki tabloda e�le�mesi yoksa o sat�rlar� d�nd�rmez. 
-- 2) OUTER JOIN:
-- e�le�meyen kay�tlar� da getirir
-- 2.1) LEFT JOIN:
select f.id as filmid, f.adi as filmadi, 
o.id as oyuncuid, o.adi + ' ' + o.soyadi as oyuncuadisoyadi 
from Film as f left outer join FilmOyuncuKarakter as fok on f.id = fok.film_id
left join Oyuncu as o on fok.oyuncu_id = o.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film left join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- Soldaki tabloya g�re sa�daki tablodan de�erleri getir:
-- Filmlere g�re Oyuncular� getir, Filmlere g�re Y�netmenleri getir.
-- LEFT JOIN soldaki tablodan b�t�n sat�rlar� sa�daki tabloda e�le�meleri olmasa da d�nd�r�r.
-- 2.2) RIGHT JOIN:
select f.id as filmid, f.adi as filmadi, 
o.id as oyuncuid, o.adi + ' ' + o.soyadi as oyuncuadisoyadi 
from Film as f right join FilmOyuncuKarakter as fok on f.id = fok.film_id
right outer join Oyuncu as o on fok.oyuncu_id = o.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film right join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- Sa�daki tabloya g�re soldaki tablodan de�erleri getir: 
-- Oyunculara g�re Filmleri getir, Y�netmenlere g�re Filmleri getir.
-- RIGHT JOIN sa�daki tablodan b�t�n sat�rlar� soldaki tabloda e�le�meleri olmasa da d�nd�r�r.
-- 2.3) FULL JOIN:
select f.id as filmid, f.adi as filmadi, 
o.id as oyuncuid, o.adi + ' ' + o.soyadi as oyuncuadisoyadi 
from Film as f full outer join FilmOyuncuKarakter as fok on f.id = fok.film_id
full join Oyuncu as o on fok.oyuncu_id = o.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film full join Yonetmen on Film.yonetmen_id = Yonetmen.id
-- Bu 2 sorguda FULL JOIN, LEFT JOIN gibi �al���yor.
-- FULL JOIN soldaki tablodan b�t�n sat�rlar� d�nd�r�r ve sa�daki tablodan b�t�n sat�rlar� d�nd�r�r.
-- Sa�daki tabloda e�le�mesi olmayan soldaki tablo de�erlerini ve soldaki tabloda e�le�mesi olmayan
-- sa�daki tablo de�erlerini de d�nd�r�r.
-- 2.4) CROSS JOIN:
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film cross join Yonetmen
-- WHERE kullan�lmad���nda CROSS JOIN iki (veya daha fazla) tablonun t�m sat�rlar�na g�re 
-- Cartesian �arp�mlar�'n� d�nd�r�r.
-- 2 tablo i�in: 
-- Sonu� tablosu sat�r say�s� = 1. Tablo sat�r say�s� * 2. Tablo sat�r say�s�
-- Film tablosu sat�r say�s�:
select COUNT(*) from Film
-- 6
-- Yonetmen tablosu sat�r say�s�:
select COUNT(*) from Yonetmen
-- 5
-- Sonu� tablosu sat�r say�s�:
select COUNT(*) from Film cross join Yonetmen
-- 30
-- WHERE kullan�ld���nda CROSS JOIN, INNER JOIN gibi davran�r.
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film cross join Yonetmen
where Film.yonetmen_id = Yonetmen.id
go
select Film.id as filmid, Film.adi as filmadi,
Yonetmen.id as yonetmenid, Yonetmen.adi + ' ' + Yonetmen.soyadi as yonetmenadisoyadi 
from Film inner join Yonetmen
on Film.yonetmen_id = Yonetmen.id