-- USER ROLES --
use Filmler
go
exec sp_addlogin 'cagil', '123', 'Filmler' -- exec sp_addlogin Kullan�c�Ad�, �ifre, Veritaban� 
go
-- exec sp_grantdbaccess 'cagil' -- giri� yetkisi veriyoruz 
								 -- �lk kez kullan�c� olu�turuldu�unda �al��t�r�l�r!
go
exec sp_addrolemember 'db_ddladmin', 'cagil' -- db_ddladmin: database data definition language admin
											 -- Bu admin create, alter ve drop i�lemleri yapabilir.
go
grant select on Film to cagil
-- data control language: grant, deny
go
exec sp_droplogin cagil