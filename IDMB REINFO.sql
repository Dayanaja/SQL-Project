use imdb;

/*1.	Find the total number of rows in each table of the schema.*/

select 'director_mapping'as tablename ,count(*) as totalrows 
from director_mapping
union all

select 'genre' as tablename , count(*) as totalrows
from genre
union all


select 'movie' as tablename, count(*) as totalrows
from movie
union all

select 'names' as tablename, count(*) as totalrows
from names
union all

select 'ratings' as tablename, count(*) as totalrows 
from ratings
union all

select 'role_mapping' as tablename, count(*) as totalrows
from role_mapping
unionall;

/*2.	Which columns in the movie table have null values*/
 
 
 
 SELECT 'date_published' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
 FROM  MOVIE
 WHERE date_published IS NULL
 UNION ALL 
 
 SELECT 'duration' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
 FROM MOVIE
 WHERE duration IS NULL
 UNION ALL
 
 SELECT 'ID' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
 FROM MOVIE
 WHERE ID IS NULL
 UNION ALL
 
SELECT 'title' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
  FROM MOVIE
  WHERE title IS NULL
  UNION ALL
  
  SELECT'year' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
  FROM MOVIE 
  WHERE year IS NULL
  UNION ALL
  
  SELECT 'COUNTRY' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
  FROM MOVIE
  WHERE country IS NULL
  UNION ALL
  
  SELECT'worlwide_gross_income' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
  FROM MOVIE
  WHERE worlwide_gross_income IS NULL
  UNION ALL 
  
  SELECT 'languages' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
  FROM MOVIE 
  WHERE languages IS NULL
  UNION ALL
  
  SELECT'production_company' AS TABLE_NAME, COUNT(*) AS NULL_COUNT
  FROM MOVIE 
  WHERE production_company IS NULL;
  
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
 
 SELECT* FROM GENRE;
 
 SELECT COUNT(*) AS single_genre_movies
FROM (
    SELECT MOVIE_ID
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
 
 