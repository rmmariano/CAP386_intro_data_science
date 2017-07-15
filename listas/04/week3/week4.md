
# Introduction to Data Science - Week 3 - Exercises (Jupyter/Python)

Do the necessaries imports:


```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
```


```python
from os import makedirs
from os.path import exists, isfile, getsize
# import urllib.request as urllib
from urllib.request import urlretrieve
```

If the temporary directory doesn't exist, so make it:


```python
temp_directory = "../TempData/"
if not exists(temp_directory):
    makedirs(temp_directory)
```

## First of all: download the CSV and read it in a variable

Download the CSV data from https://data.baltimorecity.gov/dataset/Food-Vendor-Locations/bqw3-z52q/data


```python
vendors = "https://data.baltimorecity.gov/api/views/bqw3-z52q/rows.csv?accessType=DOWNLOAD"

urlretrieve(vendors, "../TempData/BFood.csv")

if isfile("../TempData/BFood.csv"):
    tam = getsize("../TempData/BFood.csv")
    print("File downloaded, ", tam, " bytes.")
else:
    print("Error downloading file!")
```

    File downloaded,  15661  bytes.


Read the CSV keeping the same header:


```python
# bVendors <- read.csv(file="../TempData/BFood.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)

bVendors = pd.read_csv("../TempData/BFood.csv")

print(bVendors.head())
```

       Id LicenseNum                                 VendorName  \
    0   0   DF000166  Abdul-Ghani, Christina, "The Bullpen Bar"   
    1   0   DF000075                                 Ali, Fathi   
    2   0   DF000133                                 Ali, Fathi   
    3   0   DF000136                                 Ali, Fathi   
    4   0   DF000001                                 Ali, Yusuf   
    
                                              VendorAddr  \
    0  508 Washington Blvd, confined within 10 x 10 s...   
    1                   SEC Calvert & Madison on Calvert   
    2                           NEC Baltimore & Pine Sts   
    3                            NEC Light & Redwood Sts   
    4  On Hamburg St across from the rear end of the ...   
    
                                               ItemsSold  \
    0        Grilled food, pizza slices, gyro sandwiches   
    1    Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks   
    2    Hot dogs, Sausage, drinks, snacks, gum, & candy   
    3     Hot dogs, sausages, chips, snacks, drinks, gum   
    4  Large & Small beef franks, soft drinks, water,...   
    
                                              Cart_Descr  St  \
    0  Two add'l tables to be added to current 6' tab...  MD   
    1                                           Pushcart  MD   
    2                                           Pushcart  MD   
    3                                           Pushcart  MD   
    4                      grey pushcart on three wheels  MD   
    
                                              Location 1  
    0    Towson 21204\n(39.28540000000, -76.62260000000)  
    1  Owings Mill 21117\n(39.29860000000, -76.612800...  
    2  Owings Mill 21117\n(39.28920000000, -76.626700...  
    3  Owings Mill 21117\n(39.28870000000, -76.613600...  
    4  Baltimore 21239\n(39.27920000000, -76.62200000...  


## R Exercises

* I want to get all variations of "hot dog", including "frank". 
With <tt>ignore.case</tt> we will get all cases that match with "hot dog" or "frank" in both cases (lower or upper):


```python
# bVendors$hotdog <- grepl("hot dog|frank", bVendors$ItemsSold, ignore.case = TRUE)

# head(subset(bVendors, select = c(ItemsSold, hotdog)))
```

* Now I want to get all variations of "pizza":


```python
# bVendors$pizza <- grepl("pizza", bVendors$ItemsSold, ignore.case = TRUE)

# head(subset(bVendors, select = c(ItemsSold, pizza)))
```
