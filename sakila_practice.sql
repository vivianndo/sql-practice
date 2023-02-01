#SQL Practice using the Sakila Database
use sakila;

#show all tables
show tables;

#show all selections from actor table
SELECT * from actor;

# Using the select clause
#Which actors have the first name 'Scarlett'? 
SELECT * from actor WHERE first_name = 'SCARLETT';

#Which actors have the last name 'Johansson'?
SELECT * from actor where last_name = 'JOHANSSON';

#How many distinct actors' last names are there? 
select count(distinct last_name) from actor;

#Which last names are not repeated?
select a.last_name from actor a 
GROUP BY a.last_name
HAVING count(*) = 1;

#which last names appear more than once? 
select last_name, count(*) from actor
GROUP BY last_name
HAVING COUNT(*)>=2;

#which actor has appeared in the most films? 
select a.actor_id, a.first_name, a.last_name, count(fa.film_id) FROM actor a 
INNER JOIN film_actor fa on a.actor_id = fa.actor_id
GROUP BY fa.actor_id
ORDER BY count(film_id) desc;

#what is the average length of all the films? 
select AVG(length) from film;

#insert a record to represent Mary Smith renting 'Academy Dinosaur' from Mike Hillyer at Store 1 today
select * from customer where first_name='Mary';
select * from film where title='Academy Dinosaur';
select * from staff where first_name='Mike' and last_name='Hillyer';

INSERT INTO RENTAL (RENTAL_DATE, INVENTORY_ID, CUSTOMER_ID, STAFF_ID) values (NOW(), 1, 1, 1);

#check to see that the insert was successful
select * from rental order by rental_id desc limit 1;

#Update that row to set the return date to one week from today; 
update rental set return_date = adddate(Now(),7)
where rental_id=16050;
select * from rental order by rental_id desc limit 1;

#retrieve the actor ID, first name, and last name for all actors. Sort by last name and then by first name 
select actor_id, first_name, last_name from actor order by last_name;
select actor_id, first_name, last_name from actor order by first_name;

#retrieve the actor ID, first name, and last name for all actors whose last names equals 'WILLIAMS' or 'DAVIS'
select actor_id, first_name, last_name from actor where last_name = 'WILLIAMS' or last_name = 'DAVIS'; 

#write a query against the rental table that returns the IDS of the customers who rented a film on July 5, 2005. Include a single row for each distinct customer ID.
describe rental;
select customer_id from rental where date(rental_date) = '2005-07-05';

#retrieve all rows from the payments table where the amount is either 1.98, 7.98, or 9.98
select * from payment where amount = '1.98' or amount = '7.98' or amount = '9.98';

#all customers whose last names contains an A in the second position and a W anywhere after the A
select * from customer where last_name like '_A%W%';

#the title of every film in which an actor with the first name JOHN appeared
select f.title from film f
INNER JOIN film_actor fa on f.film_id = fa.film_id
INNER JOIN actor a on fa.actor_id = a.actor_id where a.first_name = 'JOHN';

#all addresses that are in the same city
select a.city_id, a.address, a2.address from address a
INNER JOIN address a2
on a.city_id= a2.city_id and a.address <> a2.address;




#generate a list of all first and last names from multiple tables
select 'cust' type, c.first_name, c.last_name from customer c
UNION ALL
select 'actr' type, a.first_name, a.last_name from actor a;
#Note: each name is labeled with the table it comes from using select type 

#generate a list of people having the initials JD
select c.first_name, c.last_name from customer c 
where c.first_name like 'J%' and c.last_name like 'D%'
UNION ALL
select a.first_name, a.last_name from actor a
where a.first_name like 'J%' and a.last_name like 'D%';

#generate a list of people having the initials JD w/out duplicates
select c.first_name, c.last_name from customer c 
where c.first_name like 'J%' and c.last_name like 'D%'
UNION
select a.first_name, a.last_name from actor a
where a.first_name like 'J%' and a.last_name like 'D%';

#Notes: The UNION operator allows the combination of multiple tables. UNION ALL keeps all duplicates. 











