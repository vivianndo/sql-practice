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

#display the first and last names of all actors from the table actor
select first_name, last_name from actor;

#display the first and last name of each actor in a single column in upper case letters. Name the column 'Actor Name'
select concat(first_name,' ',last_name) 'Actor Name' from actor;

#You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
select actor_id, first_name, last_name from actor
where first_name = 'Joe';

#Find all actors whose last name contain the letters GEN:
select * from actor
having last_name LIKE '%GEN%';

#Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor
having last_name LIKE '%LI%'
order by last_name, first_name;

#Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
select c.country_id, c.country from country c
where c.country in ('Afghanistan', 'Bangladesh','China');

#List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) from actor
group by last_name;

#List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) from actor
group by last_name
having count(last_name) >1
order by count(last_name) desc;

#The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from actor
where first_name = 'GROUCHO'; #find 'HARPO WILLIAMS' actor id (172)

update actor
set first_name = 'HARPO', last_name = 'WILLIAMS'
where actor_id = '172'; #perform update

select * from actor
where actor_id='172'; #confirm update

#Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
	#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = 'GROUCHO'
where first_name='HARPO' and last_name='WILLIAMS';
select * from actor
where actor_id='172'; #confirm update

#Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name, s.last_name, a.address, a.address2 from staff s
inner join address a;

#Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select s.staff_id, s.first_name, s.last_name, sum(p.amount) from staff s
join payment p
on s.staff_id = p.staff_id
where month(p.payment_date)=08 and year(p.payment_date)=2005
group by s.staff_id;

#List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(*) from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by f.film_id
order by count(*) desc;

#How many copies of the film Hunchback Impossible exist in the inventory system?


#Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

#The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

#Use subqueries to display all actors who appear in the film Alone Trip.

#You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

#Display the most frequently rented movies in descending order.

#Write a query to display how much business, in dollars, each store brought in.

#Write a query to display for each store its store ID, city, and country.

#List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

#In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

#How would you display the view that you created in 8a?

#You find that you no longer need the view top_five_genres. Write a query to delete it.