-- CONSTRAINTS --
-- insert veya update i�in k�s�tlamalar (kurallar) getiriyoruz.
use Filmler
go
create table Besteci -- Film tablosu ile 1'e 1 ili�kisi oldu�unu varsay�yoruz.
(
	id int not null,
	adi varchar(50),
	soyadi varchar(50),
	film_id int
)
go
insert into Besteci values (1, 'James', 'Horner', 1)
go
select * from Besteci
--------------------------------------------------------------------------------------------------------
-- DEFAULT CONSTRAINT:
go
alter table Besteci
add constraint df_filmid
default 0 for film_id
go
insert into Besteci (id, adi, soyadi) values (2, 'John', 'Williams')
go
select * from Besteci
--------------------------------------------------------------------------------------------------------
-- CHECK CONSTRAINT:
go
insert into Besteci values (3, '�a��l', 'Alsa�', 99)
go
select * from Film
go
select * from Besteci
go
delete from Besteci where adi = '�a��l' and soyadi = 'Alsa�' and film_id = 99
go
select * from Besteci
go
alter table Besteci
add constraint chk_filmid1
check (film_id <= 7)
go
insert into Besteci values (3, '�a��l', 'Alsa�', 99)
go
select * from Besteci
go
insert into Besteci values (3, 'Hans', 'Zimmer', 2)
go
select * from Besteci
go
alter table Besteci add constraint chk_besteciadi
check (LEN(adi) >= 3)
insert into Besteci (id, adi, soyadi) values (4, '', 'Man�o') -- LEN(adi) = 0 olaca�� i�in hata verecektir!
insert into Besteci (id, adi, soyadi) values (4, 'Bar��', 'Man�o')
--------------------------------------------------------------------------------------------------------
go
alter table Besteci
add constraint chk_adi
check (LEN(adi) > 1)
go
insert into Besteci (id, adi, soyadi) values (4, 'B', 'Tyler')
go
select * from Besteci
go
insert into Besteci (id, adi, soyadi) values (4, 'Brian', 'Tyler')
go
select * from Besteci
--------------------------------------------------------------------------------------------------------
go
alter table Besteci
add constraint chk_filmid2
check (film_id >= 5)
-- film_id'si 5'ten k���k kay�tlar var. bu y�zden bu kay�tlar varken bu constraint'i ekleyemez.
go
alter table Besteci with nocheck
add constraint chk_filmid3
check (film_id >= 5)
-- with nocheck: Daha �nce eklenen kay�tlar� g�zard� et.
--------------------------------------------------------------------------------------------------------
-- PRIMARY KEY CONSTRAINT:
go
alter table Besteci
add constraint pk_id
primary key (id)
-- id s�tunu tablo yarat�l�rken "not null" olarak belirlenmi� olmal�!
--------------------------------------------------------------------------------------------------------
-- FOREIGN KEY CONSTRAINT:
go
alter table Besteci with nocheck -- eski kay�tlar� yoksay (kullanmayabiliriz)
add constraint fk_filmid 
foreign key (film_id) references Film (id)
on delete set null on update cascade
-- on delete cascade: �li�kideki kayd� da siler. Kullanmak tehlikeli.
-- on delete set null: Film tablosundan siler, ili�kide oldu�u Besteci tablosunda film_id de�erine 
-- null de�er atar.
-- on delete set default: Film tablosundan siler, ili�kide oldu�u Besteci tablosunda film_id de�erine 
-- default de�er atar.
-- "on delete" yerine "on update" de yazabiliriz.
-- Ne "on delete" ne de "on update" yazmad���m�z zaman kendi otomatik olarak "no action" tan�ml�yor 
-- ve ili�kili tablolar �zerinde update ve delete i�lemleri yapt�rm�yor.
--------------------------------------------------------------------------------------------------------
-- Bir tabloda bir s�tunu unique yapmak?
go
alter table Besteci
add constraint uq_soyadi
unique (soyadi)
--------------------------------------------------------------------------------------------------------
go
drop table Besteci