
# Introduction to Data Science - Week 3 - Exercises (Jupyter/Python)

-   [First of all: download the CSV and read it in a variable](#first-of-all-download-the-csv-and-read-it-in-a-variable)
-   [R Exercises](#r-exercises)

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
bVendors["hotdog"] = bVendors["ItemsSold"].str.contains(u"hot dog|frank", case=False)

bVendors[["ItemsSold", "hotdog"]].head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ItemsSold</th>
      <th>hotdog</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Grilled food, pizza slices, gyro sandwiches</td>
      <td>False</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks</td>
      <td>True</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Hot dogs, Sausage, drinks, snacks, gum, &amp; candy</td>
      <td>True</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Hot dogs, sausages, chips, snacks, drinks, gum</td>
      <td>True</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Large &amp; Small beef franks, soft drinks, water,...</td>
      <td>True</td>
    </tr>
  </tbody>
</table>
</div>



* Now I want to get all variations of "pizza":


```python
bVendors["pizza"] = bVendors["ItemsSold"].str.contains(u"pizza", case=False)

bVendors[["ItemsSold", "pizza"]].head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ItemsSold</th>
      <th>pizza</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Grilled food, pizza slices, gyro sandwiches</td>
      <td>True</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Hot Dogs, Sausage, Snacks, Gum, Candies, Drinks</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Hot dogs, Sausage, drinks, snacks, gum, &amp; candy</td>
      <td>False</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Hot dogs, sausages, chips, snacks, drinks, gum</td>
      <td>False</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Large &amp; Small beef franks, soft drinks, water,...</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
</div>



* Given a location, we want to extract the name of the town, so first we split the location, getting the part before the <tt>\\n</tt>:


```python
#one_location = "Towson 21204\n(39.28540000000, -76.62260000000)"
one_location = "Owings Mill 21117\n(39.29860000000, -76.61280000000)"

location_vector = one_location.split("\n")

location_vector
```




    ['Owings Mill 21117', '(39.29860000000, -76.61280000000)']



Get the name of the town and zip code:


```python
city_and_zip_code = location_vector[0]

city_and_zip_code
```




    'Owings Mill 21117'



We want to separate both, so first we split it by white space and convert to list:


```python
city_and_zip_code_list = city_and_zip_code.split(" ")

city_and_zip_code_list
```




    ['Owings', 'Mill', '21117']



So get the last index of the list:


```python
last_index = len(city_and_zip_code_list) - 1

last_index
```




    2



With this index, now we can separate the name of the city and the zip code, where the zip code is the last position and the name of the town is the rest:


```python
zip_code = city_and_zip_code_list[last_index]

# remove the zip code of the list
del city_and_zip_code_list[last_index]

name_town = city_and_zip_code_list

print(name_town)

print(zip_code)
```

    ['Owings', 'Mill']
    21117


If the name of the town have more than one word, so we need to assemble them again:


```python
name_town = ' '.join(name_town)

name_town
```




    'Owings Mill'



Change the <tt>Location.1</tt> column to <tt>location</tt>: <tt>bVendors</tt>:


```python
bVendors = bVendors.rename(columns={"Location 1": "location"})
```

* Now we will do it for the entire dataframe:


```python
# creating the auxiliary vectors
name_town_vector = []
zip_code_vector = []

for i in range(0, len(bVendors)):
    location_vector = bVendors["location"][i].split("\n")
      
    city_and_zip_code = location_vector[0]
    
    city_and_zip_code_list = city_and_zip_code.split(" ")    
    
    # get the last index in list
    last_index = len(city_and_zip_code_list) - 1    
    
    # get the zip code from list
    zip_code = city_and_zip_code_list[last_index]
    
    # remove the zip code of the list
    del city_and_zip_code_list[last_index]    
    
    name_town = city_and_zip_code_list
    
    # if the name of town has more than one word, join them
    name_town = ' '.join(name_town)
    
    name_town_vector.append(name_town)
    zip_code_vector.append(zip_code)
```


```python
print(name_town_vector)
```

    ['Towson', 'Owings Mill', 'Owings Mill', 'Owings Mill', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Laurel', 'Randallstown', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Laurel', 'Owings Mill', 'Baltimore', 'Baltimore', 'Glen Burnie', 'Baltimore', 'Middle River', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Reisterstown', 'Reisterstown', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Windsor Mill', 'Baltimore', 'Baltimore', 'Windsor Mill', 'Baltimore', 'Baltimore', 'Baltimore', 'Pikesville', 'Baltimore', 'Baltimore', 'Baltimore', 'Edgewood', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Baltimore', 'Pasadena', 'Towson', 'Baltimore', 'Baltimore', 'Laurel', 'Rosedale', 'Baltimore', 'Baltimore', 'Windsor Mill', 'Baltimore', 'Baltimore', 'Pikesville']



```python
print(zip_code_vector)
```

    ['21204', '21117', '21117', '21117', '21239', '21244', '21206', '21236', '21217', '21217', '21205', '20723', '21133', '21224', '21224', '21224', '21212', '21237', '21218', '21218', '21230', '21202', '21202', '21201', '21244', '20723', '21117', '21217', '21224', '21060', '21218', '21220', '21224', '21216', '21230', '21201', '21136', '21136', '21223', '21218', '21236', '21236', '21218', '21206', '21244', '21213', '21206', '21244', '21212', '21221', '21239', '21208', '21218', '21224', '21224', '21040', '21227', '21230', '21221', '21237', '21213', '21213', '21213', '21221', '21213', '21122', '21204', '21211', '21201', '20707', '21237', '21215', '21224', '21244', '21229', '21229', '21208']



```python
bVendors.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 77 entries, 0 to 76
    Data columns (total 10 columns):
    Id            77 non-null int64
    LicenseNum    77 non-null object
    VendorName    77 non-null object
    VendorAddr    77 non-null object
    ItemsSold     77 non-null object
    Cart_Descr    77 non-null object
    St            77 non-null object
    location      77 non-null object
    hotdog        77 non-null bool
    pizza         77 non-null bool
    dtypes: bool(2), int64(1), object(7)
    memory usage: 5.0+ KB


Put the vectors with name of town and zip code in the <tt>bVendors</tt>:


```python
bVendors["name_town"] = name_town_vector
bVendors["zip_code"] = zip_code_vector

bVendors.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 77 entries, 0 to 76
    Data columns (total 12 columns):
    Id            77 non-null int64
    LicenseNum    77 non-null object
    VendorName    77 non-null object
    VendorAddr    77 non-null object
    ItemsSold     77 non-null object
    Cart_Descr    77 non-null object
    St            77 non-null object
    location      77 non-null object
    hotdog        77 non-null bool
    pizza         77 non-null bool
    name_town     77 non-null object
    zip_code      77 non-null object
    dtypes: bool(2), int64(1), object(9)
    memory usage: 6.2+ KB



```python
bVendors[["name_town", "zip_code", "location"]].head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name_town</th>
      <th>zip_code</th>
      <th>location</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Towson</td>
      <td>21204</td>
      <td>Towson 21204\n(39.28540000000, -76.62260000000)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Owings Mill</td>
      <td>21117</td>
      <td>Owings Mill 21117\n(39.29860000000, -76.612800...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Owings Mill</td>
      <td>21117</td>
      <td>Owings Mill 21117\n(39.28920000000, -76.626700...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Owings Mill</td>
      <td>21117</td>
      <td>Owings Mill 21117\n(39.28870000000, -76.613600...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Baltimore</td>
      <td>21239</td>
      <td>Baltimore 21239\n(39.27920000000, -76.62200000...</td>
    </tr>
  </tbody>
</table>
</div>



It is all OK.
