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

-   I want to get all variations of "hot dog", including "frank". With <tt>ignore.case</tt> we will get all cases that match with "hot dog" or "frank" in both cases (lower and upper):

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
