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
-- Burada begin { end de } �eklinde d���n�lebilir.
use Filmler
if (select adi from Film where id = 1) = 'Avatar'
begin
	select '1 numaral� id''ye sahip film Avatar''d�r.' as idvefilm
	print '1 numaral� id''ye sahip film Avatar''d�r.'
end
if (select id from Film where adi = 'Sherlock Holmes') = 4
begin
	select 'Sherlock Holmes''un id''si 4''t�r.' as filmveid
	print 'Sherlock Holmes''un id''si 4''t�r.'
end
else if (select id from Film where adi = 'Sherlock Holmes') = 5
begin
	select 'Sherlock Holmes''un id''si 5''tir.' as filmveid
	print 'Sherlock Holmes''un id''si 5''tir.'
end
else
begin
	select 'Sherlock Holmes''un id''si 4 veya 5 de�ildir.' as filmveid
	print 'Sherlock Holmes''un id''si 4 veya 5 de�ildir.'
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
		when gisesi > 1000000.00 then '�ok ba�ar�l�'
		when gisesi between 500000.00 and 1000000.00 then 'Ba�ar�l�'
		else 'Ba�ar�s�z'
	end
as gisebasarisi from Film	 
