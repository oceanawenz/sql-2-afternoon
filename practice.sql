-- SELECT [Column names] 
-- FROM [table] [abbv]
-- JOIN [table2] [abbv2] ON abbv.prop = abbv2.prop WHERE [Conditions];

-- SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id;
-- SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id WHERE b.email = 'e@mail.com';

--#1 Get all invoices where the unit_price on the invoice_line is greater than $0.99.
select * from invoice
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where invoice_line.unit_price > .99;

--#2 Get the invoice_date, customer first_name and last_name, and total from all invoices.
select invoice.invoice_date, customer.first_name, customer.last_name, invoice.total
from invoice
join customer on invoice.customer_id = customer.customer_id;

--#3 Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
select customer.first_name, customer.last_name, employee.first_name, employee.last_name
from customer
join employee on customer.support_rep_id = employee.employee_id;

--#4 Get the album title and the artist name from all albums.
select album.title, artist.name
from album
join artist on album.album_id = artist.artist_id;

--#5 Get all playlist_track track_ids where the playlist name is Music.
select playlist_track.track_id
from playlist_track
join playlist on playlist.playlist_id = playlist_track.playlist_id
where playlist.name = 'Music';

--#6 Get all track names for playlist_id 5.
select track.name
from track
join playlist_track on playlist_track.track_id = track.track_id
where playlist_track.playlist_id = 5;

--#7 Get all track names and the playlist name that they're on ( 2 joins ).
select track.name, playlist.name
from track
join playlist_track on track.track_id = playlist_track.track_id
join playlist on playlist_track.playlist_id = playlist.playlist_id;

--#8 Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
select track.name, album.title
from track
join album on track.album_id = album.album_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Alernative & Punk';

----------------NESTED QUERIES---------------
--#1 Get all invoices where the unit_price on the invoice_line is greater than $0.99.
select * from invoice
where invoice_id in (select invoice_id from invoice_line where unit_price > .99);

--#2 Get all playlist tracks where the playlist name is Music.
select * from playlist_track
where playlist_id in (select playlist_id from playlist where name = 'Music');

--#3 Get all track names for playlist_id 5.
select name
from track
where track_id in (select track_id from playlist_track where playlist_id = 5); 

--#4 Get all tracks where the genre is Comedy.
select *
from track
where genre_id in (select genre_id from genre where name = 'Comedy');

--#5 Get all tracks where the album is Fireball.
select * from track
where album_id in (select album_id from album where title = 'Fireball');

--#6 Get all tracks for the artist Queen ( 2 nested subqueries ).
select * from track
where album_id in (
  select album_id from album where artist_id in 
  (select artist_id from artist where name = 'Queen')
);

----PRACTICE UPDATING ROWS----------------------------------
--#1 Find all customers with fax numbers and set those numbers to null.
update customer 
set fax = null
where fax is not null;

select * from customer;

--#2 Find all customers with no company (null) and set their company to "Self".
update customer
set company = 'Self'
where company is null;

select * from customer;

--#3 Find the customer Julia Barnett and change her last name to Thompson.
update customer
set last_name = 'Thompson'
where first_name = 'Julia' and last_name = 'Barnett';

select * from customer;

--#4 Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.s
update customer
set support_rep_id = 4
where email = 'luisrojas@yahoo.cl';

select * from customer;

--#5 Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = ( SELECT genre_id FROM genre WHERE name = 'Metal' )
AND composer IS null;

select * from track;

------GROUP BY-------------------------
--#1 Find a count of how many tracks there are per genre. Display the genre name with the count.
select genre.name, count(*)
from track 
join genre on track.genre_id = genre.genre_id
group by genre.name;

--#2 Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
select genre.name, count(*)
from track
join genre on genre.genre_id = track.genre_id
where genre.name = 'Pop' or genre.name = 'Rock'
group by genre.name;

--#3 Find a list of all artists and how many albums they have.
select artist.name, count(*)
from album
join artist on artist.artist_id = album.artist_id
group by artist.name;

----------------DISTINCT----------------
--#1 From the track table find a unique list of all composers.
select distinct composer from track;

--#2 From the invoice table find a unique list of all billing_postal_codes.
select distinct billing_postal_code
from invoice;

--#3 From the customer table find a unique list of all companys.
select distinct company
from customer;

-----------DELETE ROWS----------------------
--#1 Delete all 'bronze' entries from the table.
delete from practice_delete 
where type = 'bronze';
select * from practice_delete;

--#2 Delete all 'silver' entries from the table.
delete from practice_delete 
where type = 'silver';

select * from practice_delete;

--#4 Delete all entries whose value is equal to 150.
delete from practice_delete
where value = 150;

select * from practice_delete;

--eCommerce Simulation----------
-- Create 3 tables 
create table users (
user_id serial primary key,
name text not null,
email text not null
);

create table products (
product_id serial primary key,
name text,
price integer
);

create table orders (
order_id serial primary key,
name text,
price integer,
product_id integer references products(product_id)
);

--Add some data to fill up each table.
    --At least 3 users, 3 products, 3 orders.
insert into users (name, email) values ('michael', 'michael@gmail.com');

insert into users (name, email) values ('carlie', 'carlie@yahoo.com');

insert into users (name, email) values ('justin', 'justin@yahoo.com');

insert into products (name, price) values ('tablet', 100);
insert into products (name, price) values ('computer', 1000);
insert into products (name, price) values ('phone', 800);

insert into orders (name, price) values ('tablet', 100);
insert into orders (name, price) values ('computer', 1000);
insert into orders (name, price) values ('phone', 800);

-- Run queries against your data.
--Get all products for the first order.


--Get all orders.


-- Get the total cost of an order ( sum the price of all products on an order ).