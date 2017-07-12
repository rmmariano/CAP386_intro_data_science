vendors <- "https://data.baltimorecity.gov/api/views/bqw3-z52q/rows.csv?accessType=DOWNLOAD"

download.file(vendors, destfile = "../TempData/BFood.csv", method="curl")

if (file.exists("../TempData/BFood.csv")) {
  tam <- file.info("../TempData/BFood.csv")$size
  paste("File downloaded, ",tam," bytes")
} else {
  "Error downloading file!"
}

# Let's live dangerously.
bVendors <- read.csv(file="../TempData/BFood.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)

str(bVendors)

bVendors$Id <- NULL
bVendors$LicenseNum <- as.factor(bVendors$LicenseNum)

bVendors$St <- as.factor(bVendors$St)
str(bVendors$St)

bVendors$St <- NULL

names(bVendors)[names(bVendors) == "Location.1"] <- "location"
str(bVendors)

oneLoc <- "Towson 21204\n(39.28540000000, -76.62260000000)"

locV1 <- unlist(strsplit(oneLoc, "\n"))

latLong <- locV1[2]
latLongS <- unlist(strsplit(locV1[2], ","))

lat <- as.numeric(gsub("^.",'', latLongS[1]))
long <- as.numeric(gsub(".$",'', latLongS[2]))

oneLoc <- "Towson 21204\n(39.28540000000, -76.62260000000)"

tempS <- unlist(regmatches(oneLoc,gregexpr("[0-9.]+", oneLoc)))

lat <- as.numeric(tempS[2])
long <- as.numeric(tempS[3])

paste("lat =", lat, " long = ", long)

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

head(subset(bVendors, select = c(location, lat, long)))

bVendors$hotdog <- grepl("Hot dog", bVendors$ItemsSold)

head(subset(bVendors, select = c(ItemsSold, hotdog)))

bVendors$hotdog <- grepl("hot dog|frank", bVendors$ItemsSold, ignore.case = TRUE)

head(subset(bVendors, select = c(ItemsSold, hotdog)))

bVendors$pizza <- grepl("pizza", bVendors$ItemsSold, ignore.case = TRUE)

head(subset(bVendors, select = c(ItemsSold, pizza)))

#one_location <- "Towson 21204\n(39.28540000000, -76.62260000000)"
one_location <- "Owings Mill 21117\n(39.29860000000, -76.61280000000)"

location_vector <- unlist(strsplit(one_location, "\n"))

city_and_zip_code <- location_vector[1]

city_and_zip_code_char <- unlist(strsplit(city_and_zip_code, " "))

city_and_zip_code_list = as.vector(city_and_zip_code_char, mode="list") 

last_index = length(city_and_zip_code_list)

zip_code = city_and_zip_code_list[last_index]

# zip_code is a list with one string, so we join it in a string
zip_code = paste(zip_code, collapse = '')

# remove the zip code of the list
city_and_zip_code_list[last_index] <- NULL

name_town = city_and_zip_code_list

name_town = paste(name_town, collapse = ' ')

name_town



######################
# 3)

name_town_vector <- vector(length = nrow(bVendors), mode = "character")
zip_code_vector <- vector(length = nrow(bVendors), mode = "character")


for(i in 1:nrow(bVendors)) {
  city_zip_code_and_coordinates = unlist(strsplit(bVendors$location[i], "\n"))
  city_and_zip_code = city_zip_code_and_coordinates[1]
  
  city_and_zip_code_char <- unlist(strsplit(city_and_zip_code, " "))
  city_and_zip_code_list = as.vector(city_and_zip_code_char, mode="list") 
  
  
  last_index = length(city_and_zip_code_list)
  
  
  zip_code = city_and_zip_code_list[last_index]
  
  # zip_code is a list with one string, so we join it in a string
  zip_code = paste(zip_code, collapse = '')
  
  # remove the zip code of the list
  city_and_zip_code_list[last_index] <- NULL
  
  name_town = city_and_zip_code_list
  
  name_town = paste(name_town, collapse = ' ')
  
  
  name_town_vector[i] = name_town
  zip_code_vector[i] = zip_code
}

name_town_vector

zip_code_vector


bVendors$name_town <- name_town_vector
bVendors$zip_code <- zip_code_vector

bVendors

str(bVendors)

head(subset(bVendors, select = c(location, name_town, zip_code)))

