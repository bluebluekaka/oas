alter table Customer add state varchar(5) default "0";
alter table user add workcardno varchar(15);

alter table user add sex varchar(4) default "0";


alter table user add qq varchar(15);
alter table user add address varchar(100);

drop table if exists customer_transfer;

/*==============================================================*/
/* Table: customer_transfer                                     */
/*==============================================================*/
create table customer_transfer
(
   transfer_id          bigint primary key auto_increment,
   customer_id          varchar(20),
   transfer_account     varchar(50),
   transfer_amount      decimal(12,2),
   remark               varchar(500),
   transfer_state       smallint,
   creater              varchar(20),
   create_time          timestamp,
   create_timei         integer,
   last_user            varchar(20),
   last_operate_time    timestamp,
   last_operate_timei   integer
);

drop table if exists transfer_financial_order_rela;

/*==============================================================*/
/* Table: transfer_financial_order_rela                         */
/*==============================================================*/
create table transfer_financial_order_rela
(
   transfer_id          bigint not null,
   financial_order_code bigint not null,
   primary key (transfer_id, financial_order_code)
);

drop table if exists other_expenses_rela_financial_order;

/*==============================================================*/
/* Table: other_expenses_rela_financial_order                   */
/*==============================================================*/
create table other_expenses_rela_financial_order
(
   other_expenses_id    bigint primary key auto_increment,
   financial_order_code bigint,
   other_expenses_type  smallint,
   adjust_amount        decimal(12,2),
   amount_explain       varchar(512),
   other_expenses_state smallint,
   creater              varchar(20),
   create_time          timestamp,
   create_timei         integer,
   last_user            varchar(20),
   last_operate_time    timestamp,
   last_operate_timei   integer
);



alter table user DROP  birthday ;
alter table user add birthday varchar(30) default "1900-01-01";

drop table if exists financial_order;

/*==============================================================*/
/* Table: financial_order                                       */
/*==============================================================*/
create table financial_order
(
   financial_order_code bigint primary key auto_increment,
   order_code           varchar(20),
   adjust_amounts      decimal(12,2),
   adjust_profit        decimal(12,2),
   order_state 			smallint,
   received_amount      decimal(12,2),
   received_state       smallint,
   creater              varchar(20),
   create_time          timestamp,
   create_timei         integer,
   last_user            varchar(20),
   last_operate_time    timestamp,
   last_operate_timei   integer
);

alter table Customer add oldOperator varchar(20);

alter table financial_order add audit_state smallint default 0;

alter table ordertraveller modify column name varchar(80) ;


 
alter table Customer add createtime varchar(30) default "2014-05-06" ;
 
alter table orderinfo add offercompany varchar(100) default "" ;

/*      0530      */
drop table if exists offercompany;
create table offercompany
(
   id integer primary key auto_increment,
   state smallint,
   man		varchar(100),
   name		varchar(200) not null,
   qq		varchar(20),
   addr		varchar(400),
   phone	varchar(20),
   fox		varchar(20),
   num_code	varchar(20),
   cmnt		varchar(400),
   creater              varchar(20),
   create_time          timestamp,
   create_timei         integer
);
 
--fy
alter table Customer add paid_amount decimal(12,2) default 0.00;
alter table customer_transfer add transfer_type smallint;
alter table customer_transfer add usable_amount decimal(12,2);
alter table customer_transfer add usable_state smallint default 0;


drop table if exists offset;
/*==============================================================*/
/* Table: offset                                       */
/*==============================================================*/
create table offset
(
   offset_id bigint primary key auto_increment,
   customer_id varchar(20),
   transfer_id bigint,
   financial_order_codes varchar(200),
   offset_transfer_amounts      decimal(12,2),
   offset_financial_amounts_all      decimal(12,2),
   offset_amounts      decimal(12,2),
   balance      decimal(12,2),
   offset_state       smallint,
   creater              varchar(20),
   create_time          timestamp,
   create_timei         integer
);

drop table if exists transfer_financial_order_rela;

/*==============================================================*/
/* Table: transfer_financial_order_rela                         */
/*==============================================================*/
create table transfer_financial_order_rela
(
   offset_id            bigint not null,
   transfer_id          bigint not null,
   financial_order_code bigint not null,
   offset_financial_amounts      decimal(12,2),
   primary key (offset_id,transfer_id, financial_order_code) 
); 


alter table customer_transfer add state smallint default 0;
drop table if exists customer_amount_logs;
create table  customer_amount_logs(
	id integer primary key auto_increment,	/* primary key  */
	customer_id varchar(20) not null,	/* user id  */
	rela_id varchar(20) ,	/* other   */
	type integer default -1,	/* other  */
	residualValueOld decimal(12,2),
	residualValueNew decimal(12,2),
	paid_amount_old decimal(12,2),
	paid_amount_new decimal(12,2),
	lasttime timestamp,
	lasttimei integer default 0,
	cmnt varchar(400)
);

DROP TABLE IF EXISTS `fast_order`;
CREATE TABLE `fast_order` (
  `fast_order_id` int(11) NOT NULL auto_increment,
  `relaOrderId` varchar(20) default NULL,
  `customer_id` varchar(20) default NULL,
  `type` smallint(6) default NULL,
  `pnr` varchar(20) default NULL,
  `createtime` timestamp NOT NULL default '0000-00-00 00:00:00',
  `createtimei` int(11) default '0',
  `creater` varchar(20) default NULL,
  `lasttime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `lasttimei` int(11) default '0',
  `lastuser` varchar(20) default NULL,
  `state` smallint(6) default '-1',
  `recmoney` decimal(12,2) default NULL,
  `paymoney` decimal(12,2) default NULL,
  `profit` decimal(12,2) default NULL,
  `mark` varchar(400) default NULL,
  `order_state` smallint(6) default '0',
  PRIMARY KEY  (`fast_order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
