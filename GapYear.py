# -*- coding: utf-8 -*-
"""
@author:  Han Li (from SSCC to SSCCF)

"""
import pandas as pd

# Load the CSV file
file_path = '/data/SSCC.csv'

# Reading the CSV file, using 'ISO-8859-1' encoding to handle any non-standard characters
df = pd.read_csv(file_path, encoding='ISO-8859-1')

# Group by CountyID1 and find the earliest installation year for each county
earliest_install_by_county = df.groupby('CountyID1')['Year_Insta'].min()

# For poor schools, filter the dataframe where poor_schoo = 1, then group by CountyID1 and find the earliest installation year
earliest_install_poor_schools = df[df['poor_schoo'] == 1].groupby('CountyID1')['Year_Insta'].min()

# For non-white schools, filter the dataframe where white_scho = 0, then group by CountyID1 and find the earliest installation year
earliest_install_non_white_schools = df[df['white_scho'] == 0].groupby('CountyID1')['Year_Insta'].min()

# Merge these results back into the original dataframe
df = df.merge(earliest_install_by_county.rename('Earliest_Install_Year_County'), on='CountyID1', how='left')
df = df.merge(earliest_install_poor_schools.rename('Earliest_Install_Year_Poor_School'), on='CountyID1', how='left')
df = df.merge(earliest_install_non_white_schools.rename('Earliest_Install_Year_Non_White_School'), on='CountyID1', how='left')

# Displaying the first few rows of the updated dataframe to verify the changes
print(df.head())

# Saving the updated dataframe as a new CSV file (optional)
new_file_path = '/data/SSCCF.csv'
df.to_csv(new_file_path, index=False)
