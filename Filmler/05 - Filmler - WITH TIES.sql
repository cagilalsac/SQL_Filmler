-- WITH TIES --
use Filmler
select top 5 * from Film order by yonetmen_id desc
select top 5 with ties * from Film order by yonetmen_id desc
-- en son sat�r ile ona ili�kili sat�rlar� da getirir. dolay�s�yla 5 yerine 6 sat�r d�ner