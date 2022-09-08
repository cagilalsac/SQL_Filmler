-- IF-ELSE --
--if condition
--begin
--	statements
--end
--------------------
--if condition1
--begin
--	statements1
--end
--else if condition2
--begin
--	statements2
--end
--else
--begin
--	statements3
--end
-- Burada begin { end de } þeklinde düþünülebilir.
use Filmler
if (select adi from Film where id = 1) = 'Avatar'
begin
	select '1 numaralý id''ye sahip film Avatar''dýr.' as idvefilm
	print '1 numaralý id''ye sahip film Avatar''dýr.'
end
if (select id from Film where adi = 'Sherlock Holmes') = 4
begin
	select 'Sherlock Holmes''un id''si 4''tür.' as filmveid
	print 'Sherlock Holmes''un id''si 4''tür.'
end
else if (select id from Film where adi = 'Sherlock Holmes') = 5
begin
	select 'Sherlock Holmes''un id''si 5''tir.' as filmveid
	print 'Sherlock Holmes''un id''si 5''tir.'
end
else
begin
	select 'Sherlock Holmes''un id''si 4 veya 5 deðildir.' as filmveid
	print 'Sherlock Holmes''un id''si 4 veya 5 deðildir.'
end
-- SWITCH --
--select
--	case
--		when condition1 then statement1
--		when condition2 then statement2
--		.
--		.
--		.
--		else statement3
--	end
--from Tablo
select adi, gisesi, 
	case
		when gisesi > 1000000.00 then 'Çok baþarýlý'
		when gisesi between 500000.00 and 1000000.00 then 'Baþarýlý'
		else 'Baþarýsýz'
	end
as gisebasarisi from Film	 
