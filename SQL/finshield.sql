create database finshield;
use finshield;

create table transactions(
	transaction_id int primary key,
    user_id int,
    transaction_amount decimal(10,2),
    transaction_time datetime,
    merchant_category varchar(50),
    location varchar(50),
    device_type varchar(20),
    payment_method varchar(20),
    is_international tinyint,
    previous_transaction_gap int,
    user_avg_spend decimal(10,2),
    transaction_frequency int,
    is_fraud tinyint
);

select * from transactions;
select count(*) from transactions;

alter table transactions add column risk_score float;
set sql_safe_updates = 0;
update transactions set risk_score =
	(case when transaction_amount > user_avg_spend * 2 then 1 else 0 end) * 0.4 + 
    (case when previous_transaction_gap < 5 then 1 else 0 end) * 0.3 +
    (case when is_international = 1 then 1 else 0 end) * 0.3;
    
alter table transactions add column risk_level varchar(10);
set sql_safe_updates = 0;
update transactions set risk_level =
case
	when risk_score < 0.3 then 'Low'
    when risk_score < 0.6 then 'Medium'
    else 'High'
end;