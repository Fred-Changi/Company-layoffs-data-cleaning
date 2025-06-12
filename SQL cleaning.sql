-- In this project we clean data on companies' layoffs

-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3.Null values or blank values
-- 4.remove any columns

-- duplicate the table for base level purposes
CREATE TABLE layoffs_staging
LIKE layoffs; 

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


-- missing PK
-- assign a row number divide by uniqueness
 SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
 FROM layoffs_staging
 ;
 
 WITH duplicate_cte AS
 (
  SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
 FROM layoffs_staging
 )
 SELECT *
 FROM duplicate_cte
 WHERE row_num > 1;
 
 SELECT *
 FROM layoffs_staging
 WHERE company = 'Akerna';
 
 -- Challenge, I had inserted to the new table twice
 -- benefit of having a base table
 -- dropped old table
 
 CREATE TABLE layoffs_staging
 LIKE layoffs;
 
 INSERT layoffs_staging
 SELECT *
 FROM layoffs;
 
 -- now proceed
 
 SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
 FROM layoffs_staging
 ;
 
 WITH duplicate_cte AS
 (
  SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
 FROM layoffs_staging
 )
 SELECT *
 FROM duplicate_cte
 WHERE row_num > 1;
 
 SELECT *
 FROM layoffs_staging
 WHERE company = 'Casper';
 
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


 SELECT *
 FROM layoffs_staging2;
 
 INSERT INTO layoffs_staging2
 SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
 FROM layoffs_staging;
 
SELECT *
 FROM layoffs_staging2
 WHERE row_num > 1;
 
 
 SELECT *
 FROM layoffs_staging2
 WHERE company = 'Microsoft';
 
 
 SET SQL_SAFE_UPDATES = 0;
 DELETE
 FROM layoffs_staging2
 WHERE row_num > 1;
 
  SELECT *
 FROM layoffs_staging2
 WHERE row_num > 1;
 
   SELECT *
 FROM layoffs_staging2;
 
 
 -- Duplicates have been removed
 
 -- Standardizing data
 -- finding issues and fixing them
 
 -- trimming company names
SELECT company, (TRIM(company))
FROM layoffs_staging2;
 
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
 
-- crypto and crypo curreny separates

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- different crypto names removed

-- scan for issues in location
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;
-- all good

-- scan locations
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
-- WHERE country LIKE 'United States%'
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Unites states now fixed

SELECT *
FROM layoffs_staging2;

-- the date column type is text

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;
-- convert to the correect date format of sql
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2
ORDER BY 1;

-- convert data type to date
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Step 3
-- null values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- Check try populate data e.g Airbnb
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- update blank airbnb industry to travel
-- self join table to see companies that have their industries shown
SELECT *
FROM layoffs_staging2 AS stg1
JOIN layoffs_staging2 AS stg2
	ON stg1.company = stg2.company
WHERE (stg1.industry IS NULL OR stg1.industry = '')
AND stg2.industry IS NOT NULL
;

-- update table
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 AS stg1
JOIN layoffs_staging2 AS stg2
	ON stg1.company = stg2.company
SET stg1.industry = stg2.industry
WHERE stg1.industry IS NULL
AND stg2.industry IS NOT NULL;


-- check balley
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';
 -- has no other row to compare to like the others


SELECT *
FROM layoffs_staging2;


-- other columns cant be populated without more einformation like the total laid off or funds raised

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '')
AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

-- rows with no value for total laid off or % laid off are not helpful to us. delete
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- we dont need the column for row number we sed to check duplicates
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- DATA CLEANED