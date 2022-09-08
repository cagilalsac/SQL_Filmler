-- GROUP BY --
-- SUM, MIN, MAX, AVG ve COUNT Aggregate Fonksiyonlard�r. Bunlarla ekledi�imiz t�m s�tunlardan
-- ba�ka s�tunlar� group by'da yazmam�z gerekiyor.
select degerlendiren, COUNT(*) puansayisi from Degerlendirme group by degerlendiren
-- de�erlendirenlere g�re puan say�lar�
select degerlendiren, MAX(puani) maksimumpuan from Degerlendirme group by degerlendiren
-- de�erlendirenlere g�re maksimum puanlar
select degerlendiren, MIN(puani) minimumpuan from Degerlendirme group by degerlendiren
-- de�erlendirenlere g�re minimum puanlar
select film_id, MAX(puani) maksimumpuan from Degerlendirme group by film_id
-- filmlere g�re maksimum puanlar
select film_id, MIN(puani) minimumpuan from Degerlendirme group by film_id
-- filmlere g�re minimum puanlar
select film_id, COUNT(*) puansayisi from Degerlendirme group by film_id
-- filmlere g�re puan say�lar�
select film_id, (SUM(puani) / COUNT(*)) ortalamapuan from Degerlendirme group by film_id
-- filmlere g�re puan ortalamalar�
select film_id, AVG(puani) ortalamapuan from Degerlendirme group by film_id
-- filmlere g�re puan ortalamalar�
select film_id, AVG(CAST(puani as float)) ortalamapuan from Degerlendirme group by film_id
-- filmlere g�re puan ortalamalar�: do�ru sonu� i�in cast ile veri d�n��t�rmeye dikkat etmek gerekli!
select f.adi, f.yapimyili, f.gisesi, AVG(CAST(d.puani as float)) ortalamapuan from Film f 
left outer join Degerlendirme d on f.id = d.film_id
group by f.adi, f.yapimyili, f.gisesi
-- filmlere g�re puan ortalamalar�
select f.adi, f.yapimyili, f.gisesi, AVG(CAST(d.puani as float)) ortalamapuan from Film f 
left outer join Degerlendirme d on f.id = d.film_id
group by f.adi, f.yapimyili, f.gisesi
having AVG(CAST(d.puani as float)) > 60
-- filmlere g�re puan ortalamalar� 60'tan b�y�k olanlar
select f.adi, f.yapimyili, f.gisesi, AVG(CAST(d.puani as float)) ortalamapuan, COUNT(*) puansayisi from Film f 
left outer join Degerlendirme d on f.id = d.film_id
group by f.adi, f.yapimyili, f.gisesi
having AVG(CAST(d.puani as float)) > 60 and COUNT(*) > 1
-- filmlere g�re puan ortalamalar� 60'tan b�y�k ve puan say�lar� 1'den b�y�k olanlar

