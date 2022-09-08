-- DATA MANIPULATION LANGUAGE --
use Filmler
insert into Yonetmen (id, adi, soyadi) 
	values (1, 'James', 'Cameron') -- 1
insert into Yonetmen
	values (2, 'Guy', 'Ritchie') -- 2
insert into Yonetmen
	values (3, 'F. Gary', 'Gray') -- 3
insert into Yonetmen
	values (4, 'Ridley', 'Scott') -- 4
insert into Yonetmen
	values (5, 'David', 'Fincher') -- 5
insert into Film 
	values ('Hatalý Giriþ', 'Hata', 1, 1000000) -- düzeltilecek -- 1
insert into Film (adi, yonetmen_id, gisesi)
	values ('Sherlock Holmes', 2, 50000) -- 2
insert into Film (adi, yonetmen_id)
	values ('Hatalý Giriþ', 1) -- silinecek -- 3
insert into Film (adi, yapimyili, yonetmen_id, gisesi)
	values ('Adalet Peþinde', '2009', null, 30000) -- düzeltilecek -- 4
insert into Film
	values ('Yaratýk', '1979', 4, 1000000) -- 5
insert into Film
	values ('Yaratýk 2', '1986', 1, 700000) -- 6
insert into Film
	values ('Yaratýk 3', '1992', 5, 400000) -- 7
select @@IDENTITY as ensonfilmid 
-- Giriþ yapýlan ve otomatik deðer arttýrmasý olan en son iþlem yaptýðýmýz tablodaki 
-- en son primary key deðerini getirir.
insert into Filmyedek
	select id, adi, yapimyili, yonetmen_id, gisesi from Film
insert into Tur
	values ('Gerilim') -- 1
insert into Tur
	values ('Bilim Kurgu') -- 2
insert into Tur
	values ('Aksiyon') -- 3
insert into Tur
	values ('Dram') -- 4
insert into Tur
	values ('Gizem') -- 5
insert into Tur
	values ('Suç') -- 6
insert into Tur
	values ('Macera') -- 7
insert into Tur
	values ('Korku') -- 8
insert into Tur
	values ('Uzay') -- 9
select SCOPE_IDENTITY() as ensonturid
insert into Oyuncu (adi, soyadi)
	values ('Sigourney', 'Weaver') -- 1
insert into Oyuncu (adi, soyadi)
	values ('Zoe', 'Saldana') -- 2
insert into Oyuncu (adi, soyadi)
	values ('Michelle', 'Rodriguez') -- 3
insert into Oyuncu (adi, soyadi)
	values ('Sam', 'Worthington') -- 4
insert into Oyuncu (adi, soyadi)
	values ('Robert', 'Downey Jr.') -- 5
insert into Oyuncu (adi, soyadi)
	values ('Jude', 'Law') -- 6
insert into Oyuncu (adi, soyadi)
	values ('Rachel', 'McAdams') -- 7
insert into Oyuncu (adi, soyadi)
	values ('Mark', 'Strong') -- 8
insert into Oyuncu (adi, soyadi)
	values ('Jamie', 'Foxx') -- 9
insert into Oyuncu (adi, soyadi)
	values ('Gerard', 'Butler') -- 10
insert into Oyuncu (adi, soyadi)
	values ('Tom', 'Skerritt') -- 11
insert into Oyuncu (adi, soyadi)
	values ('Veronica', 'Cartwright') -- 12
insert into Oyuncu (adi, soyadi)
	values ('Carrie', 'Henn') -- 13
insert into Oyuncu (adi, soyadi)
	values ('Michael', 'Biehn') -- 14
insert into Oyuncu (adi, soyadi)
	values ('Charles', 'Dutton') -- 15
insert into Oyuncu (adi, soyadi)
	values ('Charles', 'Dance') -- 16
insert into Oyuncu (adi, soyadi)
	values ('Paul', 'McGann') -- 17
select IDENT_CURRENT('Oyuncu') as ensonoyuncuid
select * into Oyuncuyedek from Oyuncu 
-- Oyuncuyedek tablosunu yaratýr ve verileri Oyuncu tablosundan Oyuncuyedek tablosuna insert eder.
insert into Karakter
	values ('Dr. Grace Augustine') -- 1
insert into Karakter
	values ('Neytiri') -- 2
insert into Karakter
	values ('Trudy Chacon') -- 3	
insert into Karakter
	values ('Jake Sully') -- 4
