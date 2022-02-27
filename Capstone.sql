--To first make sure I was looking at the right data, I wanted to select the entire table.
SELECT *
FROM capstone.dbo.vg_clean

--I'm only interested in data after the year 2000 so I removed anything that was not applicable.
DELETE
FROM capstone.dbo.vg_clean
WHERE Year < 2000

--I also want to remove any 'NULL' year values. I found that many of them weren't in my range and couldn't be used.
DELETE
FROM capstone.dbo.vg_clean
WHERE Year IS NULL

--I then decided that the total sales columns would best be put in later and removed them.
ALTER TABLE capstone.dbo.vg_clean
DROP COLUMN total_sales_EU, total_sales_Global, total_sales_JP, total_sales_NA, total_sales_Other

--Next, I want to break the data down into genres. To do this, I need to see what distinct genres I have.
SELECT DISTINCT(Genre)
FROM capstone.dbo.vg_clean

--The main focus on this project is action, adventure and role-playing. I wanted to isolate each one to see which of the three was most popular.
SELECT *
FROM capstone.dbo.vg_clean
WHERE Genre = 'Action'
ORDER BY Global_Sales DESC
--3080 games

SELECT *
FROM capstone.dbo.vg_clean
WHERE Genre = 'Adventure'
ORDER BY Global_Sales DESC
--1194 games

SELECT *
FROM capstone.dbo.vg_clean
WHERE Genre = 'Role-Playing'
ORDER BY Global_Sales DESC
--1302 games

--We can see that action is, by far the most popular category of the three with role-playing and adventure being much closer.

--Now I want to crate my base tables for the filtered data.
SELECT TOP (50)
*
INTO capstone.dbo.action
FROM capstone.dbo.vg_clean
WHERE Genre = 'Action'

SELECT TOP (50)
*
INTO capstone.dbo.adv
FROM capstone.dbo.vg_clean
WHERE Genre = 'Adventure'

SELECT TOP (50)
*
INTO capstone.dbo.rp
FROM capstone.dbo.vg_clean
WHERE Genre = 'Role-Playing'

--I'll combine them all using a UNION function and I have the usable table.
SELECT Genre, NA_Sales, EU_Sales, JP_Sales
INTO capstone.dbo.temp
FROM capstone.dbo.action
UNION
SELECT Genre, NA_Sales, EU_Sales, JP_Sales
FROM capstone.dbo.adv

SELECT Genre, NA_Sales, EU_Sales, JP_Sales
INTO capstone.dbo.genres
FROM capstone.dbo.temp
UNION
SELECT Genre, NA_Sales, EU_Sales, JP_Sales
FROM capstone.dbo.rp

SELECT *
FROM capstone.dbo.genres