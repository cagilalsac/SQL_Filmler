-- VARIABLES (DE���KENLER) --
use Filmler
-- ��eri bittikten sonra yok edilecek sorguya �zel de�i�kenler tan�mlama:
-----------------------------------------------------------------------------------
declare @sayi1 int -- @sayi1 de�i�kenini deklare et.
set @sayi1 = 23 -- @sayi1 de�i�keninin de�erine 23 ata.
select @sayi1 as sayi1 -- Sonucu tablo olarak g�r.
print @sayi1 -- Sonucu mesaj olarak ekrana yazd�r.
-----------------------------------------------------------------------------------
declare @sayi2 int, @isim2 varchar(10)
set @sayi2 = 17
set @isim2 = '�a��l'
select CAST(@sayi2 as varchar(3)) + ' - ' + @isim2 as sayi2isim2
-----------------------------------------------------------------------------------
declare @isim3 varchar(10), @soyisim3 varchar(10)
set @soyisim3 = 'Weaver'
select @isim3 = adi from Oyuncu where soyadi = @soyisim3
select @isim3 as isim3
-----------------------------------------------------------------------------------
declare @id1 int
set @id1 = 1
if @id1 = 1
begin
	select id, adi from Film where id = @id1
end
else
begin
	select id, adi from Film where id > @id1
end 
-----------------------------------------------------------------------------------
declare @id2 int
set @id2 = 2
if @id2 = 1
begin
	select id, adi from Film where id = @id2
end
else
begin
	select id, adi from Film where id >= @id2
end 
-----------------------------------------------------------------------------------
-- Bir kay�t e�er oyuncu tablosunda yoksa eklensin, varsa g�r�nt�lensin.
declare @isim4 varchar(10), @soyisim4 varchar(10)
set @isim4 = 'Sigourney'
set @soyisim4 = 'Weaver'
if exists (select * from Oyuncu where adi = @isim4 and soyadi = @soyisim4)
begin
	select 'Kay�tl� oyuncu!' as uyari
	select * from Oyuncu where adi = @isim4 and soyadi = @soyisim4
end
else
begin
	insert into Oyuncu (adi, soyadi) values (@isim4, @soyisim4)
	select 'Kay�t eklenmi�tir!' as uyari
end
-----------------------------------------------------------------------------------
-- T�m oyuncu isimlerini tek bir tabloda tek bir s�tuna yazd�rma:
declare @id3 int, @isimler3 varchar(300), @geciciisim3 varchar(30)
set @geciciisim3 = ''
set @isimler3 = ''
set @id3 = 1
while @id3 <= (select COUNT(*) from Oyuncu)
begin
	select @geciciisim3 = adi from Oyuncu where id = @id3
	set @isimler3 = @isimler3 + ' ' + @geciciisim3
	set @id3 = @id3 + 1
end
select @isimler3 as tumoyuncuadlari
print @isimler3
-----------------------------------------------------------------------------------
-- Bir String'i tersten yazd�rma:
declare @index1 int, @input1 varchar(50), @output1 varchar(50), @character1 char(1)
set @character1 = ''
set @output1 = ''
set @input1 = '�A�IL'
set @index1 = LEN(@input1)
while @index1 >= 1 
begin
	set @character1 = SUBSTRING(@input1, @index1, 1)
	set @output1 = @output1 + @character1
	set @index1 = @index1 - 1  
end
select @input1 as duzstring, @output1 as tersstring
-----------------------------------------------------------------------------------
-- Karakterlerin ASCII de�erlerini veren fonksiyon:
select CHAR(100) as harf
select ASCII('d') as asciikodu
-----------------------------------------------------------------------------------
-- �ifreleme: Karakterlerin ASCII de�erlerinden 1 ��kar�larak yap�lan �ifreleme.
declare @index2 int, @input2 varchar(10), @output2 varchar(10)
set @input2 = 'USKUMRU'
set @output2 = ''
set @index2 = 1
while @index2 <= LEN(@input2)
begin
	set @output2 = @output2 + CHAR(ASCII(SUBSTRING(@input2, @index2, 1)) - 1)
	set @index2 = @index2 + 1
end
select @input2 as desifrelenmis, @output2 as sifrelenmis
-----------------------------------------------------------------------------------
-- De�ifreleme: Karakterlerin ASCII de�erlerine 1 eklenerek yap�lan de�ifreleme.
declare @index3 int, @input3 varchar(10), @output3 varchar(10)
set @input3 = 'TRJTLQT'
set @output3 = ''
set @index3 = 1
while @index3 <= LEN(@input3)
begin
	set @output3 = @output3 + CHAR(ASCII(SUBSTRING(@input3, @index3, 1)) + 1)
	set @index3 = @index3 + 1
end
select @input3 as sifrelenmis, @output3 as desifrelenmis
-----------------------------------------------------------------------------------
-- CURSORS --
--CREATE TABLE [dbo].[FilmBackup](
--	[id] [int],
--	[adi] [varchar](300) NOT NULL,
--	[yapimyili] [char](4) NULL,
--	[yonetmen_id] [int] NOT NULL,
--	[gisesi] [money] NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--))
declare @id int
declare @adi varchar(300)
declare @yapimyili char(4)
declare @yonetmen_id int
declare @gisesi money
truncate table FilmBackup
declare crs cursor for
select id, adi, yapimyili, yonetmen_id, gisesi from Film
open crs
fetch next from crs into @id, @adi, @yapimyili, @yonetmen_id, @gisesi
while @@FETCH_STATUS = 0
begin
	insert into FilmBackup (id, adi, yapimyili, yonetmen_id, gisesi)
	values (@id, @adi, @yapimyili, @yonetmen_id, @gisesi)   
	fetch next from crs into @id, @adi, @yapimyili, @yonetmen_id, @gisesi
