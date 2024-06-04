USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM DIRECTOR_MAPPING;

SELECT COUNT(*) FROM GENRE ;

SELECT COUNT(*) FROM  MOVIE;

SELECT COUNT(*) FROM  NAMES;

SELECT COUNT(*) FROM  RATINGS;

SELECT COUNT(*) FROM  ROLE_MAPPING;










-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'movie' 
    AND IS_NULLABLE = 'YES';









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
SELECT YEAR(date_published) AS "year", COUNT(*) AS number_of_movies
FROM movie
GROUP BY YEAR(date_published)
ORDER BY "year";

SELECT 
    MONTH(date_published) AS month_num, 
    COUNT(*) AS number_of_movies
FROM 
    movie
GROUP BY 
    month_num
ORDER BY 
    month_num;








/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) AS movie_count
FROM movie
WHERE (country = 'USA' OR country = 'India')
    AND YEAR(date_published) = 2019;











/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT
    g.genre,
    COUNT(*) AS movie_count
FROM
    genre g
GROUP BY
    g.genre
ORDER BY
    movie_count DESC
LIMIT 1;










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) AS single_genre_movies
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) AS single_genre_movies;










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
SELECT
    g.genre,
    AVG(m.duration) AS avg_duration
FROM
    movie m
    JOIN genre g ON m.id = g.movie_id
GROUP BY
    g.genre;









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
SELECT
    genre,
    movie_count,
    genre_rank
FROM (
    SELECT
        genre,
        COUNT(*) AS movie_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM
        genre
    GROUP BY
        genre
) AS genre_counts
WHERE
    genre = 'thriller';











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
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;






    

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
SELECT
    title,
    avg_rating,
    ROW_NUMBER() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM
    movie
    JOIN ratings ON movie.id = ratings.movie_id
ORDER BY
    avg_rating DESC
LIMIT 10;








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
SELECT
    median_rating,
    COUNT(*) AS movie_count
FROM (
    SELECT
        AVG(avg_rating) AS median_rating
    FROM
        ratings
    GROUP BY
        movie_id
    ) AS median_ratings
GROUP BY
    median_rating;











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
SELECT
    m.production_company AS production_company,
    COUNT(DISTINCT m.id) AS movie_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT m.id) DESC) AS prod_company_rank
FROM
    movie m
    JOIN ratings r ON m.id = r.movie_id
WHERE
    r.avg_rating > 8
GROUP BY
    m.production_company
ORDER BY
    movie_count DESC
LIMIT 1;









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
SELECT
    g.genre,
    COUNT(DISTINCT m.id) AS movie_count
FROM
    movie m
    JOIN ratings r ON m.id = r.movie_id
    JOIN genre g ON m.id = g.movie_id
WHERE
    m.country = 'USA'
    AND m.date_published >= '2017-03-01'
    AND m.date_published <= '2017-03-31'
    AND r.total_votes > 1000
GROUP BY
    g.genre;










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
SELECT
    m.title,
    r.avg_rating,
    g.genre
FROM
    movie m
    JOIN ratings r ON m.id = r.movie_id
    JOIN genre g ON m.id = g.movie_id
WHERE
    m.title LIKE 'The%'
    AND r.avg_rating > 8
ORDER BY
    g.genre, r.avg_rating DESC;









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT median_rating, Count(*) AS movie_count
FROM movie AS M
       INNER JOIN ratings AS R
       ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;









-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT
    CASE
        WHEN SUM(CASE WHEN m.country = 'Germany' THEN r.total_votes ELSE 0 END) > SUM(CASE WHEN m.country = 'Italy' THEN r.total_votes ELSE 0 END) THEN 'German movies get more votes'
        WHEN SUM(CASE WHEN m.country = 'Germany' THEN r.total_votes ELSE 0 END) < SUM(CASE WHEN m.country = 'Italy' THEN r.total_votes ELSE 0 END) THEN 'Italian movies get more votes'
        ELSE 'German and Italian movies have the same number of votes'
    END AS vote_comparison
FROM
    movie m
    JOIN ratings r ON m.id = r.movie_id
WHERE
    m.country IN ('Germany', 'Italy');








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
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
    names;








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
WITH TopGenres AS (
    SELECT
        g.genre
    FROM
        genre g
        JOIN movie m ON g.movie_id = m.id
        JOIN ratings r ON m.id = r.movie_id
    WHERE
        r.avg_rating > 8
    GROUP BY
        g.genre
    ORDER BY
        COUNT(DISTINCT m.id) DESC
    LIMIT 3
),
TopDirectors AS (
    SELECT
        dm.name_id AS director_id,
        COUNT(DISTINCT m.id) AS movie_count
    FROM
        director_mapping dm
        JOIN movie m ON dm.movie_id = m.id
        JOIN ratings r ON m.id = r.movie_id
        JOIN genre g ON m.id = g.movie_id
    WHERE
        r.avg_rating > 8
        AND g.genre IN (SELECT genre FROM TopGenres)
    GROUP BY
        dm.name_id
)
SELECT
    nm.name AS director_name,
    td.movie_count
