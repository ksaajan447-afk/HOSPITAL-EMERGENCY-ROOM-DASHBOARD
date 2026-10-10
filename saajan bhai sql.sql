create database online_book_store;
use online_book_store;

-- create table 
drop table if exists book;
create table book(
book_id serial primary key,
title varchar(100),
author varchar(100),
genre varchar(50),
published_year int,
price numeric(10,2),
stock int
);
drop table if exists customers;
create table customers(
customer_id serial primary key,
name varchar(100),
email varchar(100),
phone varchar(15),
city varchar(50),
country varchar(150)
);
drop table if exists orders;
create table orders(
order_id serial primary key,
customer_id int references customers(customer_id),
book_id int references books(book_id),
order_date date,
quantity int,
total_amount numeric(10,2)
);
select * from book;
select * from customers;
select * from orders;

-- import data into book table
LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/book.csv'
INTO TABLE book
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
select * from book;
select * from customers;
select * from orders;

-- 1) retrieve all books in the "Fiction" genre:
select * from book
where genre = "Fiction";

-- 2) find book published after the year 1950:
select * from book
where published_year > 1950;

-- 3) list all customers from the canada:
select * from customers 
where country = "canada";

-- 4)show orders placed in november 2023:
select * from orders
where order_date between "2023-11-01" and "2023-11-30";

-- 5) retrieve the total stock of books available:
select sum(stock) as total_stock
from book;

-- 6) find the details of most expensive book:
select * from book order by price desc limit 1;

-- 7) show all customer who ordered more than 1 quantity of a book:
select * from orders
where quantity > 1;

-- 8) retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount > 20;

-- 9) list all genres available in the books table:
select distinct genre from book;

-- 10) find the book with the lowest stock:
select * from book order by stock limit 1;

-- 11) calculate the total revenue generated from all orders:
select sum(total_amount) as revenue from orders;

-- ADVANCE QUESTIONS:

-- 1) retrieve the total number of book sold for each genre:
select b.genre, sum(o.quantity) as total_books_sold
from orders o
join book b on o.book_id = b.book_id
group by b.genre;

-- 2) find the average price of book in the "fantasy" genre:
select avg(price) as avg_price
from book
where genre = "fantasy";

-- 3) list customers who have placed at least 2 orders:
select o.customer_id, c.name, count(o.order_id) as order_count
from orders o
join customers c on o.customer_id=c.customer_id
group by customer_id, c.name
having count(order_id) >=2;

-- 4) find the most frequently ordered book:
select book_id, count(order_id) AS order_count
from orders
group by book_id
order by order_count desc limit 1;

-- 5) show the top 3 most expensive books of "fantasy" genre:
select * from book
where genre = "fantasy"
order by price desc
limit 3;

-- 6) retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as total_book_sold
from orders o
join book b on o.book_id = b.book_id
group by b.author; 

-- 7) list the cities were customers who spent over $30 are located:
select c.city, sum(o.total_amount)
from customers c
join orders o on c.customer_id = o.customer_id
group by c.city
having sum(total_amount) > 30;

-- 8) find the cutomer who spent the most on order:
select c.name, sum(o.total_amount) as totaling
from customers c
join orders o on c.customer_id = o.customer_id
group by c.name
order by totaling desc;

-- 9) calculate the stock remaining after fullfilling all order:
select b.book_id, b.title, b.stock, coalesce(sum(quantity),0) as order_quantity,
 b.stock - coalesce(sum(quantity),0) as remaining_quantity
from book b
left join orders o on b.book_id = o.book_id
group by b.book_id order by b.book_id;







