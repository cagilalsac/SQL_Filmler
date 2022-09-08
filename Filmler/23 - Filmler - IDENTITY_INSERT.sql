create table Test2 (
    id int primary key identity(1, 1),
	adi varchar(50)
)
--insert into Test2 (id, adi) values (1, 'Çağıl') -- id identity olduğundan hata verecektir!
set IDENTITY_INSERT Test2 on
insert into Test2 (id, adi) values (1, 'Çağıl')
set IDENTITY_INSERT Test2 off
