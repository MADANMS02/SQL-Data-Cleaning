SELECT * FROM world_layoffs.layoffs;

SELECT * 
FROM LAYOFFS;

-- DUPLICATE OF RAW DATA
CREATE TABLE LAYOFF_STAGING
LIKE layoffs;

SELECT * 
FROM layoff_staging;

INSERT LAYOFF_STAGING
SELECT * 
FROM layoffs;

-- CTE TO IDENTIFY DUPLICATE
WITH DUPLICATE_CTE 
AS(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,`DATE`,STAGE,COUNTRY,FUNDS_RAISED_MILLIONS)
AS ROW_NUM
FROM LAYOFF_STAGING
)
SELECT * 
FROM DUPLICATE_CTE;


WITH DUPLICATE_CTE 
AS(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,`DATE`,STAGE,COUNTRY,FUNDS_RAISED_MILLIONS)
AS ROW_NUM
FROM LAYOFF_STAGING
)
SELECT * 
FROM DUPLICATE_CTE
WHERE ROW_NUM>1;

SELECT * 
FROM layoff_staging
WHERE COMPANY='YAHOO';

-- CREATING ANOTHER TABLE TO DELETE DUPLICATES

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `ROW_NUM` INT
	
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoff_staging2;

INSERT INTO layoff_staging2
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,`DATE`,STAGE,COUNTRY,FUNDS_RAISED_MILLIONS)
AS ROW_NUM
FROM LAYOFF_STAGING
;

SELECT * 
FROM layoff_staging2
WHERE ROW_NUM>1
;

-- DELETING DUPLIATE

DELETE 
FROM layoff_staging2
WHERE ROW_NUM>1;

SELECT * 
FROM layoff_staging2
;

-- ANALYZING AND CORRECTING DATA

SELECT DISTINCT COMPANY
FROM layoff_staging2
ORDER BY 1;

SELECT DISTINCT COMPANY,TRIM(company)           
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET COMPANY=TRIM(company)
;

UPDATE layoff_staging2
SET LOCATION=TRIM(LOCATION)
;


SELECT DISTINCT INDUSTRY
FROM layoff_staging2
ORDER BY 1
;

SELECT * 
FROM layoff_staging2
WHERE INDUSTRY LIKE 'CRYPTO%'
ORDER BY industry DESC
;

UPDATE layoff_staging2
SET INDUSTRY = 'CRYPTO'
WHERE INDUSTRY LIKE 'CRYPTO%'
;

SELECT DISTINCT country
FROM layoff_staging2
ORDER BY 1
;

SELECT * 
FROM layoff_staging2
WHERE COMPANY ='' 
OR COMPANY IS NULL;

SELECT * 
FROM layoff_staging2
WHERE location ='' 
OR location IS NULL;


SELECT * 
FROM layoff_staging2
WHERE INDUSTRY ='' 
OR INDUSTRY IS NULL;

SELECT * 
FROM layoff_staging2
WHERE COMPANY='AIRBNB'
;

SELECT * 
FROM layoff_staging2 T1
	JOIN layoff_staging2 T2
    ON T1.company=T2.company
WHERE T1.industry IS NULL OR T1.industry='' 
AND T2.industry IS NOT NULL 
;    

SELECT T1.industry,T2.industry
FROM layoff_staging2 T1
	JOIN layoff_staging2 T2
    ON T1.company=T2.company
WHERE T1.industry IS NULL OR T1.industry='' 
AND T2.industry IS NOT NULL 
;    

UPDATE layoff_staging2 T1
	JOIN layoff_staging2 T2
    ON T1.company=T2.company
SET T1.INDUSTRY=T2.INDUSTRY
WHERE T1.industry IS NULL OR T1.industry='' 
AND T2.industry IS NOT NULL 
;    
    
UPDATE layoff_staging2
SET INDUSTRY = NULL
WHERE INDUSTRY='';

UPDATE layoff_staging2 T1
	JOIN layoff_staging2 T2
    ON T1.company=T2.company
SET T1.INDUSTRY=T2.INDUSTRY
WHERE T1.industry IS NULL 
AND T2.industry IS NOT NULL 
;    

SELECT distinct INDUSTRY 
FROM layoff_staging2
ORDER BY 1;

SELECT * 
FROM layoff_staging2
WHERE COMPANY LIKE 'Bally%';

SELECT * 
FROM layoff_staging2
WHERE INDUSTRY ='' ;

SELECT * 
FROM layoff_staging2
WHERE (total_laid_off IS NULL OR total_laid_off='')
	AND (percentage_laid_off IS NULL OR percentage_laid_off='')
    ;
    
DELETE
FROM layoff_staging2
WHERE (total_laid_off IS NULL OR total_laid_off='')
	AND (percentage_laid_off IS NULL OR percentage_laid_off='')
;

SELECT * 
FROM layoff_staging2;

SELECT `DATE` ,str_to_date(`DATE`,'%m/%d/%Y')
from layoff_staging2;

update layoff_staging2
set `date`=str_to_date(`DATE`,'%m/%d/%Y');

SELECT * 
FROM layoff_staging2;

alter table layoff_staging2
modify column `date` date
;

alter table layoff_staging2
drop column row_num
;

select * 
from layoff_staging2
;

SELECT company, COUNT(*)
FROM layoff_staging2
GROUP BY company
HAVING COUNT(*) > 1;

WITH DUPLICATE_CTE 
AS(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,`DATE`,STAGE,COUNTRY,FUNDS_RAISED_MILLIONS)
AS ROW_NUM
FROM LAYOFF_STAGING2
)
SELECT * 
FROM DUPLICATE_CTE
WHERE ROW_NUM>1;

