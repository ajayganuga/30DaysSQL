-- Q14 --

drop table if exists invoice;
create table invoice
(
	serial_no		int,
	invoice_date	date
);
insert into invoice values (330115, to_date('01-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330120, to_date('01-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330121, to_date('01-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330122, to_date('02-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330125, to_date('02-Mar-2024','DD-MON-YYYY'));

select * from invoice;



-- Solution 1:

select generate_series(min(serial_no), max(serial_no)) AS missing_serial_no
from invoice
except 
select serial_no from invoice
order by 1;


-- Solution 2:

with recursive cte as
	(select min(serial_no) as n from invoice 
	union
	select n+1 as n
	from cte 
	where n < (select max(serial_no) from invoice)
	 )
select n as missing_serial_no from cte	 
except 
select serial_no from invoice
order by 1;


-- Solution in MSSQL Server:

with cte_data as
	(select min(serial_no) as min_serial_no, max(serial_no) as max_serial_no from invoice),
    cte as 
    (select min_serial_no as n from cte_data 
	union all
	select n+1 as n
	from cte 
	where n < (select max_serial_no from cte_data)
	 )
select n as missing_serial_no from cte	 
except 
select serial_no from invoice
order by 1;

