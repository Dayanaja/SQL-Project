use imdb;

/*1.	Find the total number of rows in each table of the schema.*/

select 'director_mapping'as tablename,count(*) as totalrows from director_mapping
union all
select'genre'as tablename,count(*)as totalrows from genre
union all
select'movie'as tablename,count(*)as totalrows from movie
union all
select'names'as tablename,count(*)as totalrows from names
union all
select'ratings'as tablename,count(*)as totalrows from ratings
union all
select'role_mapping'as tablename,count(*)as totalrows from role_mapping
unionall;

/*2.	Which columns in the movie table have null values*/
 
SELECT 'date_published' AS TABLE_NAME,COUNT(*) AS NULL_COUNT FROM  MOVIE WHERE date_published IS NULL
UNION ALL 
SELECT 'duration' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE duration IS NULL
UNION ALL
SELECT 'ID' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE ID IS NULL
UNION ALL
SELECT 'title' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE title IS NULL
UNION ALL
SELECT'year' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE year IS NULL
UNION ALL
SELECT 'COUNTRY' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE country IS NULL
UNION ALL
SELECT'worlwide_gross_income' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE worlwide_gross_income IS NULL
UNION ALL 
SELECT 'languages' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE languages IS NULL
UNION ALL
SELECT'production_company' AS TABLE_NAME, COUNT(*) AS NULL_COUNT FROM MOVIE WHERE production_company IS NULL;
  
/*  3.Find the total number of movies released each year. How does the trend look month-wise*/

SELECT YEAR AS YEARS, COUNT(*) AS TOTAL_MOVIES
FROM MOVIE 
GROUP BY YEARS;

SELECT MONTH (date_published) AS MONTH , COUNT(*) TOTAL_MOVIES
FROM MOVIE 
GROUP BY MONTH 
ORDER BY MONTH;

/*4.	How many movies were produced in the USA or India in the year 2019*/

SELECT *FROM MOVIE;

SELECT YEAR, COUNTRY, COUNT(*) AS TOTAL_MOVIES
FROM MOVIE
WHERE COUNTRY in ('USA' , 'INDIA') AND YEAR=2019
GROUP BY COUNTRY;
 
 /*5.	Find the unique list of genres present in the dataset and how many movies belong to only one genre.*/
 
 SELECT DISTINCT GENRE FROM GENRE;
 
SELECT COUNT(*) AS single_genre_movies
FROM (SELECT MOVIE_ID
    FROM GENRE
    GROUP BY MOVIE_ID
    HAVING COUNT(GENRE) = 1
) AS Single_Genre_Movies;
 
 /*6.	Which genre had the highest number of movies produced overall*/
 
 SELECT GENRE AS GENRE, COUNT(*) TOTAL_MOVIES
 FROM GENRE
 GROUP BY GENRE
 ORDER BY TOTAL_MOVIES DESC LIMIT 1;
 
 /*7.	What is the average duration of movies in each genre*/
 
 SELECT G.GENRE, AVG(M.duration) AS AVG_DURATION
 FROM GENRE G
 JOIN MOVIE M ON M.ID= G.MOVIE_ID
 GROUP BY GENRE 
 ORDER BY AVG_DURATION DESC;
 
 /*8.	Identify actors or actresses who have worked in more than three movies with an average rating below 5*/
 
 SELECT*FROM MOVIE;
 SELECT*FROM NAMES;
 
 SELECT N.NAME, COUNT(RO.MOVIE_ID) AS LOW_RATED_MOVIES
 FROM NAMES N
 JOIN ROLE_MAPPING RO ON RO.NAME_ID=N.ID
 JOIN RATINGS RA ON RA.MOVIE_ID= RO.MOVIE_ID
 WHERE RA.AVG_RATING<5
 GROUP BY RO.NAME_ID
 HAVING COUNT(RO.MOVIE_ID)>3
 ORDER BY LOW_RATED_MOVIES DESC;
 
 /*9.	Find the minimum and maximum values in each column of the ratings table except the movie_id column*/
 
SELECT 
    MIN(avg_rating) AS min_rating, MAX(avg_rating) AS max_rating,
    MIN(total_votes) AS min_votes, MAX(total_votes) AS max_votes,
    MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM ratings;
 
 SELECT*FROM RATINGS;
 
