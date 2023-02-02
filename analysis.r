full_data <- read.csv("./SAS_Report_Final.csv", header=FALSE)
colnames(full_data) <- c("District_Name", "District_Code","Circle_Name", "Circle_Code","Block_Code",
                         "School_Code","Rural_Urban", "Management","School_Category_Type","Student_Code",
                         "Gender","Social_Category","Religion","Present_Class","Present_Section", "EXTRA",
                         "Physical_Handicaped", "Medium", "IsSubmitted", "IsPresent","total",
                         "ENGLISH","EVS","LANGUAGE","MATH","SCIENCE","SOCIAL.SCIENCE")

# CLEAN DATA
## Remove null values
full_data$ENGLISH[which(full_data$ENGLISH == "NULL")] <- NA
full_data$EVS[which(full_data$EVS == "NULL")] <- NA
full_data$LANGUAGE[which(full_data$LANGUAGE == "NULL")] <- NA
full_data$MATH[which(full_data$MATH == "NULL")] <- NA
full_data$SCIENCE[which(full_data$SCIENCE == "NULL")] <- NA
full_data$SOCIAL.SCIENCE[which(full_data$SOCIAL.SCIENCE == "NULL")] <- NA
## Set as integers
full_data$ENGLISH <- as.integer(full_data$ENGLISH)
full_data$LANGUAGE <- as.integer(full_data$LANGUAGE)
full_data$MATH <- as.integer(full_data$MATH)
full_data$EVS <- as.integer(full_data$EVS)
full_data$SCIENCE <- as.integer(full_data$SCIENCE)
full_data$SOCIAL.SCIENCE <- as.integer(full_data$SOCIAL.SCIENCE)

## fix data with NULL values
full_data$Religion[which(full_data$Religion == "NULL")] <- "OTHERS"
full_data$Physical_Handicaped[which(full_data$Physical_Handicaped == "NULL")] <- "NO"
full_data$Social_Category[which(full_data$Social_Category == "NULL")] <- "GENERAL"

# Total marks obtained in all subjects
full_data$`Total.Score` <- rowSums(full_data[,22:27], na.rm=TRUE)

# create a list of all the unique values
columns <- colnames(full_data)
districts <- sort(unique(full_data$District_Name))
circles <- sort(unique(full_data$Circle_Name))
genders <- sort(unique(full_data$Gender))
mgmt <- sort(unique(full_data$Management))
soc_category <- sort(unique(full_data$Social_Category))
location <- c("RURAL", "URBAN")
classes <- c("CLASS III", "CLASS V", "CLASS VIII", "CLASS X")
subjects <- c("ENGLISH", "EVS", "LANGUAGE", "MATH", "SCIENCE", "SOCIAL.SCIENCE", "ALL.SUBJECTS")

# create a map of the column names with column numbers
column_map <- list()
column_map[["districts"]] <- 1
column_map[["circles"]] <- 3
column_map[["genders"]] <- 11
column_map[["mgmt"]] <- 8
column_map[["soc_category"]] <- 12
column_map[["location"]] <- 7

################################################################################################################################
############################################### State level Results ############################################################
################################################################################################################################

