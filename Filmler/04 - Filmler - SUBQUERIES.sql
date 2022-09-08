-- SUBQUERIES --
-- subquery'ler parantez içerisinde yazýlýr
-- where kýsmýnda eðer subquery sonucunda 1 sonuç dönüyorsa =, birden çok sonuç dönüyorsa in kullanýlmalýdýr
-- maksimum giþe yapan filmlerin yönetmenlerini getir
use Filmler
select * from film
select max(gisesi) from film
select * from film where gisesi = 1000000.00
select * from film where gisesi = (select max(gisesi) from film) -- = kullanýyoruz çünkü mutlaka tek sonuç döner
select * from yonetmen where id = 1 or id = 4
select * from yonetmen where id in (1, 4)
select yonetmen_id from film where gisesi = (select max(gisesi) from film)
select * from yonetmen where id in (select yonetmen_id from film where gisesi = (select max(gisesi) from film)) -- sonuç sorgusu: in kullanýyoruz çünkü farklý yönetmenlerin ayný maksimum giþeye sahip filmleri olabilir



-- yönetmen adlarý ile birlikte filmleri getir
select * from film
select * from yonetmen
select id, adi, yapimyili, gisesi from film
select id, adi, yapimyili, gisesi, (select adi + ' ' + soyadi from yonetmen where yonetmen.id = film.yonetmen_id) yonetmeni from film -- sonuç sorgusu



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
-- En çok giþe yapan filmin oyuncularýndan ilk sýradakini getir.
-- Burda subquery'lerden birinden birden çok deðer dönüyor. Bu sorunu ya top 1 diyip
-- ilk sýradaki oyuncu id'sini alarak çözebiliriz veya where clause'undaki ='ler yerine
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
-- En çok giþe yapan filmin tüm oyuncularýný getir.
-- Eðer bir tabloda iki primary key varsa, bu primary key'lerin olduðu iki sütunu tek bir
-- sütunmuþ gibi düþünebiliriz. Yani bu tabloda primary key olan ilk sütun ile beraber 
-- primary key olan ikinci sütunda ayný verilere sahip hiçbir satýr yoktur.
-- Eðer birden çok satýr içeren bir tablo dönüyorsa subquery'de, 
-- in kullanarak sorunu ortadan kaldýrabiliyoruz. Tek satýr döneceðinden emin olmadýðýmýz 
-- tüm subquery'lerde in kullanmak mantýklý ve doðru.



select f.id as filmid, f.adi as filmadi, 
(
	select y.adi + ' ' + y.soyadi from Yonetmen as y where f.yonetmen_id = y.id
) as filmyonetmeni from Film as f
-- Her bir satýrda filmin id'sini, filmin adýný ve o filme ait yönetmeni getirir.
select f.id as filmid, f.adi as filmadi, f.yapimyili as filmyapimyili, f.gisesi as filmgisesi, 
(
	select y.adi from Yonetmen as y where f.yonetmen_id = y.id
) as filmyonetmenadi, 
(
	select y.soyadi from Yonetmen as y where f.yonetmen_id = y.id
) as filmyonetmensoyadi
from Film as f
-- Her bir satýrda filmin id'sini, filmin adýný, filmin yapým yýlýný, filmin giþesini, 
-- filmin yönetmen adýný ve filmin yönetmen soyadýný getirir.



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
-- Avatar filminin oyuncularýný getir.
-- as ile alias tanýmlama iþlemi tablolar için de yapýlabilir,
-- alias tanýmlandýktan sonra o tabloya alias'ý üzerinden de ulaþýlabilir.