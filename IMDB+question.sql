USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM [dbo].[director_mapping]; -- TOTAL ROWS = 3867

SELECT COUNT(*) FROM [dbo].[genre]; -- TOTAL ROWS = 14662

SELECT COUNT(*) FROM [dbo].[movie]; -- TOTAL ROWS = 7997

SELECT COUNT(*) FROM [dbo].[names]; -- TOTAL ROWS = 25735

SELECT COUNT(*) FROM [dbo].[ratings]; -- TOTAL ROWS = 7997

SELECT COUNT(*) FROM [dbo].[role_mapping]; -- TOTAL ROWS = 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT   SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_NULLS
	   , SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_NULLS
	   , SUM(CASE WHEN [year] IS NULL THEN 1 ELSE 0 END) AS year_NULLS
	   , SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_NULLS
	   , SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_NULLS
	   , SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_NULLS
	   , SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_NULLS
	   , SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_NULLS
	   , SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_NULLS
FROM movie

-- There are 4 columns having NULL values. country, worlwide_gross_income, languages and production_company.




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

--FIRST PART OF THE QUERY

select		  year as [Year]
			, count(title) as number_of_movies from movie 
group by	  year 
order by	  year
;

--SECOND PART OF THE QUERY

select		MONTH(date_published) as month_num
			, COUNT(title) as number_of_movies
from		movie
group by	MONTH(date_published)
order by	1










/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT		count(distinct id) as num_movies 
FROM		movie
WHERE		year ='2019' 
			and (country like '%USA%' or country like '%India%')







/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT DISTINCT genre from genre;







/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH genre_rank
AS(
		SELECT		genre
					, COUNT(genre) AS movie_count
					, RANK() OVER(ORDER BY COUNT(genre) DESC) AS rank_genre
		FROM		genre
		GROUP BY	genre
)
SELECT		genre	
			,movie_count
FROM		genre_rank
WHERE		rank_genre=1
;







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


WITH genre_cte 
AS(
		SELECT		movie_id
					, COUNT(genre) AS genre_count
		FROM		genre
		GROUP BY	movie_id
		HAVING		COUNT(genre) =1
)
SELECT	COUNT(movie_id) AS single_genre_movie_count
FROM	genre_cte
;







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

SELECT		genre
			, ROUND(AVG(duration),2) AS avg_duration
FROM		genre AS g
INNER JOIN	movie AS m ON g.movie_id=m.id
GROUP BY	genre
ORDER BY	genre;







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


WITH genre_rank
AS(
		SELECT		genre
					,COUNT(movie_id) AS movie_count
					,RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
		FROM		genre
		GROUP BY	genre
)

SELECT	* 
FROM	genre_rank
WHERE	genre='Thriller';







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

SELECT 
		MIN(avg_rating) AS min_avg_rating
		,MAX(avg_rating) AS max_avg_rating
		,MIN(total_votes) AS min_total_votes
		,MAX(total_votes) AS max_total_votes
		,MIN(median_rating) AS min_median_rating
		,MAX(median_rating) AS max_median_rating
FROM ratings;




    

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

WITH genre_rank
AS(
		SELECT		m.title AS title
					, avg_rating
					,RANK() OVER(ORDER BY avg_rating DESC) AS rank_mov
		FROM		ratings AS r
		INNER JOIN	movie AS m ON m.id = r.movie_id
)
SELECT	* 
FROM	genre_rank
WHERE	rank_mov<=10;






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


SELECT		median_rating
			,COUNT(median_rating) AS movie_count
FROM		ratings
GROUP BY	median_rating
ORDER BY	1 ASC;







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

WITH ranking_CTE
AS(
		SELECT		production_company
					, COUNT(id) AS movie_count
					, RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
		FROM		movie AS m
		INNER JOIN	ratings AS r ON m.id=r.movie_id
		WHERE		avg_rating>8 
					AND production_company IS NOT NULL
		GROUP BY	production_company
)
SELECT	* 
FROM	ranking_CTE
WHERE	prod_company_rank=1;







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

SELECT		genre
			,COUNT(r.movie_id) AS movie_count
FROM		genre g
INNER JOIN	movie AS m ON m.id=g.movie_id
INNER JOIN	ratings AS r ON m.id=r.movie_id
WHERE		MONTH(date_published)='3' 
			AND YEAR(date_published)='2017'
			AND country= 'USA' 
			AND total_votes>1000
GROUP BY	genre;







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

SELECT		title
			,avg_rating
			,max(genre)