-- Soru: Film adlar� ile oyuncu say�lar�n� getiren sorgu?
use Filmler
select f.adi as filmadi, COUNT(o.id) as oyuncusayisi 
from Film as f inner join FilmOyuncuKarakter as fok on f.id = fok.film_id
inner join Oyuncu as o on fok.oyuncu_id = o.id 
group by f.adi
-- Soru: Hangi oyuncu ka� filmde oynam��?
select Oyuncu.id as oyuncuid, Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
CONVERT(varchar(10), Oyuncu.dogumtarihi, 104) as oyuncudogumtarihi, 
CAST(COUNT(*) as varchar(3)) as oyuncutoplamfilmsayisi
from Oyuncu, FilmOyuncuKarakter, Film
where Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
and FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.id, Oyuncu.adi, Oyuncu.soyadi, Oyuncu.dogumtarihi
order by oyuncutoplamfilmsayisi
-- Soru: Hangi y�netmen hangi filmle ne kadar gi�e has�lat� yapm��?
select y.adi + ' ' + y.soyadi as yonetmen, SUM(f.gisesi) as toplamgise 
from Yonetmen as y inner join Film as f on y.id = f.yonetmen_id
group by y.adi, y.soyadi
-- WITH ROLLUP - WITH CUBE --
-- ROLLUP: Gruplanm�� kolonlar�n hiyerar�isine g�re �zet sat�r olu�turur. 
-- GROUP BY deyiminde kullan�lm�� kolon say�s� kadar gruplama tipi ger�ekle�tirir.
-- GROUP BY deyiminde verilmi� kolonlar� sa�dan sola do�ru gruplar 
-- ve ona g�re her grubun alt�nda �zet sat�r olu�turur.
-- CUBE: De�erlerin t�m kombinasyonlar� i�in ara �zet sat�r� olu�turur.
-- CUBE, ROLLUP gibi �zet sat�r� olu�turur. Tek fark�, GROUP BY deyiminde kullan�lm�� 
-- kolonlar�n de�erlerinin b�t�n kombinasyonlar� kadar group �zeti yapar.
-- NOT: WITH CUBE veya WITH ROLLUP operat�rleri ayn� anda en fazla 10 kolon (k�r�l�m noktas�) 
-- �zerinde �zetleme yapabilir.
-- Soru: Oyuncu ad ve soyadlar�na g�re oynad�klar� filmlerin toplam gi�e has�latlar�?
select Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.adi, Oyuncu.soyadi
order by Oyuncu.adi
-- WITH ROLLUP'l� hali:
select Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.adi, Oyuncu.soyadi with rollup
order by Oyuncu.adi
-- Sat�r 1'de NULL, NULL, 73600000,00 de�erleri d�n�yor.
-- Bunun anlam� WITH ROLLUP bize 73600000,00'� bu de�erin oldu�u sat�r�n alt�ndaki 
-- t�m toplam gise de�erlerini toplay�p veriyor.
-- Sat�r 2'de Carrie, Henn, 10000000,00 de�erleri d�n�yor.
-- Bunun anlam� WITH ROLLUP bize sadece Carrie Henn'in toplam gi�e de�erini veriyor.
-- Sat�r 3'te Carrie, NULL, 10000000,00 de�erleri d�n�yor.
-- Bunun anlam� WITH ROLLUP bize 10000000,00'� t�m Carrie isimlerinin toplam gi�e 
-- de�erlerini toplay�p veriyor.
-- Sat�r 4'te Charles, Dance, 4000000,00 de�erleri d�n�yor.
-- Bunun anlam� WITH ROLLUP bize sadece Charles Dance'in toplam gi�e de�erini veriyor.
-- Sat�r 5'te Charles, Dutton, 4000000,00 de�erleri d�n�yor.
-- Bunun anlam� WITH ROLLUP bize sadece Charles Dutton'un toplam gi�e de�erini veriyor.
-- Sat�r 6'da Charles, NULL, 8000000,00 de�erleri d�n�yor.
-- Bunun anlam� WITH ROLLUP bize 8000000,00'i t�m Charles isimlerinin toplam gi�e 
-- de�erlerini toplay�p veriyor.
-- Di�er sat�rlar da Sat�r 2 ve Sat�r 3'teki �zellikleri g�steriyor.
-- WITH CUBE'lu hali:
select Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.adi, Oyuncu.soyadi with cube
order by Oyuncu.adi
-- �lk 17 sat�r NULL, OyuncuSoyad�, ToplamGi�eDe�eri �eklinde d�n�yor.
-- Bunun amac� oyuncu soyadlar�na g�re de �zet toplam gi�e de�erleri toplam� ��karmak.
-- 18. sat�r WITH ROLLUP'�n d�nd�rd��� 1. sat�rdaki gibi NULL, NULL, ToplamGi�eDe�erleriToplam�
-- �eklinde d�n�yor.
-- 19. sat�rdan itibaren WITH ROLLUP'�n 2. sat�rdan itibaren d�nd�rd��� gibi de�erler d�n�yor.
-- SONU�:
-- WITH ROLLUP ve WITH CUBE GROUP BY'daki s�tun adlar�na g�re �zetlemeler yapar.
-- WITH ROLLUP en sa�daki s�tundan en soldaki s�tuna do�ru �zetlemeler yapar.
-- WITH CUBE ise WITH ROLLUP'tan farkl� olarak GROUP BY'da kullan�lm�� s�tunlardaki de�erlerin 
-- t�m kombinasyonlar� i�in �zetlemeler yapar.
-- Soru: Oyuncu ID, ad ve soyadlar�na g�re ID'si 4 ve daha k���k olan oyuncular�n oynad�klar� 
-- filmlerin toplam gi�e has�latlar�?
-- HAVING --
select Oyuncu.id as oyuncuid, Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.id, Oyuncu.adi, Oyuncu.soyadi having(Oyuncu.id <= 4)
order by Oyuncu.id
-- Oyuncu ID'si 4 ve daha k���k olan oyuncular�n ID, ad ve soyadlar� ile birlikte 
-- oynad�klar� filmlerin toplam gi�eleri
select Oyuncu.id as oyuncuid, Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
where Oyuncu.id <= 4
group by Oyuncu.id, Oyuncu.adi, Oyuncu.soyadi
order by Oyuncu.id
-- having(Oyuncu.id <= 4) : having bir aggregate fonksiyon �zerinden kullan�lmad���nda where Oyuncu.id <= 4 gibi d���n�lebilir.