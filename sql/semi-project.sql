alter session set "_oracle_script" = true;

create user threego
identified by threego
default tablespace users;

grant connect, resource to threego;
alter user threego quota unlimited on users;

---------------------------------------------------------------

create table member(
    id 	varchar2(30),	
    pwd	varchar2(300) not null,
    name varchar2(20) not null,
    email varchar2(200),	
    phone char(11) not null,
    member_role char(1) default 'U',
    post char(5) not null,
    address	varchar2(400) not null,
    reg_date date default sysdate,	
    constraints pk_member_id primary key(id),
    constraints uq_member_phone unique(phone),
    constraints uq_member_email unique(email),
    constraints ck_member_role check (member_role in ('A', 'R', 'U'))
        );

  
create table ticket(
    tic_id 	varchar2(30),	
    tic_name varchar2(30) not null,
    tic_cnt number not null,
    tic_price number not null,
    constraint  pk_ticket_no primary key(tic_id)
    );        
                
create table payment(
    p_no	number,
    p_mem_id	varchar2(30),
    p_tic_id varchar2(30),
    p_date date default sysdate,
    p_cnt number, 
    p_use_cnt number,
    constraint  pk_payment_p_no primary key(p_no),
    constraints fk_payment_mem_id foreign key(p_mem_id) references member (id),
    constraints fk_paymente_tic_no foreign key(p_tic_id) references ticket(tic_id) 
   );  
 create sequence seq_payment_no;  
   
   
create table board(
    b_no number,
    b_type	varchar2(30) not null,
    b_tittle varchar2(500) not null,
    b_writer varchar2(30) not null,
    b_content varchar2(4000) not null,
    b_reg_date date default sysdate,
    b_cnt	 number default 0,
    constraints pk_board_b_no primary key(b_no),
    constraints fk_board_b_writer foreign key(b_writer) references member(id) on delete cascade,
    constraints ck_board_b_type check(b_type in ('0', '1', '2', '3'))
);
 create sequence seq_board_no;
 
 

create table board_comment(
    c_no number,
    c_level number default 1,
    c_writer varchar2(30),
    c_content varchar2(4000) not null,
    c_board_no number not null,
    c_reg_date date default sysdate,
    constraints pk_board_comment_c_no primary key(c_no),
    constraints fk_board_comment_c_writer foreign key(c_writer) references member(id) on delete cascade,
    constraints fk_board_comment_c_ref foreign key(c_board_no) references board( b_no) on delete cascade
);
 create sequence seq_c_no;

create table location(
    l_id varchar2(30),	
    l_name	varchar2(20) not null,
    constraints pk_location_l_no primary key(l_id)
);


create table rider(
    r_id varchar2(30),
    r_location_id varchar2(30),
    r_status char(1),
    r_reg_date date default sysdate,
    up_date	date default null,
    constraints pk_r_id primary key(r_id),
    constraints fk_rider_r_id  foreign key(r_id) references member(id) on delete cascade,
    constraints fk_rider_location_id foreign key(r_location_id) references location(l_id),
    constraints ck_rider_r_status check (r_status in ('0', '1'))
);


create table request(
    req_no	number,
    req_writer varchar2(30) not null,
    req_location_id	varchar2(30) not null,
    req_photo varchar2(200) not null,
    req_status	char(1) default 0,
    req_date	date default sysdate,
    req_rider varchar2(30) , 
    req_cp_date date default null,
    constraints pk_request_req_no primary key(req_no),
    constraints fk_request_id foreign key(req_writer) references member(id), 
    constraints fk_request_location_id foreign key(req_location_id) references location(l_id),
    constraints fk_req_rider foreign key(req_rider) references rider(r_id),
    constraints ck_request_status check( req_status in ('0', '1', '2', '3'))
);
 create sequence seq_req_no;


create table del_member(

del_id varchar2(30),
del_pwd varchar2(300)	 not null,
del_email	varchar2(200),	
del_phone number(11)	not null,
del_role	 char(1),	
del_address 	varchar2(400)	not null,
del_reg_date date,	
del_date date,	
constraints pk_del_member_del_id primary key(del_id),
constraints fk_del_member_del_id foreign key(del_id) references member(id)
);
alter table del_member modify del_phone char(11);
create table warning(
w_no	 number,		
w_req_no	number not null,	
w_writer  varchar2(30)	not null,	
w_content varchar2(4000)	not null,	
w_reg_date date default sysdate,
w_confirm number default 0, 
w_caution varchar2(4000),
constraints pk_warning_w_no primary key(w_no),
constraints fk_warning_w_req_no foreign key(w_req_no) references request(req_no),
constraints fk_warning_w_id foreign key(w_writer) references member(id),
constraints ck_warning_w_confirm check(w_confirm in('0', '1'))
);
 create sequence seq_w_no;
 
 CREATE TABLE VISIT (V_DATE date);
 
 insert into member values (
    'admin', 'admin','관리자','admin@admin1.com','01033233372','A','11111' ,'관리자입니다.',default
);   
 insert into member values (
    'eogh', 'eogh','황대호','eogh@naver.com','01011111111','U','05673' ,'서울 송파구 오금로32길 31 (송파동,래미안송파파인탑) 103동1604호',default
);  
 insert into member values (
    'xogus', 'xogus','이태현','xogus@naver.com','01021111111','R','17867' ,'경기 평택시 현신3길 76 (용이동,평택 용이2차푸르지오) 215동601호',default
);
 insert into ticket values (
    'tic1', '1회권',1,5000 
 );
  insert into ticket values (
    'tic3', '3회권',3,15000 
 );
  insert into ticket values (
    'tic5', '5회권',5,23900 
 );
  insert into ticket values (
    'tic10', '10회권',10,46900 
 );

 insert into payment values (
     seq_payment_no.nextval, 'eogh','tic3',sysdate,3,0
 );

insert into location values(
    'S1', '강남구, 서초구'
);
insert into location values(
    'S2', '송파구, 강동구'
);
insert into location values(
    'S3', '광진구,성동구'
);

 insert into rider values (
    'xogus', 'S2','1', sysdate,sysdate
);

 insert into request values(
 seq_req_no.nextval, 'eogh', 'S2', '미정ㅠㅠ', 2, default, 'xogus',sysdate
 );
  insert into request values(
 seq_req_no.nextval, 'eogh', 'S2', '미정ㅠㅠ', 0, default, null,default
 );
   insert into request values(
 seq_req_no.nextval, 'eogh', 'S2', '미정ㅠㅠ', 1, default, 'xogus',null
 );



select * from member;
select * from ticket;
select * from location;
select * from rider;
select * from request; 
    -- commit;
