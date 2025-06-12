This Project is a Data Cleaning activity using SQL.
Author
The author of this project is Fred Changi and can be reached at fredojiem@gmail.com .


We imported data from excel into mySQL workbench for further processing.

It has four steps:
1. Remove duplicates (Line 27)
 - Challenge met: table had no primary key, therefore we used window functions(**ROW_NUMBER**) to assign row numbers based on all rows


2. Standardize the data
 - Identify inconcistensies in the data and correct them.
     --E.g, two labels for the same thing.--- There was both United States and United States(.), which was handled with a TRIM function.(Line 168)
                                          --- Crypto and Cryptocurrency(Line 147)
 - Convert data types to the correct form
    -- e.g date was in text format, therefore used str_to_date function(Line 189)

3.Null values or blank values
  - Some companies had the industry indicated in some records, then other records of the same company was missing the industry name.(Line 217)
      - THis was handled using a JOIN (**SELF JOIN**) to update the misssing industry data.(Line 223)

4.remove any unnecessary rows/columns
  - Removed rows that had no values for layoffs, since layoffs is what we are investigating. Empty values may not be helpful.(Line 264)
  - Removed column that had been used to assign row numbers to identify duplicates.(Line 273)
