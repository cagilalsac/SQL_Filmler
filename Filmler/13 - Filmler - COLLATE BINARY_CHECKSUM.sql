-- COLLATE --
use Filmler
-- Sorguya �zel case ve accent sensitivity a�ma:
select * from Oyuncu where adi = 'Sigourney'
select * from Oyuncu where adi = 'Sigourney' collate Turkish_CS_AS
-- CS: Case Sensitive, AS: Accent Sensitive, CI: Case Insensitive, AI: Accent Insensitive
-- BINARY_CHECKSUM() --
-- BINARY_CHECKSUM() built-in fonksiyonu parametresini binary format�na �evirir.
-- Bu �ekilde kar��la�t�rma yapmak duruma g�re daha do�ru sonu�lar verebilir.
-- Mesela T�rk�e karakterler kullan�ld��� durumlarda.
select * from Oyuncu where BINARY_CHECKSUM(Soyadi) = BINARY_CHECKSUM('Weaver')