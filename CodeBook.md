# Code Book - description of data and data transformations

## 0. Structure of this document

Part 1 contains definitions and descriptions of data transformation which were copied and slightly style-edited from the "README.txt" and "features_info.txt" files provided with the initial data set.

Part 2 contains the description of all transformations applied by the "run_analysis.R" script and the structure of the tidy data set "week4_activity_tidy.txt".


## 1. Information about initial data set

### General information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

#### For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### The initial dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

#### Feature Selection 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean

## 2. Data transformation by the "run_analysis.R" script

### loading and merging data
In a first step, the training data set ('train/X_train.txt') was  loaded to the variable *training_set* (561 features per observation) and the column names were set to the feature names provided in 'features.txt' (--> *feature_names*). 

In addition, the numeric training labels of the activities ('train/y_train.txt' --> *training_labels*, column name 'ActivityNumber') and subject information ('train/subject_train.txt'--> *training_subjects*, column name 'SubjectNumber') were loaded and attached to the data with cbind(), producing the labelled training data set *training_set_labeled*.

The identical procedure was applied to the test data set (replace "training" by "test" in all filepath and variable names), resulting in the labelled test data set *test_set_labeled*.

Subsequently, the labelled test and training data sets were merged via rbind() to the complete and labelled dataset *full_dataset*.

### data selection and transformations
From the full data set, only those features representing mean and standard deviation of the various signals were selected, plus the labels identifying Activity and Subject. 

The columns of interest were selected using a match of the column names to the strings "mean()", "std()", "ActivityNumber" or "SubjectNumber".

	grep("mean\\(\\)|std\\(\\)|ActivityNumber|SubjectNumber", colnames(full_dataset))

Escaping the parenthesis is crucial, since otherwise also the meanFreq() summary features are selected.

The selected subset of the data is stored in *mean_std_data* and contains 68 columns (66 Features + 2 identification labels (ActivityNumber, SubjectNumber)).

Next, the file 'activity_labels.txt' was loaded to the variable *activity_names*, which contains two columns (numeric code of Activity: 'ActivityNumber', and descriptive name of Activity: 'ActivityName'). 

All activity labels in the column *mean_std_data$ActivityNumber* (labels 1, 2, 3, 4, 5, 6) are replaced by their corresponding counterpart in the *activity_names* table (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) using the mapvalues() function. The column *mean_std_data$ActivityNumber* is renamed to *mean_std_data$ActivityName*.

### reshaping to tidy data set
Now, the melt() function is used to rearrange the table with the identifiers 'ActivityName' and 'SubjectNumber'. The reshaped table is written to the variable *molten_data* and has 4 columns ("ActivityName", "SubjectNumber", "variable"=Feature, "value").

In the final step of reshaping, the mean of all Features (levels of column "variable") is calculated per Activity and Subject with the dcast function

	dcast(molten_data, ActivityName+SubjectNumber~variable, mean)


The resulting summary table is stored in *tidy_df*.
To clearly indicate that the reuslting data is averaged, the suffix "-avg" is attached to all column names except for the identifiers ActivityName and SubjectNumber.

### structure of the tidy data

The tidy data contains 180 rows, i.e. one row for each combination of activity (6 activities) and subject of the experiment (30 subjects).

Each row contains 66 averaged Features for each of these combinations. The full list of columns is provided below:

 [1] "ActivityName"                   
 [2] "SubjectNumber"                  
 [3] "tBodyAcc-mean()-X-avg"          
 [4] "tBodyAcc-mean()-Y-avg"          
 [5] "tBodyAcc-mean()-Z-avg"          
 [6] "tBodyAcc-std()-X-avg"           
 [7] "tBodyAcc-std()-Y-avg"           
 [8] "tBodyAcc-std()-Z-avg"           
 [9] "tGravityAcc-mean()-X-avg"       
[10] "tGravityAcc-mean()-Y-avg"       
[11] "tGravityAcc-mean()-Z-avg"       
[12] "tGravityAcc-std()-X-avg"        
[13] "tGravityAcc-std()-Y-avg"        
[14] "tGravityAcc-std()-Z-avg"        
[15] "tBodyAccJerk-mean()-X-avg"      
[16] "tBodyAccJerk-mean()-Y-avg"      
[17] "tBodyAccJerk-mean()-Z-avg"      
[18] "tBodyAccJerk-std()-X-avg"       
[19] "tBodyAccJerk-std()-Y-avg"       
[20] "tBodyAccJerk-std()-Z-avg"       
[21] "tBodyGyro-mean()-X-avg"         
[22] "tBodyGyro-mean()-Y-avg"         
[23] "tBodyGyro-mean()-Z-avg"         
[24] "tBodyGyro-std()-X-avg"          
[25] "tBodyGyro-std()-Y-avg"          
[26] "tBodyGyro-std()-Z-avg"          
[27] "tBodyGyroJerk-mean()-X-avg"     
[28] "tBodyGyroJerk-mean()-Y-avg"     
[29] "tBodyGyroJerk-mean()-Z-avg"     
[30] "tBodyGyroJerk-std()-X-avg"      
[31] "tBodyGyroJerk-std()-Y-avg"      
[32] "tBodyGyroJerk-std()-Z-avg"      
[33] "tBodyAccMag-mean()-avg"         
[34] "tBodyAccMag-std()-avg"          
[35] "tGravityAccMag-mean()-avg"      
[36] "tGravityAccMag-std()-avg"       
[37] "tBodyAccJerkMag-mean()-avg"     
[38] "tBodyAccJerkMag-std()-avg"      
[39] "tBodyGyroMag-mean()-avg"        
[40] "tBodyGyroMag-std()-avg"         
[41] "tBodyGyroJerkMag-mean()-avg"    
[42] "tBodyGyroJerkMag-std()-avg"     
[43] "fBodyAcc-mean()-X-avg"          
[44] "fBodyAcc-mean()-Y-avg"          
[45] "fBodyAcc-mean()-Z-avg"          
[46] "fBodyAcc-std()-X-avg"           
[47] "fBodyAcc-std()-Y-avg"           
[48] "fBodyAcc-std()-Z-avg"           
[49] "fBodyAccJerk-mean()-X-avg"      
[50] "fBodyAccJerk-mean()-Y-avg"      
[51] "fBodyAccJerk-mean()-Z-avg"      
[52] "fBodyAccJerk-std()-X-avg"       
[53] "fBodyAccJerk-std()-Y-avg"       
[54] "fBodyAccJerk-std()-Z-avg"       
[55] "fBodyGyro-mean()-X-avg"         
[56] "fBodyGyro-mean()-Y-avg"         
[57] "fBodyGyro-mean()-Z-avg"         
[58] "fBodyGyro-std()-X-avg"          
[59] "fBodyGyro-std()-Y-avg"          
[60] "fBodyGyro-std()-Z-avg"          
[61] "fBodyAccMag-mean()-avg"         
[62] "fBodyAccMag-std()-avg"          
[63] "fBodyBodyAccJerkMag-mean()-avg" 
[64] "fBodyBodyAccJerkMag-std()-avg"  
[65] "fBodyBodyGyroMag-mean()-avg"    
[66] "fBodyBodyGyroMag-std()-avg"     
[67] "fBodyBodyGyroJerkMag-mean()-avg"
[68] "fBodyBodyGyroJerkMag-std()-avg" 