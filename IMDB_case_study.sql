USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM MOVIE;
-- Ans: 7997
SELECT COUNT(*) FROM GENRE;
-- Ans:14662
SELECT COUNT(*) FROM DIRECTOR_MAPPING;
-- Ans:3867
SELECT COUNT(*) FROM NAMES;
-- Ans: 25735
SELECT COUNT(*) FROM RATINGS;
-- Ans:7997
SELECT COUNT(*) FROM ROLE_MAPPING;
-- Ans:15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT count(*)
FROM MOVIE 
WHERE id IS NULL or lower(id) = 'null';
-- Ans: 0

SELECT count(*)
FROM MOVIE 
WHERE title IS NULL or lower(title) = 'null';
-- Ans: 0

SELECT count(*)
FROM MOVIE 
WHERE year IS NULL or lower(year) = 'null';

-- Ans: 0

SELECT count(*)
FROM MOVIE 
WHERE date_published IS NULL or lower(date_published) = 'null';
-- Ans:0

SELECT count(*)
FROM MOVIE 
WHERE duration IS NULL or lower(duration) = 'null';
-- Ans: 0

SELECT count(*)
FROM MOVIE 
WHERE country IS NULL or lower(country) = 'null';
-- Ans: 20

SELECT count(*)
FROM MOVIE 
WHERE worlwide_gross_income IS NULL or lower(worlwide_gross_income) = 'null';
-- Ans: 3724


SELECT count(*)
FROM MOVIE 
WHERE languages IS NULL or lower(languages) = 'null';
-- Ans: 194


SELECT count(*)
FROM MOVIE 
WHERE production_company IS NULL or lower(production_company) = 'null';
-- Ans:528

-- The coulumns having NULL values are country, worlwide_gross_income ,languages and production_company.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- NUMBER OF MOVIES RELEASED EACH YEAR
SELECT year, Count(id) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;
-- 2017 has more number of movies released than 2018 and 2019
-- Total movies release in 2017 are 3052

SELECT Month(date_published) AS MONTH_NUM,Count(*) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num;

-- From the above analysis,  Month of Jan,March,September and October have 800+ movies realeses.
-- March topping the Chat with 824 Movie realeses


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%' OR country LIKE '%USA%' ) AND year = 2019; 
-- India and USA Realeased 1059 Movies in the year 2019

-- Lets Find Individually How many Movies were released in 2019 in USA AND India

SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%' ) AND year = 2019; 

SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%USA%' ) AND year = 2019; 

-- Individually USA Released 758 movies and India released 309



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 

-- 13 genre are available within which all the movies are classifed: 
-- Drama,Fantasy, Thriller,Comedy,Horror,Family,Romance,Adventure,Action,Sci-Fi,Crime,Mystery,Others




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre , count(distinct id) AS number_of_movies
FROM movie
INNER JOIN genre
WHERE movie.id = genre.movie_id
GROUP BY genre;

-- Out of all the Genre Drama tops the chart with 4285 releases.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below;


SELECT COUNT(*) AS One_genre_movies FROM genre WHERE movie_id IN 
(SELECT movie_id
FROM genre
GROUP BY movie_id
HAVING COUNT(*) = 1);

-- There are only 3289 movies that belong to one Genre
-- 11373 movies that belong to more than one genre



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, Round(avg(duration),2) AS Avg_duration
FROM   movie
INNER JOIN genre
ON movie.id = genre.movie_id
GROUP BY genre
ORDER BY Avg_duration DESC ;

