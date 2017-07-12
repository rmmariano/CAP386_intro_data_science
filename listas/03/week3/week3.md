Tidy Data Example: Hot Dogs in Baltimore
================

-   [Reading Data](#reading-data)
-   [Selecting Variables and Creating Factors](#selecting-variables-and-creating-factors)
-   [Parsing Location](#parsing-location)
-   [Now for the exercises!](#now-for-the-exercises)
-   [R Exercises](#r-exercises)

Reading Data
------------

Do the download of the CSV data from <https://data.baltimorecity.gov/dataset/Food-Vendor-Locations/bqw3-z52q/data>

``` r
vendors <- "https://data.baltimorecity.gov/api/views/bqw3-z52q/rows.csv?accessType=DOWNLOAD"

download.file(vendors, destfile = "../TempData/BFood.csv", method="curl")

if (file.exists("../TempData/BFood.csv")) {
  tam <- file.info("../TempData/BFood.csv")$size
  paste("File downloaded, ",tam," bytes")
} else {
  "Error downloading file!"
}
```

    ## [1] "File downloaded,  15661  bytes"

Read the CSV keeping the same header:

``` r
# Let's live dangerously.
bVendors <- read.csv(file="../TempData/BFood.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)

str(bVendors)
```

    ## 'data.frame':    77 obs. of  8 variables:
    ##  $ Id        : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ LicenseNum: chr  "DF000166" "DF000075" "DF000133" "DF000136" ...
    ##  $ VendorName: chr  "Abdul-Ghani, Christina, \"The Bullpen Bar\"" "Ali, Fathi" "Ali, Fathi" "Ali, Fathi" ...
    ##  $ VendorAddr: chr  "508 Washington Blvd, confined within 10 x 10 space" "SEC Calvert & Madison on Calvert" "NEC Baltimore & Pine Sts" "NEC Light & Redwood Sts" ...
    ##  $ ItemsSold : chr  "Grilled food, pizza slices, gyro sandwiches" "Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks" "Hot dogs, Sausage, drinks, snacks, gum, & candy" "Hot dogs, sausages, chips, snacks, drinks, gum" ...
    ##  $ Cart_Descr: chr  "Two add'l tables to be added to current 6' table in U shape, with grill & warming pans, Tent" "Pushcart" "Pushcart" "Pushcart" ...
    ##  $ St        : chr  "MD" "MD" "MD" "MD" ...
    ##  $ Location.1: chr  "Towson 21204\n(39.28540000000, -76.62260000000)" "Owings Mill 21117\n(39.29860000000, -76.61280000000)" "Owings Mill 21117\n(39.28920000000, -76.62670000000)" "Owings Mill 21117\n(39.28870000000, -76.61360000000)" ...

Selecting Variables and Creating Factors
----------------------------------------

Remove the column <tt>Id</tt> and tranform the <tt>LicenseNum</tt> column in a factor from <tt>bVendors</tt>:

``` r
bVendors$Id <- NULL
bVendors$LicenseNum <- as.factor(bVendors$LicenseNum)
```

<tt>bVendors$St</tt> looks suspicious... let's check it:

``` r
bVendors$St <- as.factor(bVendors$St)
str(bVendors$St)
```

    ##  Factor w/ 1 level "MD": 1 1 1 1 1 1 1 1 1 1 ...

``` r
bVendors$St <- NULL
```

The name for variable <tt>Location.1</tt> is ugly, so change to <tt>location</tt>:

``` r
names(bVendors)[names(bVendors) == "Location.1"] <- "location"
str(bVendors)
```

    ## 'data.frame':    77 obs. of  6 variables:
    ##  $ LicenseNum: Factor w/ 76 levels "DF000001","DF000002",..: 50 35 46 48 1 38 33 2 3 4 ...
    ##  $ VendorName: chr  "Abdul-Ghani, Christina, \"The Bullpen Bar\"" "Ali, Fathi" "Ali, Fathi" "Ali, Fathi" ...
    ##  $ VendorAddr: chr  "508 Washington Blvd, confined within 10 x 10 space" "SEC Calvert & Madison on Calvert" "NEC Baltimore & Pine Sts" "NEC Light & Redwood Sts" ...
    ##  $ ItemsSold : chr  "Grilled food, pizza slices, gyro sandwiches" "Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks" "Hot dogs, Sausage, drinks, snacks, gum, & candy" "Hot dogs, sausages, chips, snacks, drinks, gum" ...
    ##  $ Cart_Descr: chr  "Two add'l tables to be added to current 6' table in U shape, with grill & warming pans, Tent" "Pushcart" "Pushcart" "Pushcart" ...
    ##  $ location  : chr  "Towson 21204\n(39.28540000000, -76.62260000000)" "Owings Mill 21117\n(39.29860000000, -76.61280000000)" "Owings Mill 21117\n(39.28920000000, -76.62670000000)" "Owings Mill 21117\n(39.28870000000, -76.61360000000)" ...

Parsing Location
----------------

``` r
oneLoc <- "Towson 21204\n(39.28540000000, -76.62260000000)"
```

<tt>strsplit</tt> returns a matrix, so compact in a vector with <tt>unlist</tt>:

``` r
locV1 <- unlist(strsplit(oneLoc, "\n"))

locV1
```

    ## [1] "Towson 21204"                      "(39.28540000000, -76.62260000000)"

``` r
latLong <- locV1[2]
latLongS <- unlist(strsplit(locV1[2], ","))

latLongS
```

    ## [1] "(39.28540000000"   " -76.62260000000)"

``` r
lat <- as.numeric(gsub("^.",'', latLongS[1]))
long <- as.numeric(gsub(".$",'', latLongS[2]))

lat
```

    ## [1] 39.2854

``` r
long
```

    ## [1] -76.6226

That was truly horrible. Let's try another way:

``` r
oneLoc <- "Towson 21204\n(39.28540000000, -76.62260000000)"

tempS <- unlist(regmatches(oneLoc,gregexpr("[0-9.]+", oneLoc)))

tempS
```

    ## [1] "21204"          "39.28540000000" "76.62260000000"

``` r
lat <- as.numeric(tempS[2])
long <- as.numeric(tempS[3])
```

``` r
paste("lat =", lat, " long = ", long)
```

    ## [1] "lat = 39.2854  long =  76.6226"

Now for the whole dataframe:

``` r
tempS <- regmatches(bVendors$location, gregexpr("[0-9.]+", bVendors$location))

lats <- vector(length = nrow(bVendors), mode = "numeric")
longs <- vector(length = nrow(bVendors), mode = "numeric")

for(i in 1:nrow(bVendors)) {
  lats[i] <- as.numeric(tempS[[i]][2])
  longs[i] <- as.numeric(tempS[[i]][3])
}

bVendors$lat <- lats
bVendors$long <- longs

str(bVendors)
```

    ## 'data.frame':    77 obs. of  8 variables:
    ##  $ LicenseNum: Factor w/ 76 levels "DF000001","DF000002",..: 50 35 46 48 1 38 33 2 3 4 ...
    ##  $ VendorName: chr  "Abdul-Ghani, Christina, \"The Bullpen Bar\"" "Ali, Fathi" "Ali, Fathi" "Ali, Fathi" ...
    ##  $ VendorAddr: chr  "508 Washington Blvd, confined within 10 x 10 space" "SEC Calvert & Madison on Calvert" "NEC Baltimore & Pine Sts" "NEC Light & Redwood Sts" ...
    ##  $ ItemsSold : chr  "Grilled food, pizza slices, gyro sandwiches" "Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks" "Hot dogs, Sausage, drinks, snacks, gum, & candy" "Hot dogs, sausages, chips, snacks, drinks, gum" ...
    ##  $ Cart_Descr: chr  "Two add'l tables to be added to current 6' table in U shape, with grill & warming pans, Tent" "Pushcart" "Pushcart" "Pushcart" ...
    ##  $ location  : chr  "Towson 21204\n(39.28540000000, -76.62260000000)" "Owings Mill 21117\n(39.29860000000, -76.61280000000)" "Owings Mill 21117\n(39.28920000000, -76.62670000000)" "Owings Mill 21117\n(39.28870000000, -76.61360000000)" ...
    ##  $ lat       : num  39.3 39.3 39.3 39.3 39.3 ...
    ##  $ long      : num  76.6 76.6 76.6 76.6 76.6 ...

Worried about the values shown? Don't be. <tt>subset</tt> function create a subset of the <tt>bVendors</tt> only with the columns: <tt>location</tt>, <tt>lat</tt> and <tt>long</tt>. <tt>head</tt> function will show only the six first rows:

``` r
head(subset(bVendors, select = c(location, lat, long)))
```

    ##                                               location     lat    long
    ## 1      Towson 21204\n(39.28540000000, -76.62260000000) 39.2854 76.6226
    ## 2 Owings Mill 21117\n(39.29860000000, -76.61280000000) 39.2986 76.6128
    ## 3 Owings Mill 21117\n(39.28920000000, -76.62670000000) 39.2892 76.6267
    ## 4 Owings Mill 21117\n(39.28870000000, -76.61360000000) 39.2887 76.6136
    ## 5   Baltimore 21239\n(39.27920000000, -76.62200000000) 39.2792 76.6220
    ## 6   Baltimore 21244\n(39.30250000000, -76.61610000000) 39.3025 76.6161

Now for the exercises!
----------------------

``` r
bVendors$hotdog <- grepl("Hot dog", bVendors$ItemsSold)

head(subset(bVendors, select = c(ItemsSold, hotdog)))
```

    ##                                                                  ItemsSold
    ## 1                              Grilled food, pizza slices, gyro sandwiches
    ## 2                          Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks
    ## 3                          Hot dogs, Sausage, drinks, snacks, gum, & candy
    ## 4                           Hot dogs, sausages, chips, snacks, drinks, gum
    ## 5 Large & Small beef franks, soft drinks, water, all types of nuts & chips
    ## 6                                                   Hot dogs, Sodas, Chips
    ##   hotdog
    ## 1  FALSE
    ## 2  FALSE
    ## 3   TRUE
    ## 4   TRUE
    ## 5  FALSE
    ## 6   TRUE

R Exercises
-----------

-   I want to get all variations of "hot dog", including "frank". With <tt>ignore.case</tt> we will get all cases that match with "hot dog" or "frank" in both cases (lower or upper):

``` r
bVendors$hotdog <- grepl("hot dog|frank", bVendors$ItemsSold, ignore.case = TRUE)

head(subset(bVendors, select = c(ItemsSold, hotdog)))
```

    ##                                                                  ItemsSold
    ## 1                              Grilled food, pizza slices, gyro sandwiches
    ## 2                          Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks
    ## 3                          Hot dogs, Sausage, drinks, snacks, gum, & candy
    ## 4                           Hot dogs, sausages, chips, snacks, drinks, gum
    ## 5 Large & Small beef franks, soft drinks, water, all types of nuts & chips
    ## 6                                                   Hot dogs, Sodas, Chips
    ##   hotdog
    ## 1  FALSE
    ## 2   TRUE
    ## 3   TRUE
    ## 4   TRUE
    ## 5   TRUE
    ## 6   TRUE

-   Now I want to get all variations of "pizza":

``` r
bVendors$pizza <- grepl("pizza", bVendors$ItemsSold, ignore.case = TRUE)

head(subset(bVendors, select = c(ItemsSold, pizza)))
```

    ##                                                                  ItemsSold
    ## 1                              Grilled food, pizza slices, gyro sandwiches
    ## 2                          Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks
    ## 3                          Hot dogs, Sausage, drinks, snacks, gum, & candy
    ## 4                           Hot dogs, sausages, chips, snacks, drinks, gum
    ## 5 Large & Small beef franks, soft drinks, water, all types of nuts & chips
    ## 6                                                   Hot dogs, Sodas, Chips
    ##   pizza
    ## 1  TRUE
    ## 2 FALSE
    ## 3 FALSE
    ## 4 FALSE
    ## 5 FALSE
    ## 6 FALSE

-   Given a location, we want to extract the name of the town, so first we split the location, getting the part before the <tt>\\n</tt>:

``` r
#one_location <- "Towson 21204\n(39.28540000000, -76.62260000000)"
one_location <- "Owings Mill 21117\n(39.29860000000, -76.61280000000)"

location_vector <- unlist(strsplit(one_location, "\n"))

location_vector
```

    ## [1] "Owings Mill 21117"                 "(39.29860000000, -76.61280000000)"

Getting the name of the town and zip code:

``` r
city_and_zip_code <- location_vector[1]

city_and_zip_code
```

    ## [1] "Owings Mill 21117"

We want to separate both, so first we split it by white space and convert to list:

``` r
city_and_zip_code_char <- unlist(strsplit(city_and_zip_code, " "))

city_and_zip_code_char
```

    ## [1] "Owings" "Mill"   "21117"

``` r
city_and_zip_code_list = as.vector(city_and_zip_code_char, mode="list") 

city_and_zip_code_list
```

    ## [[1]]
    ## [1] "Owings"
    ## 
    ## [[2]]
    ## [1] "Mill"
    ## 
    ## [[3]]
    ## [1] "21117"

So get the last index of the list:

``` r
last_index = length(city_and_zip_code_list)

last_index
```

    ## [1] 3

With this index, now we can separate the name of the city and the zip code, where the zip code is the last position and the name of the town is the rest:

``` r
zip_code = city_and_zip_code_list[last_index]

# zip_code is a list with one string, so we join it in a string
zip_code = paste(zip_code, collapse = '')

# remove the zip code of the list
city_and_zip_code_list[last_index] <- NULL

name_town = city_and_zip_code_list

name_town
```

    ## [[1]]
    ## [1] "Owings"
    ## 
    ## [[2]]
    ## [1] "Mill"

``` r
zip_code
```

    ## [1] "21117"

If the name of the town have more than one word, so we need to assemble them again:

``` r
name_town = paste(name_town, collapse = ' ')

name_town
```

    ## [1] "Owings Mill"

-   Now we will do it for the entire dataframe:

``` r
# creating the auxiliary vectors
name_town_vector <- vector(length = nrow(bVendors), mode = "character")
zip_code_vector <- vector(length = nrow(bVendors), mode = "character")


for(i in 1:nrow(bVendors)) {
  location_vector = unlist(strsplit(bVendors$location[i], "\n"))
  city_and_zip_code = location_vector[1]
  
  city_and_zip_code_char <- unlist(strsplit(city_and_zip_code, " "))
  city_and_zip_code_list = as.vector(city_and_zip_code_char, mode="list") 
  
  # get the last index in list
  last_index = length(city_and_zip_code_list)
  
  # get the zip code from list
  zip_code = city_and_zip_code_list[last_index]
  
  # zip_code is a list with one string, so we join them in a string
  zip_code = paste(zip_code, collapse = '')
  
  # remove the zip code of the list
  city_and_zip_code_list[last_index] <- NULL
  
  name_town = city_and_zip_code_list
  
  # if the name of town has more than one word, join them
  name_town = paste(name_town, collapse = ' ')
  
  name_town_vector[i] = name_town
  zip_code_vector[i] = zip_code
}
```

``` r
head(name_town_vector)
```

    ## [1] "Towson"      "Owings Mill" "Owings Mill" "Owings Mill" "Baltimore"  
    ## [6] "Baltimore"

``` r
head(zip_code_vector)
```

    ## [1] "21204" "21117" "21117" "21117" "21239" "21244"

``` r
str(bVendors)
```

    ## 'data.frame':    77 obs. of  10 variables:
    ##  $ LicenseNum: Factor w/ 76 levels "DF000001","DF000002",..: 50 35 46 48 1 38 33 2 3 4 ...
    ##  $ VendorName: chr  "Abdul-Ghani, Christina, \"The Bullpen Bar\"" "Ali, Fathi" "Ali, Fathi" "Ali, Fathi" ...
    ##  $ VendorAddr: chr  "508 Washington Blvd, confined within 10 x 10 space" "SEC Calvert & Madison on Calvert" "NEC Baltimore & Pine Sts" "NEC Light & Redwood Sts" ...
    ##  $ ItemsSold : chr  "Grilled food, pizza slices, gyro sandwiches" "Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks" "Hot dogs, Sausage, drinks, snacks, gum, & candy" "Hot dogs, sausages, chips, snacks, drinks, gum" ...
    ##  $ Cart_Descr: chr  "Two add'l tables to be added to current 6' table in U shape, with grill & warming pans, Tent" "Pushcart" "Pushcart" "Pushcart" ...
    ##  $ location  : chr  "Towson 21204\n(39.28540000000, -76.62260000000)" "Owings Mill 21117\n(39.29860000000, -76.61280000000)" "Owings Mill 21117\n(39.28920000000, -76.62670000000)" "Owings Mill 21117\n(39.28870000000, -76.61360000000)" ...
    ##  $ lat       : num  39.3 39.3 39.3 39.3 39.3 ...
    ##  $ long      : num  76.6 76.6 76.6 76.6 76.6 ...
    ##  $ hotdog    : logi  FALSE TRUE TRUE TRUE TRUE TRUE ...
    ##  $ pizza     : logi  TRUE FALSE FALSE FALSE FALSE FALSE ...

Put the vectors with name of town and zip code in the <tt>bVendors</tt>:

``` r
bVendors$name_town <- name_town_vector
bVendors$zip_code <- zip_code_vector

str(bVendors)
```

    ## 'data.frame':    77 obs. of  12 variables:
    ##  $ LicenseNum: Factor w/ 76 levels "DF000001","DF000002",..: 50 35 46 48 1 38 33 2 3 4 ...
    ##  $ VendorName: chr  "Abdul-Ghani, Christina, \"The Bullpen Bar\"" "Ali, Fathi" "Ali, Fathi" "Ali, Fathi" ...
    ##  $ VendorAddr: chr  "508 Washington Blvd, confined within 10 x 10 space" "SEC Calvert & Madison on Calvert" "NEC Baltimore & Pine Sts" "NEC Light & Redwood Sts" ...
    ##  $ ItemsSold : chr  "Grilled food, pizza slices, gyro sandwiches" "Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks" "Hot dogs, Sausage, drinks, snacks, gum, & candy" "Hot dogs, sausages, chips, snacks, drinks, gum" ...
    ##  $ Cart_Descr: chr  "Two add'l tables to be added to current 6' table in U shape, with grill & warming pans, Tent" "Pushcart" "Pushcart" "Pushcart" ...
    ##  $ location  : chr  "Towson 21204\n(39.28540000000, -76.62260000000)" "Owings Mill 21117\n(39.29860000000, -76.61280000000)" "Owings Mill 21117\n(39.28920000000, -76.62670000000)" "Owings Mill 21117\n(39.28870000000, -76.61360000000)" ...
    ##  $ lat       : num  39.3 39.3 39.3 39.3 39.3 ...
    ##  $ long      : num  76.6 76.6 76.6 76.6 76.6 ...
    ##  $ hotdog    : logi  FALSE TRUE TRUE TRUE TRUE TRUE ...
    ##  $ pizza     : logi  TRUE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ name_town : chr  "Towson" "Owings Mill" "Owings Mill" "Owings Mill" ...
    ##  $ zip_code  : chr  "21204" "21117" "21117" "21117" ...

``` r
head(subset(bVendors, select = c(name_town, zip_code, location)))
```

    ##     name_town zip_code
    ## 1      Towson    21204
    ## 2 Owings Mill    21117
    ## 3 Owings Mill    21117
    ## 4 Owings Mill    21117
    ## 5   Baltimore    21239
    ## 6   Baltimore    21244
    ##                                               location
    ## 1      Towson 21204\n(39.28540000000, -76.62260000000)
    ## 2 Owings Mill 21117\n(39.29860000000, -76.61280000000)
    ## 3 Owings Mill 21117\n(39.28920000000, -76.62670000000)
    ## 4 Owings Mill 21117\n(39.28870000000, -76.61360000000)
    ## 5   Baltimore 21239\n(39.27920000000, -76.62200000000)
    ## 6   Baltimore 21244\n(39.30250000000, -76.61610000000)

It is all OK.
