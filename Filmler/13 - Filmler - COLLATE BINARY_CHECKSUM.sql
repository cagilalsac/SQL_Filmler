-- COLLATE --
use Filmler
-- Sorguya özel case ve accent sensitivity açma:
select * from Oyuncu where adi = 'Sigourney'
select * from Oyuncu where adi = 'Sigourney' collate Turkish_CS_AS
-- CS: Case Sensitive, AS: Accent Sensitive, CI: Case Insensitive, AI: Accent Insensitive
-- BINARY_CHECKSUM() --
-- BINARY_CHECKSUM() built-in fonksiyonu parametresini binary formatýna çevirir.
-- Bu þekilde karþýlaþtýrma yapmak duruma göre daha doðru sonuçlar verebilir.
-- Mesela Türkçe karakterler kullanýldýðý durumlarda.
select * from Oyuncu where BINARY_CHECKSUM(Soyadi) = BINARY_CHECKSUM('Weaver')