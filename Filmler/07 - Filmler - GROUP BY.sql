-- GROUP BY --
-- SUM, MIN, MAX, AVG ve COUNT Aggregate Fonksiyonlardýr. Bunlarla eklediðimiz tüm sütunlardan
-- baþka sütunlarý group by'da yazmamýz gerekiyor.
select degerlendiren, COUNT(*) puansayisi from Degerlendirme group by degerlendiren
-- deðerlendirenlere göre puan sayýlarý
select degerlendiren, MAX(puani) maksimumpuan from Degerlendirme group by degerlendiren
-- deðerlendirenlere göre maksimum puanlar
select degerlendiren, MIN(puani) minimumpuan from Degerlendirme group by degerlendiren
-- deðerlendirenlere göre minimum puanlar
select film_id, MAX(puani) maksimumpuan from Degerlendirme group by film_id
-- filmlere göre maksimum puanlar
select film_id, MIN(puani) minimumpuan from Degerlendirme group by film_id
-- filmlere göre minimum puanlar
select film_id, COUNT(*) puansayisi from Degerlendirme group by film_id
-- filmlere göre puan sayýlarý
select film_id, (SUM(puani) / COUNT(*)) ortalamapuan from Degerlendirme group by film_id
-- filmlere göre puan ortalamalarý
select film_id, AVG(puani) ortalamapuan from Degerlendirme group by film_id
-- filmlere göre puan ortalamalarý
select film_id, AVG(CAST(puani as float)) ortalamapuan from Degerlendirme group by film_id
-- filmlere göre puan ortalamalarý: doðru sonuç için cast ile veri dönüþtürmeye dikkat etmek gerekli!
select f.adi, f.yapimyili, f.gisesi, AVG(CAST(d.puani as float)) ortalamapuan from Film f 
left outer join Degerlendirme d on f.id = d.film_id
group by f.adi, f.yapimyili, f.gisesi
-- filmlere göre puan ortalamalarý
select f.adi, f.yapimyili, f.gisesi, AVG(CAST(d.puani as float)) ortalamapuan from Film f 
left outer join Degerlendirme d on f.id = d.film_id
group by f.adi, f.yapimyili, f.gisesi
having AVG(CAST(d.puani as float)) > 60
-- filmlere göre puan ortalamalarý 60'tan büyük olanlar
select f.adi, f.yapimyili, f.gisesi, AVG(CAST(d.puani as float)) ortalamapuan, COUNT(*) puansayisi from Film f 
left outer join Degerlendirme d on f.id = d.film_id
group by f.adi, f.yapimyili, f.gisesi
having AVG(CAST(d.puani as float)) > 60 and COUNT(*) > 1
-- filmlere göre puan ortalamalarý 60'tan büyük ve puan sayýlarý 1'den büyük olanlar

