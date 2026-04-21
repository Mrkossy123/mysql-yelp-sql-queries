-- 3a

create database yelp;
use yelp;

create table business
( id varchar(22) not null,
  name varchar(255),
  neighborhood varchar(255),
  address varchar(255),
  city varchar(255),
  state varchar(255),
  postal_code varchar(255),
  latitude float,
  longitude float,
  stars float,
  review_count int,
  is_open tinyint,
  primary key(id)
) engine=innodb;

create table user
( id varchar(22) not null,
  name varchar(255),
  review_count int,
  yelping_since datetime,
  useful int,
  funny int,
  cool int,
  fans int,
  average_stars float,
  compliment_hot int,
  compliment_more int,
  compliment_profile int,
  compliment_cute int,
  compliment_list int,
  compliment_note int,
  compliment_plain int,
  compliment_cool int,
  compliment_funny int,
  compliment_writer int,
  compliment_photos int,
  primary key(id)
) engine=innodb;

create table friend
( user_id varchar(22) not null,
  friend_id varchar(22) not null,
  primary key(user_id,friend_id),
  foreign key(user_id) references user(id) on update cascade on delete cascade,
  foreign key(friend_id) references user(id) on update cascade on delete cascade
) engine=innodb;

create table review
( id varchar(22) not null,
  stars int,
  date datetime,
  text text,
  useful int,
  funny int,
  cool int,
  business_id varchar(22),
  user_id varchar(22),
  primary key(id),
  foreign key(business_id) references business(id) on update cascade on delete cascade,
  foreign key(user_id) references user(id) on update cascade on delete cascade
) engine=innodb;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\business.csv'
INTO TABLE business CHARACTER SET latin1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\user.csv'
INTO TABLE `user` CHARACTER SET latin1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\friend.csv'
INTO TABLE friend CHARACTER SET latin1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\review.csv'
INTO TABLE review CHARACTER SET latin1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- 3b

-- i
select B.id, b.name
from business as B, review as R
where B.review_count>30 and B.stars>4 and not exists
( select *
  from review as X
  where X.business_id=B.id and X.stars<3
);

-- ii
select R.business_id, count(*)
from review as R
where R.stars = 4 or R.stars = 5
group by R.business_id
having count(*)>=3;

-- iii
select (count(*)/(select count(distinct business_id) from review)) * 100
from
(select business_id, count(*) as c1
from review
where stars=4 or stars=5
group by business_id) as x,
(select business_id, count(*) as c2
from review
where stars=1 or stars=2
group by business_id) as y
where x.business_id=y.business_id and x.c1>y.c2;

-- iv
(select business_id, avg(stars)
from review
where useful>=2
group by business_id)
union
(select business_id, 0
 from review as R1
 where not exists
 ( select *
   from review as R2
   where R2.business_id=R1.business_id and R2.useful>=2 
 )
); 

-- v
select count(*) from 
(select R.user_id
from review as R
where R.stars = 5
group by R.user_id
having count(*) > 
(select count(*)
 from review as R1, friend as F
 where F.user_id=R.user_id and F.friend_id=R1.user_id and R1.stars=5
 )) as X;
 
 -- 3c
 
 -- i
 update business
 set state='MA';
 
 -- ii
 insert into user
 values ('mpla_mpla','TEST',7,'2020-07-18 00:19:15',5,1,0,0,2.25,0,0,0,0,0,0,0,0,0,0,0);

insert into review
select id, 3, "2021-12-01 20:20:20", "OK", 5, 6, 7, id, "mpla_mpla"
from business
where is_open=1;


SET SQL_SAFE_UPDATES = 0;

UPDATE business
SET state = 'MA';

SET SQL_SAFE_UPDATES = 1;


USE yelp;
SELECT * FROM `user` WHERE id='mpla_mpla';
SELECT COUNT(*) FROM review WHERE user_id='mpla_mpla';
