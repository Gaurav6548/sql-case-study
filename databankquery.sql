use mysql;
select * from customer_nodes limit 10;
select * from customer_transactions limit 10;
select * from regions;
-- 1
select count(distinct node_id) as total_nodes from customer_nodes;

-- 2
select r.region_name,count(node_id) as total_nodes from customer_nodes c join regions r on r.region_id=c.region_id 
group by r.region_name order by total_nodes;

-- 3
select r.region_name,(count(distinct(customer_id))) as total_cust from customer_nodes c join regions r on r.region_id=c.region_id 
group by r.region_name order by total_cust;

-- 4 
select region_name, sum(txn_amount) as 'total transaction amount' from regions,customer_nodes,customer_transactions 
where regions.region_id=customer_nodes.region_id and customer_nodes.customer_id=customer_transactions.customer_id 
group by region_name;

-- 5 
select round(avg(datediff(end_date,start_date)),2) as avg_days from customer_nodes
where end_date!='9999-12-31';

-- 6
select txn_type,sum(txn_amount) as tot_transac,count(*) as count_trans from customer_transactions group by txn_type;

-- 7
SELECT round(count(customer_id)/
               (SELECT count(DISTINCT customer_id)
                FROM customer_transactions)) AS average_deposit_count,
       concat('$', round(avg(txn_amount), 2)) AS average_deposit_amount
FROM customer_transactions
WHERE txn_type = "deposit";

-- 8
with transaction_count as(
select customer_id,month(txn_date) as txn_month,
sum(if(txn_type='deposit',1,0)) as deposit_count,
sum(if(txn_type='withdrawl',1,0)) as withdrawl_count,
sum(if(txn_type='purchase',1,0)) as purchase_count
from customer_transactions group by customer_id,month(txn_date))
select txn_month,count(distinct(customer_id)) as count_cust from transaction_count
where deposit_count>1 and (purchase_count=1 or withdrawl_count=1)
group by txn_month;