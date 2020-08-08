#---------------------------------------
# This script sets out to apply catch22
# to post-pill time-series data for each
# age group to determine statistical
# differences for just binary ages
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
import matplotlib.lines as mlines
sns.set(style = 'darkgrid')

#%%

# Load data

d = pd.read_csv("/Users/trenthenderson/Documents/R/abs-births-analysis/output/for-catch22.csv")

# Filter to post-pill introduction

d1 = d[d['year'] >= 1960]

#%%

# Aggregate data to just 30-40 and 'everyone else'

data = [['15-19', 0], ['20-24', 0], ['25-29', 0], ['30-34', 1], ['35-39', 1], ['40-44', 0],
        ['45-49', 0]] 
  
df = pd.DataFrame(data, columns = ['age_group', 'category']) 

d3 = pd.merge(d1, 
              df[['age_group','category']], 
              on = 'age_group')

#%%

d4 = d3.groupby(['category', 'year'], as_index = False)['value'].agg(['mean'])

d4 = d4.reset_index()

#%%

# Make function to extract just the values column as a numpy array

def the_extractor(data,val):
    
    d5 = data
    
    d5 = d5[d5['category'] == val]
    
    d6 = d5[['mean']]
    
    d6 = d6.to_numpy()
    
    return d6
    
#%%

# Make dataframes for each age group

did_recover = the_extractor(d4,1)
did_not_recover = the_extractor(d4,0)

#%%

# Apply catch22

did_recover_output = pd.DataFrame.from_dict(catch22_all(did_recover))
did_recover_output['category'] = 1

did_not_recover_output = pd.DataFrame.from_dict(catch22_all(did_not_recover))
did_not_recover_output['category'] = 0

#%%

# Bind all together

final = did_recover_output
final = final.append(did_not_recover_output)

# Recode binary to words

final['category_word'] = ['Not Aged 30-39' if a == 0 else 'Aged 30-39' for a in final['category']]

#%%

did_clean = did_recover_output.rename(columns = {'values': 'did_recover_value'})
did_clean = did_clean.drop('category', 1)

did_not_clean = did_not_recover_output.rename(columns = {'values': 'did_not_recover_value'})
did_not_clean = did_not_clean.drop('category', 1)

final1 = pd.merge(did_clean, 
              did_not_clean[['names', 'did_not_recover_value']])

final1['the_diff'] = final1['did_recover_value'] - final1['did_not_recover_value']

final1['the_rank'] = final1['the_diff'].rank()

final1 = final1.sort_values(by = 'the_rank', ascending = 0)

#%%

#------------- FINAL DOTPLOT ------------------------

# Func to draw line segment

def newline(p1, p2, color = 'black'):
    ax = plt.gca()
    l = mlines.Line2D([p1[0],p2[0]], [p1[1],p2[1]], color = '#05445E')
    ax.add_line(l)
    return l

# Figure and Axes

fig, ax = plt.subplots(1,1, figsize = (14,14))

# Actual dots

ax.scatter(y = final1['names'], x = final1['did_recover_value'], s = 150, 
           color = '#FD62AD', alpha = 0.9, label = 'Aged 30-39')
ax.scatter(y = final1['names'], x = final1['did_not_recover_value'], s = 150, 
           color = '#A0E7E5', alpha = 0.9, label = 'Not aged 30-39')

# Line Segments

for i, p1, p2 in zip(final1['names'], final1['did_recover_value'], final1['did_not_recover_value']):
    newline([p1, i], [p2, i])
    
# Titles

ax.set_title("Comparison of catch22 statistics by age group category")
ax.set(xlabel = "Value", ylabel = 'Time series statistic')

plt.legend(loc = "upper right")

plt.tight_layout()

plt.savefig('/Users/trenthenderson/Documents/R/abs-births-analysis/output/catch22-agg-output.png', dpi = 1000)