/* 10.	Which are the top 10 movies based on average rating*/

select m.title, r.avg_rating
from movie m
join ratings r on r.movie_id=m.id
order by r.avg_rating desc
limit 10;
 
 /*11.Summarise the ratings table based on the movie counts by median ratings*/
 
 select median_rating, count(movie_id) as movie_count
 from ratings
 group by median_rating
 order by median_rating asc;
 
 /*12.	How many movies released in each genre during March 2017 in the USA had more than 1,000 votes*/
 
 select g.genre, count(r.movie_id) as total_movies
 from genre g
 join ratings r on r.movie_id=g.movie_id
 join movie m on m.id=r.movie_id
 where m.date_published between '2017-03-01' and '2017-03-31' and m.country='usa' and r.total_votes>1000
 group by genre
 order by total_movies desc;
 
/* 13.	Find movies of each genre that start with the word ‘The ’ and which have an average rating > 8.*/

select g.genre,m.title,r.avg_rating
from genre g
join movie m on m.id=g.movie_id
join ratings r on r.movie_id=m.id 
where m.title like 'The%' and r.avg_rating>8
order by g.genre;

/*14.	Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8*/

select count(r.movie_id) as total_movies
from ratings r
join movie m on m.id=r.movie_id
where m.date_published between '2018-04-01' and '2019-04-01' and median_rating=8;

/*15.	Do German movies get more votes than Italian movies*/

select*from movie;

select m.country , sum(r.total_votes) as total_votes
from movie m 
join ratings r on r.movie_id= m.id
where m .country in ('germany', 'italy')
group by m.country;

/*16.	Which columns in the names table have null values*/

select 'id' as id, count(*) as null_id
from names where id is null
union all
select 'name' as name, count(*) as null_name
from names where name is null
union all
select'height' as height, count(*) as null_height
from names where height is null 
union all 
select 'date_of_birth' as date_of_birth, count(*) as null_date_of_birth
from names where date_of_birth is null
union all 
select 'known_for_movies' as known_for_movies, count(*) as null_known_for_movies
from names where known_for_movies is null;

/*17.	Who are the top two actors whose movies have a median rating >= 8*/

select n.name, count(*) as total_movies
from names n 
join role_mapping ro on ro.name_id =n.id
join ratings r on r.movie_id = ro.movie_id
where ro.category='actor' and r.median_rating>=8
group by n.name
order by total_movies desc 
limit 2;

/*18.	Which are the top three production houses based on the number of votes received by their movies*/

select m.production_company, sum(total_votes) as total_votes
from movie m 
join ratings r on r.movie_id=m.id 
group by m.production_company 
order by total_votes desc
limit 3;

/*19.	How many directors worked on more than three movies*/

select n.name AS name, count(d.movie_id) as total_movies
from names n
join director_mapping d on d.name_id = n.id
group by n.name
having total_movies > 3
order by total_movies DESC;

/*20.	Find the average height of actors and actresses separately*/

select ro.category, round(avg(n.height),2)as average_height 
from role_mapping ro
join names n on n.id=ro.name_id 
group by ro.category 
order by average_height desc;

/*21.	Identify the 10 oldest movies in the dataset along with its title, country, and director*/

select m.title, m.country,n.name as director_name,m.date_published
from movie m 
join director_mapping d on d.movie_id= m.id
join names n on n.id= d.name_id
order by m.date_published asc,m.country limit 10;

/*22.	List the top 5 movies with the highest total votes and their genres*/

select m.title, g.genre, r.total_votes
from movie m
join genre g on g.movie_id=m.id
join ratings r on r.movie_id= g.movie_id
order by genre, total_votes desc limit 5;

/*23.	Find the movie with the longest duration, along with its genre and production company*/

select m.title,m.duration, g.genre,m.production_company
from movie m 
join genre g on g.movie_id= m.id
order by duration desc
limit 1;

/*24.	Determine the total votes received for each movie released in 2018*/

select m.title, sum(total_votes) as total_votes
from movie m 
join ratings r on r.movie_id=m.id
where m.year=2018
group by m.title
order by total_votes desc;

/*25.	Find the most common language in which movies were produced*/

select languages, count(id) as total_movies
from movie
group by languages
order by total_movies desc
limit 1;
