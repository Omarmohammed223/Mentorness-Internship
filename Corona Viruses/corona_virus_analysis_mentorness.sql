/*
Overview:

The CORONA VIRUS pandemic has had a significant impact on public health and has created an urgent need for data-driven insights to understant the spread of the virus.
As a data analyst, I've been tasked with analyzing a CORONA VIRUS dataset to derive meaningful insights and present findings.
This is Task 2 of internship program where I've given CORONA VIRUS dataset to find insights and trends about this pandemic.



Q1. Check NULL Values
Q2. If NULL values are present, update them with zeros for all columns.
Q3. Check total number of rows.
Q4. Check what is start_date and end_date
Q5. Number of month presetn in dataset
Q6. Find Monthly average for confirmed, deaths, recovered
Q7. Find most frequent value for confired, deaths, recovered per year
Q8. Find minimum vlaues for confired, deaths, recovered per year
Q9. Find maximum values of confired, deaths, recovered per year
Q10. The total number of case of confired, deaths, recovered each month
Q11. Check how corona virus spred out with respect to confired case
Q12. Check how corona virus spread out with respect to death case per month
Q13. Check how corona virus spread out with respect to recovered case
Q14. Find Country having lowest number of death case
Q15. Find top 5 countries having highest recovered casse
*/



Select *
From project..Coronadataset;

--------------------------------------------------------------------------------

-- Q1. Check NULL Values

Select *
From project..Coronadataset
Where Province IS NULL OR
      [Country/Region] IS NULL OR
      Latitude IS NULL OR
      Longitude IS NULL OR
      Date IS NULL OR
	Confirmed is NULL 
	OR Deaths is NULL
	OR Recovered is NULL

-- There is no any null value present in dataset

----------------------------------------------------------------------
-- Q2. If NULL values are present, update them with zeros for all columns.

UPDATE project..Coronadataset
SET confirmed = COALESCE(confirmed, 0),
    recovered = COALESCE(recovered, 0),
    deaths = COALESCE(deaths, 0);


--------------------------------------------------------------------

-- Q3. Check total number of rows.

Select count(*) as totalrows
From project..Coronadataset

-- There are 78386 rows of data in this dataset

--------------------------------------------------------------------------------------

-- Q4. Check what is start_date and end_date

-- I found inconsistency in 'Date' column. So I modified it which made me easy to deal with 'Date' in further cases.

Select min([Date]) As start_date,
	max([Date]) As max_date
From project..Coronadataset;

--------------------

 -- Here is some modification in 'Date' column, but before altering column here in SQL, I did some modification in Excel which made me easier to update later in SQL.


 Select [Date],
DATENAME(month,[Date]) As [Month],
DATENAME(YEAR,[Date]) As [Year]
From project..Coronadataset

Alter Table project..Coronadataset
Add [Month] varchar(12);

Update PortfolioProject..AdidasSales
Set [Month] = DATENAME(month,[Date])

ALTER TABLE project..Coronadataset
ADD [Year] INT;

UPDATE project..Coronadataset
SET [Year] = CAST(YEAR([Date]) AS int);

Select * 
From project..Coronadataset

------------------------------------------------------------------------

-- Number of month present in dataset

Select COUNT(distinct DATENAME(month,[Date])) as total_month_count
From project..Coronadataset

-----------------------------------------------------------------

-- Q6. Find Monthly average for confirmed, deaths, recovered

SELECT [Month],
	 [Year],
	ROUND(AVG(Confirmed),2) AS confirmed_avg, 
	ROUND(AVG(Deaths),2) AS deaths_avg,
	ROUND(AVG(Recovered),2) AS recovered_avg
FROM project..Coronadataset
Group by [Month], [Year]
Order by [Year];



------------------------------------------------------------------

-- Q7. Find most frequent value for confired, deaths, recovered per year

WITH FrequentValues AS (
    SELECT
        [Month],
        [Year],
        Confirmed,
        Deaths,
        Recovered,
        RANK() OVER (PARTITION BY [Month], [Year] 
					ORDER BY COUNT(*) DESC) as rank
  FROM project..Coronadataset
    GROUP BY [Year], [month], Confirmed, Deaths, Recovered
)
SELECT
    [Month],
    [Year],
    Confirmed,
    Deaths,
    Recovered