insert into Karakter
	values ('Sherlock Holmes') -- 5
insert into Karakter
	values ('Dr. John Watson') -- 6
insert into Karakter
	values ('Irene Adler') -- 7	
insert into Karakter
	values ('Lord Blackwood') -- 8
insert into Karakter
	values ('Nick Rice') -- 9
insert into Karakter
	values ('Clyde Shelton') -- 10
insert into Karakter
	values ('Lt. Ellen Ripley') -- 11
insert into Karakter
	values ('Captain Dallas') -- 12
insert into Karakter
	values ('Lambert') -- 13
insert into Karakter
	values ('Rebecca Newt Jorden') -- 14
insert into Karakter
	values ('Corporal Dwayne Hicks') -- 15
insert into Karakter
	values ('Dillon') -- 16
insert into Karakter
	values ('Clemens') -- 17
insert into Karakter
	values ('Golic') -- 18
select @@IDENTITY as ensonkarakterid
insert into FilmTur
	values (1, 1)
insert into FilmTur
	values (1, 2)
insert into FilmTur
	values (1, 3)
insert into FilmTur
	values (2, 1)	
insert into FilmTur
	values (2, 4)	
insert into FilmTur
	values (2, 3)	
insert into FilmTur
	values (2, 6)
insert into FilmTur
	values (5, 7)
insert into FilmTur
	values (5, 8)
insert into FilmTur
	values (5, 2)
insert into FilmTur
	values (5, 9)
insert into FilmTur
	values (6, 3)
insert into FilmTur
	values (6, 8)
insert into FilmTur
	values (6, 2)
insert into FilmTur
	values (6, 9)
insert into FilmTur
	values (7, 1)
insert into FilmTur
	values (7, 3)
insert into FilmTur
	values (7, 2)
insert into FilmTur
	values (7, 9)
insert into FilmOyuncuKarakter
	values (1, 1, 1)
insert into FilmOyuncuKarakter
	values (1, 2, 2)
insert into FilmOyuncuKarakter
	values (1, 3, 3)
insert into FilmOyuncuKarakter
	values (1, 4, 4)
insert into FilmOyuncuKarakter
	values (2, 5, 5)
insert into FilmOyuncuKarakter
	values (2, 6, 6)
insert into FilmOyuncuKarakter
	values (2, 7, 7)
insert into FilmOyuncuKarakter
	values (2, 8, 8)
insert into FilmOyuncuKarakter
	values (5, 1, 11)
insert into FilmOyuncuKarakter
	values (5, 11, 12)
insert into FilmOyuncuKarakter
	values (5, 12, 13)
insert into FilmOyuncuKarakter
	values (6, 1, 11)
insert into FilmOyuncuKarakter
	values (6, 13, 14)
insert into FilmOyuncuKarakter
	values (6, 14, 15)
insert into FilmOyuncuKarakter
	values (7, 1, 11)
insert into FilmOyuncuKarakter
	values (7, 15, 16)
insert into FilmOyuncuKarakter
	values (7, 16, 17)
insert into FilmOyuncuKarakter
	values (7, 17, 18)
insert into Degerlendirme (degerlendiren, puani, film_id) values ('Beyazperde', 100, 1)
insert into Degerlendirme (degerlendiren, puani, film_id) values ('Beyazperde', 80, 4)
insert into Degerlendirme (degerlendiren, puani, film_id) values ('Beyazperde', 90, 5)
insert into Degerlendirme (degerlendiren, puani, film_id) values ('Sinemalar', 95, 1)
insert into Degerlendirme (degerlendiren, puani, film_id) values ('Sinemalar', 85, 5)
insert into Degerlendirme (degerlendiren, puani, film_id) values ('IMDB', 60, 2)

update Film set adi = 'Avatar', yapimyili = '2009' where id = 1
update Film set yonetmen_id = 3 where adi = 'Adalet Peþinde'
update Oyuncu set dogumtarihi = '10.08.1949' where id = 1
update Oyuncu set dogumtarihi = '1978-07-12' where id = 3
update Filmyedek set yapimyili = '0000'
update Oyuncuyedek set dogumtarihi = '01.01.1980' where dogumtarihi is NULL
select @@ROWCOUNT as oyuncuyedeksatirsayisi -- En son iþlem yaptýðýmýz tablodaki satýr sayýsýný getirir.

delete from Film where id = 3
delete from Oyuncuyedek where id > 4
delete from Oyuncuyedek
truncate table Filmyedek