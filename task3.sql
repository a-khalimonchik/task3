-- задание 1
-- вывести количество фильмов в каждой категории, отсортировать по убыванию.

select c."name"  as category, count(distinct film_id) as films
from film_category fc 
join category c on fc.category_id = c.category_id 
group by category 
order by films desc 



-- задание 2
-- вывести 10 актеров, чьи фильмы большего всего арендовали, отсортировать по убыванию.

select concat(first_name,' ',last_name) as actor, sum(f.rental_duration) as rental    
from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
join film f on fa.film_id = f.film_id 
group by actor
order by rental desc 
limit 10



-- задание 3
-- вывести категорию фильмов, на которую потратили больше всего денег.     

select category, sum(p.amount) as total
from film_list fl
join film f on fl.fid = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id  
group by category
order by total desc 
limit 1

 

-- задание 4
-- вывести названия фильмов, которых нет в inventory.
-- написать запрос без использования оператора IN !

select f.title 
from film f 
where not exists (select i.film_id  
				  from inventory i
				  where f.film_id = i.film_id ) 			  
				  
				  
				  
-- задание 5
-- вывести топ 3 актеров, которые больше всего появлялись 
-- в фильмах в категории “Children”. Если у нескольких актеров 
-- одинаковое кол-во фильмов, вывести всех.	
				  
select concat(first_name,' ',last_name) as actor     		 	
from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
join film f on fa.film_id = f.film_id 
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id 
where c.name = 'Children'
group by actor
order by count(f.film_id) desc
fetch first 3 rows with ties 

			

-- задание 6
-- вывести города с количеством активных и неактивных клиентов (активный — customer.active = 1). 
-- отсортировать по количеству неактивных клиентов по убыванию.

select c.city, sum(case 
when cc.active = 1 then 1 
when cc.active = 0 then 0
end) as active,
sum (case 
when cc.active = 0 then 1 
when cc.active = 1 then 0
end) as inactive
from city c 
join address a on c.city_id = a.city_id 
join customer cc on a.address_id = cc.address_id 
group by cc.active, c.city  
order by inactive desc



-- задание 7  
-- Вывести категорию фильмов, у которой самое большое кол-во часов суммарной аренды в городах 
-- (customer.address_id в этом city), и которые начинаются на букву “a”. то же самое сделать 
-- для городов в которых есть символ “-”. Написать все в одном запросе.

select c.name as category, round((sum(extract(epoch from age(return_date,rental_date))/3600))) as hours
from category c, film_category fc, address a, city ct, customer cm, rental r, inventory i
where ct.city_id = a.city_id and a.address_id = cm.address_id and cm.customer_id = r.customer_id 
and r.inventory_id = i.inventory_id and i.film_id = fc.film_id and fc.category_id = c.category_id
and return_date is not null and ct.city like 'A%' and ct.city like '%-%'
group by c.name
order by hours desc
limit 1