-- Soru: Film adlarý ile oyuncu sayýlarýný getiren sorgu?
use Filmler
select f.adi as filmadi, COUNT(o.id) as oyuncusayisi 
from Film as f inner join FilmOyuncuKarakter as fok on f.id = fok.film_id
inner join Oyuncu as o on fok.oyuncu_id = o.id 
group by f.adi
-- Soru: Hangi oyuncu kaç filmde oynamýþ?
select Oyuncu.id as oyuncuid, Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
CONVERT(varchar(10), Oyuncu.dogumtarihi, 104) as oyuncudogumtarihi, 
CAST(COUNT(*) as varchar(3)) as oyuncutoplamfilmsayisi
from Oyuncu, FilmOyuncuKarakter, Film
where Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
and FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.id, Oyuncu.adi, Oyuncu.soyadi, Oyuncu.dogumtarihi
order by oyuncutoplamfilmsayisi
-- Soru: Hangi yönetmen hangi filmle ne kadar giþe hasýlatý yapmýþ?
select y.adi + ' ' + y.soyadi as yonetmen, SUM(f.gisesi) as toplamgise 
from Yonetmen as y inner join Film as f on y.id = f.yonetmen_id
group by y.adi, y.soyadi
-- WITH ROLLUP - WITH CUBE --
-- ROLLUP: Gruplanmýþ kolonlarýn hiyerarþisine göre özet satýr oluþturur. 
-- GROUP BY deyiminde kullanýlmýþ kolon sayýsý kadar gruplama tipi gerçekleþtirir.
-- GROUP BY deyiminde verilmiþ kolonlarý saðdan sola doðru gruplar 
-- ve ona göre her grubun altýnda özet satýr oluþturur.
-- CUBE: Deðerlerin tüm kombinasyonlarý için ara özet satýrý oluþturur.
-- CUBE, ROLLUP gibi özet satýrý oluþturur. Tek farký, GROUP BY deyiminde kullanýlmýþ 
-- kolonlarýn deðerlerinin bütün kombinasyonlarý kadar group özeti yapar.
-- NOT: WITH CUBE veya WITH ROLLUP operatörleri ayný anda en fazla 10 kolon (kýrýlým noktasý) 
-- üzerinde özetleme yapabilir.
-- Soru: Oyuncu ad ve soyadlarýna göre oynadýklarý filmlerin toplam giþe hasýlatlarý?
select Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.adi, Oyuncu.soyadi
order by Oyuncu.adi
-- WITH ROLLUP'lý hali:
select Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.adi, Oyuncu.soyadi with rollup
order by Oyuncu.adi
-- Satýr 1'de NULL, NULL, 73600000,00 deðerleri dönüyor.
-- Bunun anlamý WITH ROLLUP bize 73600000,00'ý bu deðerin olduðu satýrýn altýndaki 
-- tüm toplam gise deðerlerini toplayýp veriyor.
-- Satýr 2'de Carrie, Henn, 10000000,00 deðerleri dönüyor.
-- Bunun anlamý WITH ROLLUP bize sadece Carrie Henn'in toplam giþe deðerini veriyor.
-- Satýr 3'te Carrie, NULL, 10000000,00 deðerleri dönüyor.
-- Bunun anlamý WITH ROLLUP bize 10000000,00'ý tüm Carrie isimlerinin toplam giþe 
-- deðerlerini toplayýp veriyor.
-- Satýr 4'te Charles, Dance, 4000000,00 deðerleri dönüyor.
-- Bunun anlamý WITH ROLLUP bize sadece Charles Dance'in toplam giþe deðerini veriyor.
-- Satýr 5'te Charles, Dutton, 4000000,00 deðerleri dönüyor.
-- Bunun anlamý WITH ROLLUP bize sadece Charles Dutton'un toplam giþe deðerini veriyor.
-- Satýr 6'da Charles, NULL, 8000000,00 deðerleri dönüyor.
-- Bunun anlamý WITH ROLLUP bize 8000000,00'i tüm Charles isimlerinin toplam giþe 
-- deðerlerini toplayýp veriyor.
-- Diðer satýrlar da Satýr 2 ve Satýr 3'teki özellikleri gösteriyor.
-- WITH CUBE'lu hali:
select Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.adi, Oyuncu.soyadi with cube
order by Oyuncu.adi
-- Ýlk 17 satýr NULL, OyuncuSoyadý, ToplamGiþeDeðeri þeklinde dönüyor.
-- Bunun amacý oyuncu soyadlarýna göre de özet toplam giþe deðerleri toplamý çýkarmak.
-- 18. satýr WITH ROLLUP'ýn döndürdüðü 1. satýrdaki gibi NULL, NULL, ToplamGiþeDeðerleriToplamý
-- þeklinde dönüyor.
-- 19. satýrdan itibaren WITH ROLLUP'ýn 2. satýrdan itibaren döndürdüðü gibi deðerler dönüyor.
-- SONUÇ:
-- WITH ROLLUP ve WITH CUBE GROUP BY'daki sütun adlarýna göre özetlemeler yapar.
-- WITH ROLLUP en saðdaki sütundan en soldaki sütuna doðru özetlemeler yapar.
-- WITH CUBE ise WITH ROLLUP'tan farklý olarak GROUP BY'da kullanýlmýþ sütunlardaki deðerlerin 
-- tüm kombinasyonlarý için özetlemeler yapar.
-- Soru: Oyuncu ID, ad ve soyadlarýna göre ID'si 4 ve daha küçük olan oyuncularýn oynadýklarý 
-- filmlerin toplam giþe hasýlatlarý?
-- HAVING --
select Oyuncu.id as oyuncuid, Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
group by Oyuncu.id, Oyuncu.adi, Oyuncu.soyadi having(Oyuncu.id <= 4)
order by Oyuncu.id
-- Oyuncu ID'si 4 ve daha küçük olan oyuncularýn ID, ad ve soyadlarý ile birlikte 
-- oynadýklarý filmlerin toplam giþeleri
select Oyuncu.id as oyuncuid, Oyuncu.adi as oyuncuadi, Oyuncu.soyadi as oyuncusoyadi, 
SUM(Film.gisesi) as oynadigifilmlertoplamgisesi 
from Oyuncu inner join FilmOyuncuKarakter on Oyuncu.id = FilmOyuncuKarakter.oyuncu_id
inner join Film on FilmOyuncuKarakter.film_id = Film.id
where Oyuncu.id <= 4
group by Oyuncu.id, Oyuncu.adi, Oyuncu.soyadi
order by Oyuncu.id
-- having(Oyuncu.id <= 4) : having bir aggregate fonksiyon üzerinden kullanýlmadýðýnda where Oyuncu.id <= 4 gibi düþünülebilir.