-- Action genre has the highest duration of 112.88 minitues, followed by Romance, Crime and Drama.


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     genre,Count(movie_id) AS movie_count ,
Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
FROM       genre                                 
GROUP BY   genre;
-- Thriller genre Ranks 3rd.Fisrt two being Drama and Comedy.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS MIN_AVG_RATING,
       Max(avg_rating)    AS MAX_AVG_RATING,
       Min(total_votes)   AS MIN_TOTAL_VOTES,
       Max(total_votes)   AS MAX_TOTAL_VOTES,
       Min(median_rating) AS MIN_MEDIAN_RATING,
       Max(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings; 



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- RANK function
SELECT title, avg_rating, Rank() OVER(ORDER BY avg_rating DESC) AS genre_rank
FROM ratings
INNER JOIN movie
ON movie.id = ratings.movie_id limit 10;                               



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- Movies with Median Rating 7 are highest in number with a total of 2257 movie count.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


WITH production_company_hit_movie_analysis
     AS (
     SELECT production_company,Count(movie_id) AS MOVIE_COUNT,Rank()OVER(ORDER BY Count(movie_id) DESC ) AS prod_company_rank
	 FROM   ratings 
	 INNER JOIN movie 
	 ON movie.id = ratings.movie_id
	WHERE  avg_rating > 8 AND production_company IS NOT NULL
	GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_analysis
WHERE  prod_company_rank = 1; 

-- Dream Warrior Pictures and National Theatre Live are top production companies that give maxinum number of hit movies


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,Count(movie.id) AS MOVIE_COUNT
FROM   movie
INNER JOIN genre 
ON genre.movie_id = movie.id
INNER JOIN ratings 
ON ratings.movie_id = movie.id
WHERE  year = 2017
AND Month(date_published) = 3
AND country LIKE '%USA%'
AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 


-- 24 movies in Genre Drama were released in 2017 in USA that has more than 1000 votes.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
FROM movie
INNER JOIN ratings
ON movie.id = ratings.movie_id
INNER JOIN genre
ON genre.movie_id = ratings.movie_id
WHERE  avg_rating > 8 AND title LIKE 'THE%'
ORDER BY avg_rating DESC;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating, Count(movie_id) AS movie_count
FROM   movie 
INNER JOIN ratings 
ON ratings.movie_id = movie.id
WHERE  median_rating = 8
AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

--  361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, sum(total_votes) as total_votes
FROM movie 
INNER JOIN ratings
ON movie.id = ratings.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country;

--  Yes German movies have more votes than Italian movies. 
-- Germany 106710 and Italy 77965

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Count(*) AS name_nulls
FROM   names
WHERE  NAME IS NULL;

SELECT Count(*) AS height_nulls
FROM   names
WHERE  height IS NULL;
-- 17335

SELECT Count(*) AS date_of_birth_nulls
FROM   names
WHERE  date_of_birth IS NULL;
-- 13431

SELECT Count(*) AS known_for_movies_nulls
FROM   names
WHERE  known_for_movies IS NULL; 
-- 15226


-- known_for_movies, date_of_birth and height columns have NULL values.



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(
           SELECT     genre,Count(movie.id) AS movie_count ,Rank() OVER(ORDER BY Count(movie.id) DESC) AS genre_rank
           FROM       movie                                 
           INNER JOIN genre                                  
           ON         genre.movie_id = movie.id
           INNER JOIN ratings 
           ON         ratings.movie_id = movie.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     names.name AS director_name ,Count(director_mapping.movie_id) AS movie_count
FROM       director_mapping  
INNER JOIN genre 
using      ( movie_id)
INNER JOIN names 
ON         names.id = director_mapping.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using     (movie_id)
WHERE      avg_rating > 8
GROUP BY   name
ORDER BY   movie_count DESC limit 3 ;

-- James Mangold , Anthony Russo and Soubin Shahir are top three directors.



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT names.name  AS actor_name,Count(movie_id) AS movie_count
FROM   role_mapping 
INNER JOIN movie 
ON movie.id = role_mapping.movie_id
INNER JOIN ratings 
USING(movie_id)
INNER JOIN names 
ON names.id = role_mapping.name_id
WHERE  ratings.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

-- Mammootty and Mohanlal are actors whose movies have an median rating > 8



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     production_company,Sum(total_votes)  AS vote_count,Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                      
INNER JOIN ratings                                     
ON         ratings.movie_id = movie.id
GROUP BY   production_company limit 3;


-- TOP 3 production companies based on number of votes received for their movies are : Marvel Studios, Twentieth Century Fox AND Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actor_analysis
     AS (SELECT names.NAME AS actor_name,total_votes, count(ratings.movie_id) AS movie_count,Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actor_avg_rating
         FROM   movie 
		 INNER JOIN ratings
		 ON movie.id = ratings.movie_id
		 INNER JOIN role_mapping
		 ON movie.id = role_mapping.movie_id
		 INNER JOIN names 
		 ON role_mapping.name_id = names.id
         WHERE  lower(category) = 'actor' AND lower(country) = "india" 
         GROUP  BY NAME,total_votes
         HAVING movie_count >= 1)
SELECT *,Rank()OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_analysis; 


-- Gopi Krishna is the top Actor with an avg_rating of 9.70




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_analysis AS
(
           SELECT  names.NAME AS actress_name,total_votes,Count(ratings.movie_id)  AS movie_count,Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 
           INNER JOIN ratings                                             
           ON         movie.id=ratings.movie_id
           INNER JOIN role_mapping 
           ON         movie.id = role_mapping.movie_id
           INNER JOIN names 
           ON         role_mapping.name_id = names.id
           WHERE      upper(category) = 'ACTRESS' AND  upper(country) = "INDIA" AND  upper(languages) LIKE '%HINDI%'
           GROUP BY   NAME, total_votes
           HAVING     movie_count>=1 )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_analysis LIMIT 5;

-- Mahie Gill is the actress with 9.40 rating



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies AS (
	SELECT DISTINCT title,avg_rating
	FROM   movie 
	INNER JOIN ratings 
	ON ratings.movie_id = movie.id
	INNER JOIN genre 
    USING (movie_id)
	WHERE  genre LIKE 'THRILLER')
    
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
         END AS avg_rating_category
FROM   thriller_movies; 




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,ROUND(AVG(duration),2) AS avg_duration, SUM(ROUND(AVG(duration),2)) 
	   OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	   AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie 
INNER JOIN genre 
ON movie.id= genre.movie_id
GROUP BY genre
ORDER BY genre;




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_genres AS
(
           SELECT     genre,Count(movie.id) AS movie_count ,Rank() OVER(ORDER BY Count(movie.id) DESC) AS genre_rank
           FROM       movie                                 
           INNER JOIN genre                               
           ON         genre.movie_id = movie.id
           INNER JOIN ratings 
           ON         ratings.movie_id = movie.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 ), movie_summary AS
(
           SELECT     genre,year,title AS movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
           FROM       movie                                                                     
           INNER JOIN genre                                                                     
           ON         movie.id = genre.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_genres)
             GROUP BY   genre, year, movie_name,worlwide_gross_income
           )
SELECT *
FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;
-- Top 3 Genres based on most number of movies




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_analysis
     AS (SELECT production_company,Count(*) AS movie_count
         FROM   movie 
		 INNER JOIN ratings 
		 ON ratings.movie_id = movie.id
         WHERE  median_rating >= 8 AND production_company IS NOT NULL AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,Rank() OVER(ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_analysis
LIMIT 2; 

-- Star Cinema and Twentieth Centurauy FOX are top 2 production companies.




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_analysis AS
(
           SELECT     names.name AS actress_name,SUM(total_votes) AS total_votes,Count(ratings.movie_id)  AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 
           INNER JOIN ratings                                               
           ON         movie.id=ratings.movie_id
           INNER JOIN role_mapping 
           ON         movie.id = role_mapping.movie_id
           INNER JOIN names 
           ON         role_mapping.name_id = names.id
           INNER JOIN GENRE 
           ON genre.movie_id = movie.id
           WHERE   category = 'ACTRESS' AND avg_rating>8  AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_analysis LIMIT 3;

-- Parvathy Thiruvothu, Susan Brown and Amanda Lawrence are top 3 actresses.


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT director_mapping.name_id,name,director_mapping.movie_id,duration,ratings.avg_rating,total_votes,movie.date_published,
		   Lead(date_published,1) OVER(partition BY name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM director_mapping                                                                      
           INNER JOIN names                                                                                 
           ON  names.id = director_mapping .name_id
           INNER JOIN movie 
           ON  movie.id = director_mapping .movie_id
           INNER JOIN ratings 
           ON ratings.movie_id = movie.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
       
SELECT  name_id  AS director_id,NAME AS director_name,Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,Min(avg_rating) AS min_rating,Max(avg_rating)  AS max_rating,Sum(duration) AS total_duration
FROM  top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;