FROM
    FrequentValues
WHERE rank = 1
ORDER BY [Year], [Month];


--------------------------------------------------------

-- Q8. Find minimum vlaues for confired, deaths, recovered per year

SELECT 
	[Year],
	MIN(Confirmed) AS min_confirmed,
	MIN(Deaths) AS min_deaths,
	MIN(Recovered) AS min_recovered
FROM project..Coronadataset
GROUP BY [Year]
ORDER BY [Year] ASC;

------------------------------------------------------------
-- Q9. Find maximum values of confired, deaths, recovered per year


SELECT 
	[Year],
	Max(Confirmed) AS max_confirmed,
	Max(Deaths) AS max_deaths,
	Max(Recovered) AS max_recovered
FROM project..Coronadataset
GROUP BY [Year]
ORDER BY [Year] ASC;


SELECT 
	[Year],
	Sum(Confirmed) AS total_confirmed,
	Sum(Deaths) AS total_deaths,
	Sum(Recovered) AS total_recovered
FROM project..Coronadataset
GROUP BY [Year]
ORDER BY [Year] ASC;

-------------------------------------------
-- Q10. The total number of case of confired, deaths, recovered each month

SELECT  [Month], [Year],
	SUM(Confirmed) AS total_confirmed,
	SUM(Deaths) AS total_deaths,
	SUM(Recovered) AS total_recovered
FROM project..Coronadataset
GROUP BY  [Year], [Month]
Order by total_confirmed, total_deaths, total_recovered DESC


-----------------------------------------------------------
-- Q11. Check how corona virus spred out with respect to confired case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

Select 
	sum(Confirmed) As total_Confirmed_case,
	Round(AVG(Confirmed),2) As Avg_Confirmed_case,
	Round(VAR(Confirmed),2) AS Variance_Confirmed_case,
	Round(STDEV(Confirmed),2) As standard_Confirmed_case
From project..Coronadataset


-------------------------------------------------------
-- Q12. Check how corona virus spread out with respect to death case per month

SELECT  [Year], [Month],
	SUM(Deaths) AS total_deaths,
	ROUND(AVG(Deaths),2) AS avg_deaths,
	ROUND(VAR(Deaths),2) AS variance_deaths,
	ROUND(STDEV(Deaths),2) AS standard_dev_deaths
FROM project..Coronadataset
GROUP BY [Year], [Month]
Order By total_deaths;

-------------------------------------------------------------
-- Q13. Check how corona virus spread out with respect to recovered case per month
--      (Eg.: total recovered cases, their average, variance & STDEV )

SELECT [Year], [Month],
	SUM(Recovered) AS total_recovered,
	ROUND(AVG(Recovered),2) AS avg_recovered,
	ROUND(VAR(Recovered),2) AS variance_recovered,
	ROUND(STDEV(Recovered),2) AS standard_dev_recovered
FROM project..Coronadataset
GROUP BY [Year], [Month]
ORDER BY [Year], [Month] ASC;


--------------------------------------------------------

--Q14. Find Country having lowest number of death case

With deathrank As
(
Select  [Country/Region],
	SUM(Deaths) as number_of_deaths,
	Rank() over(Order by sum(Deaths)) AS ranks
From project..Coronadataset
Group By [Country/Region]
)
Select [Country/Region]
From deathrank
Where ranks = 1;



---------------------------------------------------------
-- Q15. Find top 5 countries having highest recovered case

Select TOP 5 [Country/Region],
	sum(Recovered) as highest_recovered_case
From project..Coronadataset
Group By [Country/Region]
Order By highest_recovered_case DESC;


Select TOP 5 [Country/Region],
	sum(Confirmed) as highest_confirmed_case
From project..Coronadataset
Group By [Country/Region]
Order By highest_confirmed_case DESC;


Select TOP 5 [Country/Region],
	sum(Deaths) as highest_deaths_case
From project..Coronadataset
Group By [Country/Region]
Order By highest_deaths_case DESC;


Select
	sum(Confirmed) as total_confired_case,
	sum(Deaths) as total_deaths_case,
	sum(Recovered) as total_recovered_case
From project..Coronadataset