-- WITH TIES --
use Filmler
select top 5 * from Film order by yonetmen_id desc
select top 5 with ties * from Film order by yonetmen_id desc
-- en son satýr ile ona iliþkili satýrlarý da getirir. dolayýsýyla 5 yerine 6 satýr döner