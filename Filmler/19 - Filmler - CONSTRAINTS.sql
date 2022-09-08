-- CONSTRAINTS --
-- insert veya update için kýsýtlamalar (kurallar) getiriyoruz.
use Filmler
go
create table Besteci -- Film tablosu ile 1'e 1 iliþkisi olduðunu varsayýyoruz.
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
insert into Besteci values (3, 'Çaðýl', 'Alsaç', 99)
go
select * from Film
go
select * from Besteci
go
delete from Besteci where adi = 'Çaðýl' and soyadi = 'Alsaç' and film_id = 99
go
select * from Besteci
go
alter table Besteci
add constraint chk_filmid1
check (film_id <= 7)
go
insert into Besteci values (3, 'Çaðýl', 'Alsaç', 99)
go
select * from Besteci
go
insert into Besteci values (3, 'Hans', 'Zimmer', 2)
go
select * from Besteci
go
alter table Besteci add constraint chk_besteciadi
check (LEN(adi) >= 3)
insert into Besteci (id, adi, soyadi) values (4, '', 'Manço') -- LEN(adi) = 0 olacaðý için hata verecektir!
insert into Besteci (id, adi, soyadi) values (4, 'Barýþ', 'Manço')
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
-- film_id'si 5'ten küçük kayýtlar var. bu yüzden bu kayýtlar varken bu constraint'i ekleyemez.
go
alter table Besteci with nocheck
add constraint chk_filmid3
check (film_id >= 5)
-- with nocheck: Daha önce eklenen kayýtlarý gözardý et.
--------------------------------------------------------------------------------------------------------
-- PRIMARY KEY CONSTRAINT:
go
alter table Besteci
add constraint pk_id
primary key (id)
-- id sütunu tablo yaratýlýrken "not null" olarak belirlenmiþ olmalý!
--------------------------------------------------------------------------------------------------------
-- FOREIGN KEY CONSTRAINT:
go
alter table Besteci with nocheck -- eski kayýtlarý yoksay (kullanmayabiliriz)
add constraint fk_filmid 
foreign key (film_id) references Film (id)
on delete set null on update cascade
-- on delete cascade: Ýliþkideki kaydý da siler. Kullanmak tehlikeli.
-- on delete set null: Film tablosundan siler, iliþkide olduðu Besteci tablosunda film_id deðerine 
-- null deðer atar.
-- on delete set default: Film tablosundan siler, iliþkide olduðu Besteci tablosunda film_id deðerine 
-- default deðer atar.
-- "on delete" yerine "on update" de yazabiliriz.
-- Ne "on delete" ne de "on update" yazmadýðýmýz zaman kendi otomatik olarak "no action" tanýmlýyor 
-- ve iliþkili tablolar üzerinde update ve delete iþlemleri yaptýrmýyor.
--------------------------------------------------------------------------------------------------------
-- Bir tabloda bir sütunu unique yapmak?
go
alter table Besteci
add constraint uq_soyadi
unique (soyadi)
--------------------------------------------------------------------------------------------------------
go
drop table Besteci