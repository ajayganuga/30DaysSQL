-- Q8 --

drop table if exists job_skills;
create table job_skills
(
	row_id		int,
	job_role	varchar(20),
	skills		varchar(20)
);
insert into job_skills values (1, 'Data Engineer', 'SQL');
insert into job_skills values (2, null, 'Python');
insert into job_skills values (3, null, 'AWS');
insert into job_skills values (4, null, 'Snowflake');
insert into job_skills values (5, null, 'Apache Spark');
insert into job_skills values (6, 'Web Developer', 'Java');
insert into job_skills values (7, null, 'HTML');
insert into job_skills values (8, null, 'CSS');
insert into job_skills values (9, 'Data Scientist', 'Python');
insert into job_skills values (10, null, 'Machine Learning');
insert into job_skills values (11, null, 'Deep Learning');
insert into job_skills values (12, null, 'Tableau');

select * from job_skills;

-- Solution 1 - Using Window function

with cte as 
	(select *
	, sum(case when job_role is null then 0 else 1 end) over(order by row_id) as segment
	from job_skills)
select row_id
, first_value(job_role) over(partition by segment order by row_id) as job_role
, skills
from cte;



-- Solution 2 - WITHOUT Using Window function

with recursive cte as
	(select row_id, job_role, skills 
	 from job_skills where row_id=1
	 union all
	 select e.row_id, case when e.job_role is null then cte.job_role else e.job_role end as job_role
	 , e.skills
	 from job_skills e
	 join cte on e.row_id = cte.row_id + 1
	)
select * from cte;

