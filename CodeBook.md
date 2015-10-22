## Codebook GetData Course Project

This file delivers all information about the run_analysis.R code script.

The data for the project can be found in its raw version as follows: 
  [a link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
  


### Files

The following input datasets were used:
  
* activity_labels.txt
* Y_test.txt
* Y_train.txt
* X_test.txt
* Y_train.txt
* subject_train.txt
* subject_test.txt
* features.txt


Out of this several different datasets were created, fulfilling the assignment conditions for the course project.

### Created Datasets

* Subject_data (merged train and test subject data)
* Activity_data (merged activity data for train and test)
* Feature_data ( merged features for test and train)
* total_data (merged dataset out of Subject_data, Activity_data, Feature_data)
* extracted_data (subset of total data containing only measurements on the mean and standard deviation)
* descriptive_data (extracted_data cleaned and given descriptive column names)
* tidy_data (the final output data)

  
### Final Output
tidy_data.txt file uploaded into course project page.

