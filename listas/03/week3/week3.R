vendors <- "https://data.baltimorecity.gov/api/views/bqw3-z52q/rows.csv?accessType=DOWNLOAD"


if (!file.exists("../TempData")){
  dir.create("../TempData")  
}


download.file(vendors, destfile = "../TempData/BFood.csv", method="curl")


if (file.exists("../TempData/BFood.csv")){
  tam <- file.info("../TempData/BFood.csv")$size
  paste("File downloaded, ",tam," bytes")
} else {
  "Error downloading file!"
}


bVendors <- read.csv(file="../TempData/BFood.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)

str(bVendors)


bVendors$Id <- NULL
bVendors$LicenseNum <- as.factor(bVendors$LicenseNum)


bVendors$St <- as.factor(bVendors$St)
str(bVendors$St)


bVendors$St <- NULL


names(bVendors)[names(bVendors) == "Location.1"] <- "location"
str(bVendors)