FROM		movie m
INNER JOIN	ratings r ON r.movie_id=m.id
INNER JOIN	genre g ON g.movie_id=m.id
WHERE		title LIKE 'The%' 
			AND avg_rating>8
GROUP BY	title,avg_rating
ORDER BY	avg_rating DESC;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
			COUNT(title) AS movie_cnt
FROM		movie m
INNER JOIN	ratings r ON m.id=r.movie_id
WHERE		median_rating=8
			AND date_published BETWEEN '2018-04-01' AND '2019-04-01';






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT		country
			,sum(total_votes) as total_votes
FROM		movie m
INNER JOIN	ratings r ON m.id=r.movie_id
WHERE		(country = 'Germany' or country = 'Italy')
GROUP BY	country;



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

SELECT
		SUM(CASE WHEN [name] IS NULL THEN 1 ELSE 0 END) as name_nulls
		,SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) as height_nulls
		,SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) as date_of_birth_nulls
		,SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) as known_for_movies_nulls 
FROM	names;






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

WITH genre_cte
AS(
		SELECT		genre
					,COUNT(title) AS movie_count
					,RANK() OVER(ORDER BY COUNT(title) DESC) AS genre_rank
		FROM		movie AS m
		INNER JOIN	ratings r ON r.movie_id=m.id
		INNER JOIN	genre g ON g.movie_id=m.id
		WHERE		avg_rating>8
		GROUP BY	genre
),
directors_cte
AS(
SELECT		n.[name] AS director_name
			,COUNT(g.movie_id) AS movie_count
			,RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS dir_rank
FROM		names AS n 
INNER JOIN	director_mapping AS dm ON n.id=dm.name_id 
INNER JOIN	genre AS g ON dm.movie_id=g.movie_id 
INNER JOIN	ratings r ON r.movie_id= g.movie_id,
			genre_cte gc
WHERE 
			g.genre IN (gc.genre) 
			AND avg_rating>8 
			AND gc.genre_rank<4
GROUP BY	n.[name]
)
SELECT	*
FROM	directors_cte
WHERE	dir_rank<=3;







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


WITH actor_cte
AS(
		SELECT		[name] AS actor_name
					,COUNT(r.movie_id) AS movie_count
					,RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actor_rank
		FROM		names n
		INNER JOIN	role_mapping rmap ON rmap.name_id= n.id
		INNER JOIN	ratings r ON r.movie_id= rmap.movie_id
		WHERE		median_rating>=8
		GROUP BY	[name]
)
SELECT 
		actor_name
		,movie_count
FROM	actor_cte
WHERE	actor_rank<3;





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

WITH vote_cte 
AS(
		SELECT		production_company
					,SUM(total_votes) AS vote_count
					,RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
		FROM		movie m
		INNER JOIN	ratings r ON r.movie_id=m.id
		GROUP BY	production_company
)
SELECT 
		production_company
		,vote_count
		,prod_comp_rank
FROM	vote_cte
WHERE	prod_comp_rank<4;








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

SELECT		[name] AS actor_name
			,SUM(total_votes) AS total_votes
			,COUNT(m.id) AS movie_count
			,ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating
			,RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actor_rank
FROM		movie m 
INNER JOIN	ratings r ON m.id=r.movie_id 
INNER JOIN	role_mapping AS rmap ON m.id=rmap.movie_id 
INNER JOIN	names AS n ON rmap.name_id=n.id
WHERE		category='actor'
			AND country= 'india'
GROUP BY	[name]
HAVING		COUNT(m.id)>=5;







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

WITH actress_ranking_cte
AS(
		SELECT		[name] AS actress_name
					,SUM(total_votes) AS total_votes
					,COUNT(m.id) AS movie_count
					,ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating
					,RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actress_rank
		FROM		movie m 
		INNER JOIN	ratings r ON m.id=r.movie_id 
		INNER JOIN	role_mapping AS rmap ON m.id=rmap.movie_id 
		INNER JOIN	names AS n ON rmap.name_id=n.id
		WHERE		category='actress' 
					AND country= 'india' 
					AND languages= 'hindi'
		GROUP BY	name
		HAVING		COUNT(m.id)>=3
)
SELECT	*
FROM	actress_ranking_cte
WHERE	actress_rank<=5;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


