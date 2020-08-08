#---------------------------------------
# This script sets out to apply catch22
# to post-pill time-series data for each
# age group to determine statistical
# differences
#---------------------------------------

#---------------------------------------
# Author: Trent Henderson, 8 August 2020
#---------------------------------------

import pandas as pd
import numpy as np
import catch22
from catch22 import catch22_all
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(style = 'darkgrid')

#%%

# Load data

d = pd.read_csv("/Users/trenthenderson/Documents/R/abs-births-analysis/output/for-catch22.csv")

# Filter to post-pill introduction

d1 = d[d['year'] >= 1960]

#%%

# Make function to extract just the values column as a numpy array

def the_extractor(data,val):
    
    d2 = data
    
    d2 = d2[d2['age_group'] == val]
    
    d3 = d2[['value']]
    
    d3 = d3.to_numpy()
    
    return d3
    
#%%

# Make dataframes for each age group

age_15 = the_extractor(d1,"15-19")
age_20 = the_extractor(d1,"20-24")
age_25 = the_extractor(d1,"25-29")
age_30 = the_extractor(d1,"30-34")
age_35 = the_extractor(d1,"35-39")
age_40 = the_extractor(d1,"40-44")
age_45 = the_extractor(d1,"45-49")

#%%

# Apply catch22

age_15_output = pd.DataFrame.from_dict(catch22_all(age_15))
age_15_output['age_group'] = '15-19'

age_20_output = pd.DataFrame.from_dict(catch22_all(age_20))
age_20_output['age_group'] = '20-24'

age_25_output = pd.DataFrame.from_dict(catch22_all(age_25))
age_25_output['age_group'] = '25-29'

age_30_output = pd.DataFrame.from_dict(catch22_all(age_30))
age_30_output['age_group'] = '30-34'

age_35_output = pd.DataFrame.from_dict(catch22_all(age_35))
age_35_output['age_group'] = '35-39'

age_40_output = pd.DataFrame.from_dict(catch22_all(age_40))
age_40_output['age_group'] = '40-44'

age_45_output = pd.DataFrame.from_dict(catch22_all(age_45))
age_45_output['age_group'] = '45-49'

#%%

# Bind all together

final = age_15_output
final = final.append(age_20_output)
final = final.append(age_25_output)
final = final.append(age_30_output)
final = final.append(age_35_output)
final = final.append(age_40_output)
final = final.append(age_45_output)

#%%

g = sns.catplot(x = "age_group", y = "values", hue = "age_group",
                col = "names", data = final,
                height = 5, aspect = 1, col_wrap = 4)

plt.savefig('/Users/trenthenderson/Documents/R/abs-births-analysis/output/catch22-output.png', dpi = 1000)

plt.show(g)