FROM
    TopDirectors td
    JOIN names nm ON td.director_id = nm.id
ORDER BY
    td.movie_count DESC
LIMIT 3;










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
SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 












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
WITH ProductionHouseVotes AS (
    SELECT
        m.production_company AS production_company,
        SUM(r.total_votes) AS vote_count
    FROM
        movie m
        JOIN ratings r ON m.id = r.movie_id
    WHERE
        m.production_company IS NOT NULL
    GROUP BY
        m.production_company
),
TopProductionHouses AS (
    SELECT
        production_company,
        vote_count,
        ROW_NUMBER() OVER (ORDER BY vote_count DESC) AS prod_comp_rank
    FROM
        ProductionHouseVotes
)
SELECT
    production_company,
    vote_count,
    prod_comp_rank
FROM
    TopProductionHouses
WHERE
    prod_comp_rank <= 3;










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
WITH IndianActorMovies AS (
    SELECT
        nm.name AS actor_name,
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes
    FROM
        names nm
        JOIN role_mapping rm ON nm.id = rm.name_id
        JOIN movie m ON rm.movie_id = m.id
        JOIN ratings r ON m.id = r.movie_id
    WHERE
        rm.category = 'actor'
        AND nm.name IS NOT NULL
        AND m.country = 'India'
),
ActorStats AS (
    SELECT
        actor_name,
        COUNT(DISTINCT movie_id) AS movie_count,
        SUM(avg_rating * total_votes) / SUM(total_votes) AS actor_avg_rating,
        SUM(total_votes) AS total_votes
    FROM
        IndianActorMovies
    GROUP BY
        actor_name
    HAVING
        movie_count >= 5
),
TopActors AS (
    SELECT
        actor_name,
        total_votes,
        movie_count,
        actor_avg_rating,
        ROW_NUMBER() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
    FROM
        ActorStats
)
SELECT
    actor_name,
    total_votes,
    movie_count,
    actor_avg_rating,
    actor_rank
FROM
    TopActors
WHERE
    actor_rank = 1;









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
WITH IndianActressMovies AS (
    SELECT
        nm.name AS actress_name,
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes
    FROM
        names nm
        JOIN role_mapping rm ON nm.id = rm.name_id
        JOIN movie m ON rm.movie_id = m.id
        JOIN ratings r ON m.id = r.movie_id
    WHERE
        rm.category = 'actress'
        AND nm.name IS NOT NULL
        AND m.country = 'India'
),
ActressStats AS (
    SELECT
        actress_name,
        COUNT(DISTINCT movie_id) AS movie_count,
        SUM(avg_rating * total_votes) / SUM(total_votes) AS actress_avg_rating,
        SUM(total_votes) AS total_votes
    FROM
        IndianActressMovies
    GROUP BY
        actress_name
    HAVING
        movie_count >= 3
),
TopActresses AS (
    SELECT
        actress_name,
        total_votes,
        movie_count,
        actress_avg_rating,
        ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
    FROM
        ActressStats
)
SELECT
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM
    TopActresses
WHERE
    actress_rank <= 5
ORDER BY
actress_rank; 










/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT
    m.title AS movie_name,
    AVG(r.avg_rating) AS avg_rating,
    CASE
        WHEN AVG(r.avg_rating) > 8 THEN 'Superhit'
        WHEN AVG(r.avg_rating) BETWEEN 7 AND 8 THEN 'Hit'
        WHEN AVG(r.avg_rating) BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS classification
FROM
    movie m
    JOIN genre g ON m.id = g.movie_id
    JOIN ratings r ON m.id = r.movie_id
WHERE
    g.genre = 'Thriller'
