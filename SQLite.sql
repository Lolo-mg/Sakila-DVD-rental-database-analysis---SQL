/* Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out. */


WITH List_of_moives AS (
SELECT F.title movie, G.name Catgory_name, R.rental_id rental_id
FROM film_category FG
JOIN category G
ON G.category_id = FG.category_id
JOIN film F
ON F.film_id = FG.film_id
JOIN inventory I
ON I.film_id = F.film_id
JOIN rental R
ON R.inventory_id = I.inventory_id
WHERE G.name = 'Animation'  OR G.name = 'Children'
OR G.name = 'Classics' OR G.name = 'Comedy' OR G.name = 'Family' OR G.name = 'Music' )

SELECT DISTINCT(movie), Catgory_name, COUNT(rental_id) OVER(PARTITION BY movie) AS rental_count
FROM List_of_moives
ORDER BY 2,1


/* SECOND*/
SELECT F.title, G.name, F.rental_duration, NTILE(4) OVER (ORDER BY F.rental_duration) AS standard_quartile
FROM film_category FG
JOIN category G
ON G.category_id = FG.category_id
JOIN film F
ON F.film_id = FG.film_id
WHERE G.name = 'Animation'  OR G.name = 'Children'
OR G.name = 'Classics' OR G.name = 'Comedy' OR G.name = 'Family' OR G.name = 'Music'
ORDER BY 3

/*3*/
WITH list_movies AS(
SELECT F.title, G.name, F.rental_duration, NTILE(4) OVER (ORDER BY F.rental_duration) AS standard_quartile
FROM film_category FG
JOIN category G
ON G.category_id = FG.category_id
JOIN film F
ON F.film_id = FG.film_id
WHERE G.name = 'Animation'  OR G.name = 'Children'
OR G.name = 'Classics' OR G.name = 'Comedy' OR G.name = 'Family' OR G.name = 'Music'
)

SELECT name, standard_quartile,
CASE WHEN standard_quartile = 1 THEN COUNT(*)
     WHEN standard_quartile = 2 THEN COUNT(*)
     WHEN standard_quartile = 3 THEN COUNT(*)
     WHEN standard_quartile = 4 THEN COUNT(*)
     END AS counting
FROM list_movies
GROUP BY 1,2
ORDER BY 1,2
/*4*/
SELECT DATE_PART('month',R.rental_date) AS Rental_month,
DATE_PART('year',R.rental_date) AS Rental_year,
S.store_id ,
COUNT(R.rental_id) rental_count
FROM rental R
JOIN staff AS ST 
ON R.staff_id = ST.staff_id
JOIN store AS S 
ON S.store_id = ST.store_id
GROUP BY 1,2,3
ORDER BY 4 DESC