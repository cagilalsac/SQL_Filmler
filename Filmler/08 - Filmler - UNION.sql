-- UNION --
-- Veri tipleri ayn� olan s�tunlar� birle�tirir. sonucu distinct'leyerek getirir.
use Filmler
select adi as tumadlar, soyadi as tumsoyadlar from Yonetmen
union
select adi as oyuncuadi, soyadi as oyuncusoyadi from Oyuncu

-- UNION ALL --
-- Veri tipleri ayn� olan s�tunlar� birle�tirir. sonucu distinct'lemeden getirir.
select adi as tumadlar, soyadi as tumsoyadlar from Yonetmen
union all
select adi as oyuncuadi, soyadi as oyuncusoyadi from Oyuncu

-- DISTINCT --
select distinct adi from Oyuncu -- �oklayan kay�tlar� teke d���rerek sonu� getirir.
