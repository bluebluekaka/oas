/*
create database oasdb;
GRANT all privileges ON oasdb.* TO oasdb@localhost IDENTIFIED BY 'Oas.123';
use oasdb; test
*/

create table user(
	id integer not null,	/* primary key  */
	uid varchar(20) not null,	/* logon id  */
	name varchar(20),
	pwd varchar(32),
	email varchar(40),
	state smallint,		/* 0 disabled, 1 enabled  */
	usertype smallint,	/* 0 admin, 1 common, 2 common manager, 3 finance,4 finance manager, 5 top manager  */ 
	phone varchar(30),
	mobile varchar(20),
	lastip varchar(20),
	lasttime timestamp,
	cmnt varchar(50),
	leaderid varchar(20)
)  ;
alter table user add constraint pk_user primary key(id);
create unique index indx_user on user(uid);

create table  userlogs(
	id integer primary key auto_increment,	/* primary key  */
	userid varchar(20) not null,	/* user id  */
	ext varchar(20) ,	/* other   */
	type integer default -1,	/* other  */
	lasttime timestamp,
	lasttimei integer default 0,
	cmnt varchar(400)
);

create table orderinfo(
	id integer primary key auto_increment,	/* primary key  */
	userid varchar(20), /* user.workno */
	orderid varchar(20) not null,	/* order id  */
	state smallint default -1,	/* 0 create, 1 wait common manager, 2 common manager allow, 3 common manager disallow,4 wait finance,5 wait finance manager,6 finance manager allow,7 finance manager disallow */
	type smallint, 	/* 0 order ,1 cancel */
	producttype	smallint, /* 0 international, 1 internal */
	productname varchar(20),
	cid varchar(20) not null,	/* customerID  */
 	pnr varchar(20) not null,
 	recmoney decimal(12,2) default 0,
 	paymoney decimal(12,2) default 0,
 	profit decimal(12,2) default 0,
	lasttime timestamp,
	lasttimei integer default 0,
	lastuser varchar(20),
	createtime timestamp,
	createtimei integer default 0,
	cmnt varchar(400)
);


create table orderlogs(
	id integer primary key auto_increment,	/* primary key  */
	userid varchar(20),
	orderid varchar(20) not null,	/* order id  */
	state smallint  default -1,		/* 0 create, 1 wait common manager, 2 common manager allow, 3 common manager disallow,4 wait finance,5 wait finance manager,6 finance manager allow,7 finance manager disallow */
	type smallint, 	/* 0 order ,1 cancel */
	producttype	smallint, /* 0 international, 1 internal */
	productname varchar(20),
	cid varchar(20) not null,	/* customerID  */
 	pnr varchar(20) not null,
 	recmoney decimal(12,2) default 0,
 	paymoney decimal(12,2) default 0,
 	profit decimal(12,2) default 0,
	lasttime timestamp,
	lasttimei integer default 0,
	lastuser varchar(20),
	cmnt varchar(400)
);

create table orderproduct(
	id integer primary key auto_increment,	/* primary key  */
	orderid varchar(20),
	carrier varchar(20),	 
	flight varchar(20),
	position varchar(10),
	trip	varchar(20),
	sdate   varchar(20),
	stime   varchar(20),
	edate   varchar(20),
	etime   varchar(20)
);

create table ordertraveller(
	id integer primary key auto_increment,	/* primary key  */
	orderid varchar(20) not null, 
	name varchar(20),	 
	type smallint,
	recmoney decimal(12,2) default 0,
 	paymoney decimal(12,2) default 0,
 	pnum varchar(20),
 	supplier varchar(20)
);

create table ordercmnt(
	id integer primary key auto_increment,	/* primary key  */
	orderid varchar(20) not null, 
	username varchar(20),	 
	lasttime timestamp,
	cmnt	varchar(500)
);

create table Customer
(
   customerID           varchar(20) not null,
   name                 varchar(20),
   company              varchar(50),
   sex                  smallint,
   telephone            varchar(20),
   phone                varchar(20),
   qq                   varchar(15),
   address              varchar(50),
   operator             varchar(20),
   residualValue        decimal(12,2),
   id integer primary key auto_increment
);
create unique index indx_customer on Customer(customerID);

drop table if exists order_offset_info;

/*==============================================================*/
/* Table: order_offset_info                                     */
/*==============================================================*/
create table order_offset_info
(
   order_offset_code      bigint primary key auto_increment,
   order_code           varchar(20) not null,
   return_amount        decimal(12,2),
   offset_orders        varchar(500),
   all_offset_amount    decimal(12,2),
   balance              decimal(12,2),
   creater              varchar(20),
   create_time          timestamp,
   create_timei         integer,
   last_user            varchar(20),
   last_operate_time    timestamp,
   last_operate_timei   integer
);