end
close crs
deallocate crs
select * from FilmBackup
-----------------------------------------------------------------------------------
-- �nce y�netmen tablosunda ad� ve soyad� arada bir bo�luk olacak �ekilde 
-- birle�tirilmi� bir de�i�ken de�erli kay�t tabloda var m� diye kontrol edilir.
-- E�er yoksa y�netmen tablosuna bu de�i�ken de�erli kay�t girilir, yoksa girilmez.
-- Daha sonra e�er film tablosunda film ad� de�i�ken de�erine sahip kay�t yoksa 
-- filmin t�m de�i�ken de�erleri i�in yeni film kayd� girilir.
-- E�er film tablosunda film ad� de�i�ken de�erine g�re kay�t varsa filmin 
-- y�netmeni g�ncellenir.
declare @yonetmenid int -- sorgularla olu�acak
declare @yonetmenadisoyadi varchar(101)
declare @yonetmenadi varchar(50)
declare @yonetmensoyadi varchar(50)
declare @filmadi varchar(300) = 'Once Upon a Time in Hollywood'
declare @filmyapimyili char(4)
declare @filmgisesi money
declare @filmsayisi int = 0
set @yonetmenadisoyadi = 'Quentin Tarantino'
set @filmyapimyili = '2019'
set @filmgisesi = 15890600
select @yonetmenid = id from Yonetmen where adi + ' ' + soyadi = @yonetmenadisoyadi
if @yonetmenid is null
begin
	select @yonetmenid = MAX(id) + 1 from Yonetmen -- Yonetmen tablosundaki id s�tunu auto-increment de�il
	set @yonetmenadi = TRIM(SUBSTRING(@yonetmenadisoyadi, 1, CHARINDEX(' ', @yonetmenadisoyadi, 1)))
	set @yonetmensoyadi = LTRIM(RTRIM(SUBSTRING(@yonetmenadisoyadi, CHARINDEX(' ', @yonetmenadisoyadi, 1) + 1, LEN(@yonetmenadisoyadi))))
	insert into Yonetmen values (@yonetmenid, @yonetmenadi, @yonetmensoyadi)
end
select * from Film where adi = @filmadi
if @@ROWCOUNT = 0
begin
	insert into Film (adi, yapimyili, yonetmen_id, gisesi) values (@filmadi, @filmyapimyili, @yonetmenid, @filmgisesi)
end
else
begin
	update Film set yonetmen_id = @yonetmenid where adi = @filmadi
end
-- kontrol i�in:
select * from Film f, Yonetmen y where f.yonetmen_id = y.id order by f.id desc, y.id desc
-- kay�tlar�n eski haline d�nmesi i�in:
delete from Film where id > 7
delete from Yonetmen where id > 5
-----------------------------------------------------------------------------------
-- ��renci - Not �rne�i (1 to 1):
CREATE TABLE [dbo].[Ogrenciler](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[adi] [varchar](50) NOT NULL,
	[soyadi] [varchar](50) NOT NULL,
	[no] [char](2) NOT NULL,
	[giristarihi] [date] NULL,
 CONSTRAINT [PK_Ogrenciler] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Notlar](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[vize1] [float] NULL,
	[vize2] [float] NULL,
	[final] [float] NULL,
	[ogrenciid] [int] NOT NULL,
 CONSTRAINT [PK_Notlar] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Notlar]  WITH CHECK ADD  CONSTRAINT [FK_Notlar_Ogrenciler] FOREIGN KEY([ogrenciid])
REFERENCES [dbo].[Ogrenciler] ([id])
GO
ALTER TABLE [dbo].[Notlar] CHECK CONSTRAINT [FK_Notlar_Ogrenciler]
GO
declare @ogrenciadi varchar(MAX) = '�a��l'
declare @ogrencisoyadi varchar(MAX) = 'Alsa�'
declare @ogrencino char(2)
set @ogrencino = '17'
declare @ogrencigiristarihi datetime
declare @ogrenciid int
set @ogrencigiristarihi = '2020-01-16 11:56:59'
declare @vize1 float = 49.5
declare @vize2 float = 75
declare @final float = 45.5
insert into Ogrenciler (adi, soyadi, [no], giristarihi)
values (@ogrenciadi, @ogrencisoyadi, @ogrencino, CAST(@ogrencigiristarihi as date))
set @ogrenciid = IDENT_CURRENT('Ogrenciler')
insert into Notlar (vize1, vize2, final, ogrenciid) 
values (@vize1, @vize2, @final, @ogrenciid)
select [Ogrenci No], Ogrenci, [Giris Tarihi], [1. Vize],
[2. Vize], Final, Ortalama,
case when Ortalama >= 0 and Ortalama < 20 then 'F'
when Ortalama >= 20 and Ortalama < 40 then 'D'
when Ortalama >= 40 and Ortalama < 60 then 'C'  
when Ortalama >= 60 and Ortalama < 80 then 'B'  
when Ortalama >= 80 and Ortalama <= 100 then 'A'  
end as [Harf Notu]
from (
select o.[no] as [Ogrenci No], o.adi + ' ' + o.soyadi as Ogrenci,
CONVERT(varchar(10), o.giristarihi, 104) as [Giris Tarihi],
n.vize1 as [1. Vize], n.vize2 as [2. Vize], n.final as Final,
ROUND((n.vize1 + n.vize2 + n.final) / 3, 1) as Ortalama from Ogrenciler o
inner join Notlar n on o.id = n.ogrenciid
) Ogrenci