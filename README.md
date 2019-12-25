## Google BigQuery Project ID

I will be using Google BigQuery with the following project ID in the following chunk.

```{r}
project <- "planar-ember-256702"
```

## Connecting to Chicago Crime Database

I will be using the Chicago crime database that we have previously used in this course. First, I will set up the connection to the database

```{r}
con <- dbConnect(
  bigrquery::bigquery(),
  project = "bigquery-public-data",
  dataset = "chicago_crime",
  billing = project
)
con 
```

## Preparing Data

I will be writing queries from within R via the `DBI` package. I am interested in the number of arrests grouped by year, district, and primary type of crime. 

```{r}
#query object that fulfills the above
sql <- "SELECT year, district, primary_type, COUNT(*) AS arrests 
        FROM `bigquery-public-data.chicago_crime.crime` 
        WHERE arrest = TRUE
        GROUP BY year, district, primary_type"

#assigning query to an object
crime <- dbGetQuery(con, sql)
```
