-- SQL: Structured Query Language
-- DATA DEFINITION LANGUAGE --
use master
go
if exists (select name from sys.databases where name = 'Filmler')
	drop database Filmler
go
create database Filmler
go
use Filmler
go
create table Film -- 1 to many tablosu
(
	id int primary key identity(1, 1),
	adi varchar(300) not null,
	yapimyili char(4),
	yonetmen_id int null, -- null: Herhangi bir filmin yönetmeni olmayabilir, not null: Her filmin bir yönetmeni olmalýdýr.
	gisesi money,
	hatalisutun int -- silinecek sütun
)
create table Yonetmen
(
	id int primary key,
	adi varchar(50) not null,
	soyadi varchar(50) not null
)
create table Tur
(
	id int primary key identity(1, 1),
	adi varchar(1) -- düzeltilecek sütun
)
create table Oyuncu
(
	id int primary key identity(1, 1),
	adi varchar(50) not null,
	soyadi varchar(50) not null,
	-- dogumtarihi eklenecek
)
create table Karakter
(
	id int primary key identity(1, 1),
	adisoyadi varchar(100) not null,
)
create table FilmTur -- many to many tablosu
(
	film_id int not null,
	tur_id int not null,
	constraint PK_FilmTur PRIMARY KEY (film_id, tur_id)
)
create table FilmOyuncuKarakter -- many to many tablosu
(
	film_id int not null,
	oyuncu_id int not null,
	karakter_id int not null,
	constraint PK_FilmOyuncuKarakter PRIMARY KEY (film_id, oyuncu_id, karakter_id)
)
create table Hatalitablo -- silinecek tablo
(
	id int primary key
)
create table Filmyedek
(
	id int primary key,
	adi varchar(300) not null,
	yapimyili char(4),
	yonetmen_id int,
	gisesi money	
)
create table Degerlendirme
(
	id int primary key identity(1, 1),
	film_id int not null,
	puani tinyint not null,
	degerlendiren varchar(100) not null
)

drop table Hatalitablo
alter table Oyuncu
	add dogumtarihi date
alter table Tur
	alter column adi varchar(25) not null
alter table Film
	drop column hatalisutun

-- iliþkiler:
alter table Film
	add constraint FK_Film_Yonetmen
	foreign key (yonetmen_id) references Yonetmen(id)
alter table FilmTur
	add constraint FK_FilmTur_Film
	foreign key (film_id) references Film(id)
alter table FilmTur
	add constraint FK_FilmTur_Tur
	foreign key (tur_id) references Tur(id)
alter table FilmOyuncuKarakter
	add constraint FK_FilmOyuncuKarakter_Film
	foreign key (film_id) references Film(id)
alter table FilmOyuncuKarakter
	add constraint FK_FilmOyuncuKarakter_Oyuncu
	foreign key (oyuncu_id) references Oyuncu(id)
alter table FilmOyuncuKarakter
	add constraint FK_FilmOyuncuKarakter_Karakter
	foreign key (karakter_id) references Karakter(id)
alter table Degerlendirme
	add constraint FK_Degerlendirme_Film
	foreign key (film_id) references Film(id)