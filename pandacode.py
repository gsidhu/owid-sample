import pandas as pd
filepath = "./SAS_Report_Final.csv"
full_data = pd.read_csv(filepath, header=None)
full_data.columns = ["District_Name", "District_Code","Circle_Name", "Circle_Code","Block_Code",
                      "School_Code","Rural_Urban", "Management","School_Category_Type","Student_Code",
                      "Gender","Social_Category","Religion","Present_Class","Present_Section", "EXTRA",
                      "Physical_Handicaped", "Medium", "IsSubmitted", "IsPresent","total",
                      "ENGLISH","EVS","LANGUAGE","MATH","SCIENCE","SOCIAL.SCIENCE"]

# Helper Variables
subjects = ["ENGLISH", "EVS", "LANGUAGE", "MATH", "SCIENCE", "SOCIAL.SCIENCE"]

# CLEAN DATA
## If all subjects are null, then remove the row
full_data = full_data[full_data[subjects].notnull().any(axis=1)]

## Set all notnull values in subject columns as integers
for subject in subjects:
    full_data.loc[full_data[subject].notnull(), subject] = full_data.loc[full_data[subject].notnull(), subject].astype(int)

## Calculate total marks obtained in all subjects
full_data["Total.Score"] = full_data[subjects].sum(axis=1)

# create a list of all the unique values
columns = full_data.columns
districts = full_data["District_Name"].unique()
circles = full_data["Circle_Name"].unique()
genders = full_data["Gender"].unique()
mgmt = full_data["Management"].unique()
soc_category = full_data["Social_Category"].unique()
location = full_data["Rural_Urban"].unique()
classes = sorted(full_data["Present_Class"].unique())
subjects.append("ALL.SUBJECTS")

# create a map of the column numbers and arrays
column_map = {}
# column_map[0] = districts
# column_map[2] = circles
column_map[10] = genders
column_map[7] = mgmt
column_map[11] = soc_category
column_map[6] = location

###################################################
################# Result Analysis #################
###################################################

# level_one_category can be districts or circles
def get_subjectwise_average_results(level_one_category_array, level_one_colnumber, level_two_category_array, level_two_colnumber):
    # initiliase a data frame to store results
    results = pd.DataFrame()
    # loop over all the classes
    for c in range(len(classes)+1):
        # if c is equal to the length of the array, then select all the data
        if c == len(classes):
            selected_class = "ALL.CLASSES"
            class_data = full_data
        else:
            # select the item from the array
            selected_class = classes[c]
            # select the data for the class
            class_data = full_data[full_data["Present_Class"] == selected_class]
        # initialize a data frame to store the results
        class_results = pd.DataFrame()
        # loop over all the values in the level_one_category
        for i in range(len(level_one_category_array)+1):
            # if i is equal to the length of the array, then select all the data
            if i == len(level_one_category_array):
                level_one_item = "STATE"
                level_one_data = class_data
            else:
                # select the item from the array
                level_one_item = level_one_category_array[i]
                # segment the data for that item
                level_one_data = class_data[class_data.iloc[:, level_one_colnumber] == level_one_item]
            # initialize a data frame to store the results
            level_one_results = pd.DataFrame()
            # loop over all the values in the level_two_category
            for j in range(len(level_two_category_array)+1):
                if j == len(level_two_category_array):
                    level_two_item = "ALL"
                    level_two_data = level_one_data
                else:
                    # select the item from the array
                    level_two_item = level_two_category_array[j]
                    # segment the data for that item
                    level_two_data = level_one_data[level_one_data.iloc[:, level_two_colnumber] == level_two_item]
                # select the data for the subjects
                level_two_data = level_two_data.iloc[:, 21:28]
                # calculate the mean for each subject
                level_two_data_means = level_two_data.mean(axis=0)
                # calculate the number of students with zero marks in each subject
                level_two_data_zero = level_two_data.apply(lambda x: (x == 0).sum(), axis=0)
                # calculate the percentage of students with zero marks in each subject
                level_two_data_zero_percent = level_two_data_zero / level_two_data.shape[0] * 100
                # calculate the number of students who scored less than 40%, 40-60%, 60-80%, and 80-100% in each subject
                level_two_data_40 = level_two_data.apply(lambda x: (x < 4).sum(), axis=0)
                level_two_data_40_60 = level_two_data.apply(lambda x: ((x >= 4) & (x < 6)).sum(), axis=0)
                level_two_data_60_80 = level_two_data.apply(lambda x: ((x >= 6) & (x < 8)).sum(), axis=0)
                level_two_data_80_100 = level_two_data.apply(lambda x: (x >= 8).sum(), axis=0)
                # calculate the percentage of students who scored less than 40%, 40-60%, 60-80%, and 80-100% in each subject
                level_two_data_40_percent = level_two_data_40 / level_two_data.shape[0] * 100
                level_two_data_40_60_percent = level_two_data_40_60 / level_two_data.shape[0] * 100
                level_two_data_60_80_percent = level_two_data_60_80 / level_two_data.shape[0] * 100
                level_two_data_80_100_percent = level_two_data_80_100 / level_two_data.shape[0] * 100
                # create a data frame with the results
                level_two_data = pd.DataFrame({"class": selected_class, "level_one_item": level_one_item, "level_two_item": level_two_item, "level_two_data_means": level_two_data_means, "level_two_data_zero": level_two_data_zero, "level_two_data_zero_percent": level_two_data_zero_percent,
                "level_two_data_40": level_two_data_40, "level_two_data_40_60": level_two_data_40_60, "level_two_data_60_80": level_two_data_60_80, "level_two_data_80_100": level_two_data_80_100,
                "level_two_data_40_percent": level_two_data_40_percent, "level_two_data_40_60_percent": level_two_data_40_60_percent, "level_two_data_60_80_percent": level_two_data_60_80_percent, "level_two_data_80_100_percent": level_two_data_80_100_percent})
                # add a new column called subjects and set it to the subjects array
                level_two_data["subjects"] = subjects
                # add the data to level_one_results
                level_one_results = pd.concat([level_one_results, level_two_data])
            # add the data to class_results
            class_results = pd.concat([class_results, level_one_results])
        # add the data to results
        results = pd.concat([results, class_results])
    
    if level_one_colnumber == 2:
        filename = "Circle_" + str(full_data.columns[key])
        # set the column names in results
        results.columns = ["Class", "Level.One", "Level.Two", "Average.Score", "Zero.Marks", "Zero.Marks.Percentage", 
                  "Less.Than.40", "40-60", "60-80", "80-100", "Less.Than.40.Percentage","40-60.Percentage",
                  "60-80.Percentage","80-100.Percentage","Subject","District"]
    else:
        filename = "District_" + str(full_data.columns[key])
        results.columns = ["Class", "Level.One", "Level.Two", "Average.Score", "Zero.Marks", "Zero.Marks.Percentage", 
                  "Less.Than.40", "40-60", "60-80", "80-100", "Less.Than.40.Percentage","40-60.Percentage",
                  "60-80.Percentage","80-100.Percentage","Subject"]
    # write the data to a csv file
    results.to_csv("./CSV/" + filename + ".csv", index=False)

for key in column_map.keys():
    print("Running for District & " + full_data.columns[key] + "...")
    get_subjectwise_average_results(districts,0,column_map[key],key)
    print("Running for Circle & " + full_data.columns[key] + "...")
    get_subjectwise_average_results(circles,2,column_map[key],key)