# start a new function
# level_one_category can be districts, circles, mgmt, or location
get_subjectwise_average_results <- function(classes, level_one_category_array, level_one_colnumber, level_two_category_array, level_two_colnumber) {
  # initiliase a data frame to store results
  results <- data.frame()
  # loop over all the classes
  for (c in 1:(length(classes)+1)) {
    # if c is equal to the length of the array, then select all the data
    if (c == length(classes)+1) {
      class <- "ALL.CLASSES"
      class_data <- full_data
    } else {
      # select the item from the array
      class <- classes[c]
      # select the data for the class
      class_data <- full_data[which(full_data$Present_Class == class),]
    }
    # initialize a data frame to store the results
    class_results <- data.frame()
    # loop over all the values in the level_one_category
    for (i in 1:(length(level_one_category_array)+1)) {
      # if i is equal to the length of the array, then select all the data
      if (i == length(level_one_category_array)+1) {
        level_one_item <- "STATE"
        level_one_data <- class_data
      } else {
        # select the item from the array
        level_one_item <- level_one_category_array[i]
        # segment the data for that item
        level_one_data <- class_data[which(class_data[, level_one_colnumber] == level_one_item),]
      }
      # initialize a data frame to store the results
      level_one_results <- data.frame()
      # loop over all the values in the level_two_category
      for (j in 1:(length(level_two_category_array)+1)) {
        if (j == length(level_two_category_array)+1) {
          level_two_item <- "ALL"
          level_two_data <- level_one_data
        } else {
          # select the item from the array
          level_two_item <- level_two_category_array[j]
          # segment the data for that item
          level_two_data <- level_one_data[which(level_one_data[, level_two_colnumber] == level_two_item),]
        }
        # select the data for the subjects
        level_two_data <- level_two_data[,c(22:27)]
        # calculate the mean for each subject
        level_two_data_means <- colMeans(level_two_data, na.rm=TRUE)
        # calculate the number of students with zero marks in each subject
        level_two_data_zero <- colSums(level_two_data == 0, na.rm=TRUE)
        # calculate the percentage of students with zero marks in each subject
        level_two_data_zero_percentage <- 100*level_two_data_zero/length(level_two_data[,1])
        # calculate the number of students who scored less than 40%, 40-60%, 60-80%, and 80-100% in each subject
        level_two_data_40 <- colSums(level_two_data < 4, na.rm=TRUE)
        level_two_data_40_60 <- colSums(level_two_data >= 4 & level_two_data < 6, na.rm=TRUE)
        level_two_data_60_80 <- colSums(level_two_data >= 6 & level_two_data < 8, na.rm=TRUE)
        level_two_data_80_100 <- colSums(level_two_data >= 8, na.rm=TRUE)
        # calculate the percentage of students who scored less than 40%, 40-60%, 60-80%, and 80-100% in each subject
        level_two_data_40_percentage <- 100*level_two_data_40/length(level_two_data[,1])
        level_two_data_40_60_percentage <- 100*level_two_data_40_60/length(level_two_data[,1])
        level_two_data_60_80_percentage <- 100*level_two_data_60_80/length(level_two_data[,1])
        level_two_data_80_100_percentage <- 100*level_two_data_80_100/length(level_two_data[,1])
        # create a data frame with the results
        level_two_data <- data.frame(class, level_one_item, level_two_item, level_two_data_means, level_two_data_zero, level_two_data_zero_percentage,
                                      level_two_data_40, level_two_data_40_60, level_two_data_60_80, level_two_data_80_100,
                                     level_two_data_40_percentage, level_two_data_40_60_percentage, level_two_data_60_80_percentage, level_two_data_80_100_percentage)
        # set subject names
        level_two_data$subjects <- row.names(level_two_data)
        # add district name if running for circles
        if (level_one_colnumber == 3) {
          level_two_data$District <- full_data$District_Name[which(full_data$Circle_Name == level_one_item)[1]]
        }
        # add the data to level_one_results
        level_one_results <- rbind(level_one_results, level_two_data)
      }
      # add the data to level_one_results
      class_results <- rbind(class_results, level_one_results)
    }
    # add the data to results
    results <- rbind(results, class_results)
  }
  # write the data to a csv file
  if (level_one_colnumber == 1) {
    # set the column names
    colnames(results) <- c("Class", "Level.One", "Level.Two", "Average.Score", "Zero.Marks", "Zero.Marks.Percentage", 
                           "Less.Than.40", "40-60", "60-80", "80-100", 
                           "Less.Than.40.Percentage","40-60.Percentage","60-80.Percentage","80-100.Percentage",
                           "Subject")
    # reorganise columns
    results <- results[,c(2,3,1,15,4:14)]
    write.csv(results, "./CSV/results-district.csv", row.names=FALSE)
  } else if (level_one_colnumber == 3) {
    # set the column names
    colnames(results) <- c("Class", "Level.One", "Level.Two", "Average.Score", "Zero.Marks", "Zero.Marks.Percentage", 
                           "Less.Than.40", "40-60", "60-80", "80-100", 
                           "Less.Than.40.Percentage","40-60.Percentage","60-80.Percentage","80-100.Percentage",
                           "Subject", "District")
    # reorganise columns
    results <- results[,c(16,2,3,1,15,4:14)]
    write.csv(results, "./CSV/results-circle.csv", row.names=FALSE)
  }
}
# Districts
# get_subjectwise_average_results(classes,districts,1,genders,11)
# get_subjectwise_average_results(classes,districts,1,soc_category,12)
# get_subjectwise_average_results(classes,districts,1,location,7)
# get_subjectwise_average_results(classes,districts,1,mgmt,8)
# Circles
# get_subjectwise_average_results(classes,circles,3,genders,11)
# get_subjectwise_average_results(classes,circles,3,soc_category,12)
# get_subjectwise_average_results(classes,circles,3,location,7)
get_subjectwise_average_results(classes,circles,3,mgmt,8)