WITH thriller_movies_cte
AS(
		SELECT		title
					,avg_rating
		FROM		genre as g 
		INNER JOIN	movie m ON g.movie_id= m.id 
		INNER JOIN	ratings r ON m.id= r.movie_id
		WHERE		genre= 'thriller'
)
SELECT *
,(CASE
	WHEN avg_rating >8 THEN 'Superhit movie'
	WHEN avg_rating >= 7 and avg_rating<=8 THEN 'Hit movie'
	WHEN avg_rating >=5 AND avg_rating < 7 THEN 'One-time-watch movie'
	WHEN avg_rating <5 THEN 'Flop movie'END
)			AS Class
FROM		thriller_movies_cte
ORDER BY	title;






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

SELECT		genre
			,ROUND(AVG(duration),2) AS avg_duration
			,SUM(AVG(duration)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration
			,AVG(AVG(duration)) OVER(ORDER BY genre ROWS 13 PRECEDING) AS moving_avg_duration
FROM		movie m 
INNER JOIN	genre g ON m.id= g.movie_id
GROUP BY	genre
ORDER BY	genre;







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

-- Top 3 Genres based on most number of movies


WITH genre_cte
AS(
		SELECT		genre
					,COUNT(title) AS title_count
					,RANK() OVER(ORDER BY COUNT(title) DESC) AS genre_rank
		FROM		movie m
		INNER JOIN	ratings r ON r.movie_id=m.id
		INNER JOIN	genre g ON g.movie_id=m.id
		GROUP BY	genre
),
highest_gross_cte
AS(
		SELECT		genre
					,year
					,title AS movie_name
					,worlwide_gross_income
					,RANK() OVER (PARTITION BY YEAR ORDER BY worlwide_gross_income DESC) AS movie_rank
		FROM		movie AS m 
		INNER JOIN	genre AS g ON m.id= g.movie_id
		WHERE		genre IN (SELECT genre FROM genre_cte where genre_rank <4)
)
SELECT	*
FROM	highest_gross_cte
WHERE	movie_rank<=5;







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

WITH ranking
AS(
		SELECT		production_company
					,COUNT(m.id) AS movie_count
					,RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
		FROM		movie m 
		INNER JOIN	ratings r ON m.id=r.movie_id
		WHERE		median_rating>=8
					AND production_company IS NOT NULL
					AND CHARINDEX(',', languages)>0
		GROUP BY	production_company
)
SELECT * FROM ranking
WHERE prod_comp_rank<3;






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

WITH actress_cte 
AS(
		SELECT			name AS actress_name
						,SUM(total_votes) AS total_votes
						,COUNT(m.id) AS movie_count
						,ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating
						,RANK() OVER(ORDER BY COUNT(m.id) DESC) AS actress_rank
		FROM			genre g 
		INNER JOIN		movie m ON g.movie_id= m.id 
		INNER JOIN		ratings r ON m.id= r.movie_id 
		INNER JOIN		role_mapping rmap ON m.id=rmap.movie_id 
		INNER JOIN		names n ON rmap.name_id=n.id
		WHERE			genre= 'drama' 
						AND category= 'actress' 
						AND avg_rating>8
		GROUP BY		[name]
)
SELECT * 
FROM	actress_cte
WHERE	actress_rank<=3;






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

WITH top_directors AS
(
		SELECT		name_id AS director_id
					, [name] AS director_name
					, dir.movie_id
					, duration
					,avg_rating AS avg_rating
					, total_votes AS total_votes
					, avg_rating * total_votes AS rating_count
					,date_published
					,LEAD(date_published, 1) OVER (PARTITION BY name ORDER BY date_published, name) AS next_publish_date
		FROM		director_mapping AS dir
		INNER JOIN	names nm ON dir.name_id = nm.id
		INNER JOIN	movie mov ON dir.movie_id = mov.id 
		INNER JOIN	ratings rt ON mov.id = rt.movie_id
)

SELECT top 9
			director_id
			, director_name
			,COUNT(movie_id) AS number_of_movies
			,case when COUNT(movie_id)>1 
					then ROUND(SUM(DATEDIFF(day,Next_publish_date, date_published))/(COUNT(movie_id)-1),0) * -1
					else 0 
					end AS avg_inter_movie_days
			,CAST(SUM(rating_count)/SUM(total_votes)AS DECIMAL(4,2)) AS avg_rating
			,SUM(total_votes) AS total_votes, MIN(avg_rating) AS min_rating, MAX(avg_Rating) AS max_rating
			,SUM(duration) AS total_duration
FROM		top_directors
GROUP BY	director_id, director_name
ORDER BY	number_of_movies DESC
;