GROUP BY
    m.title;









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
WITH GenreAvgDuration AS (
    SELECT
        g.genre,
        AVG(m.duration) AS avg_duration
    FROM
        movie m
        JOIN genre g ON m.id = g.movie_id
    GROUP BY
        g.genre
),
GenreDurations AS (
    SELECT
        genre,
        avg_duration,
        SUM(avg_duration) OVER (PARTITION BY genre ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_duration,
        AVG(avg_duration) OVER (PARTITION BY genre ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration
    FROM
        GenreAvgDuration
)
SELECT
    genre,
    avg_duration,
    running_total_duration,
    moving_avg_duration
FROM
    GenreDurations
ORDER BY
    genre;









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
WITH GenreCounts AS (
    SELECT
        g.genre,
        COUNT(m.id) AS movie_count
    FROM
        genre g
        JOIN movie m ON g.movie_id = m.id
    GROUP BY
        g.genre
    ORDER BY
        movie_count DESC
    LIMIT 3
),
TopGenres AS (
    SELECT
        g.genre
    FROM
        GenreCounts g
),
TopMovies AS (
    SELECT
        m.id AS movie_id,
        g.genre,
        m.title AS movie_name,
        m.year,
        m.worlwide_gross_income
    FROM
        movie m
        JOIN genre g ON m.id = g.movie_id
        JOIN TopGenres tg ON g.genre = tg.genre
),
TopMoviesByYear AS (
    SELECT
        genre,
        year,
        movie_name,
        worlwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY genre, year ORDER BY worlwide_gross_income DESC) AS movie_rank
    FROM
        TopMovies
)
SELECT
    genre,
    year,
    movie_name,
    worlwide_gross_income,
    movie_rank
FROM
    TopMoviesByYear
WHERE
    movie_rank <= 5
ORDER BY
    genre, year, movie_rank;










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
WITH MultilingualMovies AS (
    SELECT
        m.id AS movie_id,
        m.production_company,
        r.median_rating,
        m.languages
    FROM
        movie m
        JOIN ratings r ON m.id = r.movie_id
    WHERE
        r.median_rating >= 8
),
FilteredMultilingualMovies AS (
    SELECT
        movie_id,
        production_company,
        median_rating,
        languages
    FROM
        MultilingualMovies
    WHERE
        LENGTH(languages) - LENGTH(REPLACE(languages, ',', '')) + 1 > 1
),
MultilingualHits AS (
    SELECT
        production_company,
        COUNT(movie_id) AS movie_count
    FROM
        FilteredMultilingualMovies
    GROUP BY
        production_company
),
TopProductionHouses AS (
    SELECT
        production_company,
        movie_count,
        ROW_NUMBER() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM
        MultilingualHits
)
SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM
    TopProductionHouses
WHERE
    prod_comp_rank <= 2
ORDER BY
    prod_comp_rank;













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
WITH DramaMovies AS (
    SELECT
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes
    FROM
        movie m
        JOIN ratings r ON m.id = r.movie_id
        JOIN genre g ON m.id = g.movie_id
    WHERE
        g.genre = 'Drama' AND r.avg_rating > 8
),
ActressMovies AS (
    SELECT
        rm.name_id AS actress_id,
        n.name AS actress_name,
        dm.movie_id,
        dm.avg_rating,
        dm.total_votes
    FROM
        role_mapping rm
        JOIN names n ON rm.name_id = n.id
        JOIN DramaMovies dm ON rm.movie_id = dm.movie_id
    WHERE
        rm.category = 'actress'
),
ActressStats AS (
    SELECT
        am.actress_id,
        am.actress_name,
        COUNT(am.movie_id) AS movie_count,
        SUM(am.total_votes) AS total_votes,
        AVG(am.avg_rating) AS actress_avg_rating
    FROM
        ActressMovies am
    GROUP BY
        am.actress_id, am.actress_name
),
TopActresses AS (
    SELECT
        actress_id,
        actress_name,
        total_votes,
        movie_count,
        actress_avg_rating,
        ROW_NUMBER() OVER (ORDER BY movie_count DESC) AS actress_rank
    FROM
        ActressStats
)
SELECT
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM
    TopActresses
WHERE
    actress_rank <= 3
ORDER BY
    actress_rank;









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

WITH DirectorMovies AS (
    SELECT
        dm.name_id AS director_id,
        n.name AS director_name,
        COUNT(m.id) AS number_of_movies,
        AVG(r.avg_rating) AS average_movie_ratings,
        SUM(r.total_votes) AS total_votes,
        MIN(r.median_rating) AS min_rating,
        MAX(r.median_rating) AS max_rating,
        SUM(m.duration) AS total_movie_durations
    FROM
        director_mapping dm
        JOIN movie m ON dm.movie_id = m.id
        JOIN ratings r ON m.id = r.movie_id
        JOIN names n ON dm.name_id = n.id
    GROUP BY
        dm.name_id, n.name
),
DirectorMovieDates AS (
    SELECT
        dm.name_id AS director_id,
        m.date_published
    FROM
        director_mapping dm
        JOIN movie m ON dm.movie_id = m.id
),
InterMovieDurations AS (
    SELECT
        d1.director_id,
        AVG(DATEDIFF(d2.date_published, d1.date_published)) AS average_inter_movie_duration
    FROM
        DirectorMovieDates d1
        JOIN DirectorMovieDates d2 ON d1.director_id = d2.director_id AND d1.date_published < d2.date_published
    GROUP BY
        d1.director_id
)
SELECT
    dm.director_id,
    dm.director_name,
    dm.number_of_movies,
    imd.average_inter_movie_duration,
    dm.average_movie_ratings,
    dm.total_votes,
    dm.min_rating,
    dm.max_rating,
    dm.total_movie_durations
FROM
    DirectorMovies dm
    LEFT JOIN InterMovieDurations imd ON dm.director_id = imd.director_id
ORDER BY
    dm.number_of_movies DESC
LIMIT 9;









