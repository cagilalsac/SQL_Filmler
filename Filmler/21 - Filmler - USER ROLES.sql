-- USER ROLES --
use Filmler
go
exec sp_addlogin 'cagil', '123', 'Filmler' -- exec sp_addlogin KullanýcýAdý, Þifre, Veritabaný 
go
-- exec sp_grantdbaccess 'cagil' -- giriþ yetkisi veriyoruz 
								 -- Ýlk kez kullanýcý oluþturulduðunda çalýþtýrýlýr!
go
exec sp_addrolemember 'db_ddladmin', 'cagil' -- db_ddladmin: database data definition language admin
											 -- Bu admin create, alter ve drop iþlemleri yapabilir.
go
grant select on Film to cagil
-- data control language: grant, deny
go
exec sp_droplogin cagil