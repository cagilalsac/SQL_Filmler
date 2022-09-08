-- SUBQUERIES --
-- subquery'ler parantez i�erisinde yaz�l�r
-- where k�sm�nda e�er subquery sonucunda 1 sonu� d�n�yorsa =, birden �ok sonu� d�n�yorsa in kullan�lmal�d�r
-- maksimum gi�e yapan filmlerin y�netmenlerini getir
use Filmler
select * from film
select max(gisesi) from film
select * from film where gisesi = 1000000.00
select * from film where gisesi = (select max(gisesi) from film) -- = kullan�yoruz ��nk� mutlaka tek sonu� d�ner
select * from yonetmen where id = 1 or id = 4
select * from yonetmen where id in (1, 4)
select yonetmen_id from film where gisesi = (select max(gisesi) from film)
select * from yonetmen where id in (select yonetmen_id from film where gisesi = (select max(gisesi) from film)) -- sonu� sorgusu: in kullan�yoruz ��nk� farkl� y�netmenlerin ayn� maksimum gi�eye sahip filmleri olabilir



-- y�netmen adlar� ile birlikte filmleri getir
select * from film
select * from yonetmen
select id, adi, yapimyili, gisesi from film
select id, adi, yapimyili, gisesi, (select adi + ' ' + soyadi from yonetmen where yonetmen.id = film.yonetmen_id) yonetmeni from film -- sonu� sorgusu



select Oyuncu.adi + ' ' + Oyuncu.soyadi as oyuncu from Oyuncu
where Oyuncu.id = 
(
	select top 1 FilmOyuncuKarakter.oyuncu_id from FilmOyuncuKarakter
	where FilmOyuncuKarakter.film_id = 
	(
		select Film.id from Film 
		where Film.gisesi = 
		(
			select MAX(Film.gisesi) from Film
		)
	)
)
-- En �ok gi�e yapan filmin oyuncular�ndan ilk s�radakini getir.
-- Burda subquery'lerden birinden birden �ok de�er d�n�yor. Bu sorunu ya top 1 diyip
-- ilk s�radaki oyuncu id'sini alarak ��zebiliriz veya where clause'undaki ='ler yerine
-- in kullanabiliriz.



select Oyuncu.adi + ' ' + Oyuncu.soyadi as oyuncu from Oyuncu
where Oyuncu.id in 
(
	select FilmOyuncuKarakter.oyuncu_id from FilmOyuncuKarakter
	where FilmOyuncuKarakter.film_id in 
	(
		select Film.id from Film 
		where Film.gisesi = 
		(
			select MAX(Film.gisesi) from Film
		)
	)
)
-- En �ok gi�e yapan filmin t�m oyuncular�n� getir.
-- E�er bir tabloda iki primary key varsa, bu primary key'lerin oldu�u iki s�tunu tek bir
-- s�tunmu� gibi d���nebiliriz. Yani bu tabloda primary key olan ilk s�tun ile beraber 
-- primary key olan ikinci s�tunda ayn� verilere sahip hi�bir sat�r yoktur.
-- E�er birden �ok sat�r i�eren bir tablo d�n�yorsa subquery'de, 
-- in kullanarak sorunu ortadan kald�rabiliyoruz. Tek sat�r d�nece�inden emin olmad���m�z 
-- t�m subquery'lerde in kullanmak mant�kl� ve do�ru.



select f.id as filmid, f.adi as filmadi, 
(
	select y.adi + ' ' + y.soyadi from Yonetmen as y where f.yonetmen_id = y.id
) as filmyonetmeni from Film as f
-- Her bir sat�rda filmin id'sini, filmin ad�n� ve o filme ait y�netmeni getirir.
select f.id as filmid, f.adi as filmadi, f.yapimyili as filmyapimyili, f.gisesi as filmgisesi, 
(
	select y.adi from Yonetmen as y where f.yonetmen_id = y.id
) as filmyonetmenadi, 
(
	select y.soyadi from Yonetmen as y where f.yonetmen_id = y.id
) as filmyonetmensoyadi
from Film as f
-- Her bir sat�rda filmin id'sini, filmin ad�n�, filmin yap�m y�l�n�, filmin gi�esini, 
-- filmin y�netmen ad�n� ve filmin y�netmen soyad�n� getirir.



select o.soyadi + ', ' + o.adi as oyuncu from Oyuncu as o
where o.id in 
(
	select fok.oyuncu_id from FilmOyuncuKarakter as fok
	where fok.film_id =
	(
		select f.id from Film as f
		where f.adi = 'Avatar'
	)
)
-- Avatar filminin oyuncular�n� getir.
-- as ile alias tan�mlama i�lemi tablolar i�in de yap�labilir,
-- alias tan�mland�ktan sonra o tabloya alias'� �zerinden de ula��labilir.