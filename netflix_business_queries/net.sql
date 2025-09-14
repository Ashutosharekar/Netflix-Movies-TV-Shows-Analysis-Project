SELECT * FROM netflix_db.netflix;

-- 13 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
select 
distinct type ,count(*)
from netflix
group by type;

-- 2. Find the most common rating for movies and TV shows
with a as (
select
type ,rating ,count(*) ,
rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
)
select type ,rating 
from a 
where ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
select * from netflix;
select * 
from netflix
where type = 'Movie' and  release_year = 2020 ;

-- 4. Identify the longest movie  
select
 title ,duration 
from netflix
where type = 'Movie'
order by  cast(substring_index(duration ,' ',1) as unsigned) desc
limit 1;

-- 5. Find content added in the last 5 years
select * from netflix;
select * from netflix
where
    STR_TO_DATE(date_added, '%M %e, %Y') >= CURRENT_DATE() - INTERVAL 5 YEAR;
    
-- 6. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix ;
select * from netflix
where 
  director like '%Rajiv Chilaka%';


-- 7. List all TV shows with more than 5 seasons
select * from netflix;
select title, duration from netflix 
where type='TV Show' 
and
cast(substring_index(duration, ' ', 1) as unsigned) > 5;

-- 8.Find the year with the highest number of releases (movies + TV shows combined).
select release_year , count(show_id) as total_releases 
from netflix 
group by release_year
order by 2 desc 
limit 1;

-- 9. List all movies that are documentaries
select * from netflix 
where type ='Movie' 
and listed_in like '%Documentaries%';

-- 10. Find all content without a director
select * from netflix 
where director = '';

-- 11. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
where type='Movie' 
and  casts like '%Salman Khan%'
and release_year > year(current_date) -10 ;

-- 12. Find the top 5 countries with the highest number of Netflix releases.
select country , count(show_id)as releases 
from netflix
where country is not null and country !=''
group by country
order by releases desc
limit 5;


/*
13.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

select * from netflix;
with d as (
select *,
case
when description like '%kill%' or description like "%violence%" then "bad"
else "good"
end as category 
from netflix
)
select distinct category , count(*) 
from d
group by category; 

