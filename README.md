# SAS_2022_Analysis
 
West Bengal State Achievement Survey 2022.

The survey was conducted for Classes 3, 5, 8 and 10 in the state of West Bengal in the month of December 2022. It covered Language, Mathematics, Science and Social Science subjects.

Data headers are – 
```
"District_Name", "District_Code","Circle_Name", "Circle_Code","Block_Code", "School_Code","Rural_Urban", "Management","School_Category_Type","Student_Code", "Gender","Social_Category","Religion","Present_Class","Present_Section", "EXTRA", "Physical_Handicaped", "Medium", "IsSubmitted", "IsPresent","total", "ENGLISH","EVS","LANGUAGE","MATH","SCIENCE","SOCIAL.SCIENCE"
```

The result headers are –
```
Class,Region,Category,Average.Score,Zero.Marks,Zero.Marks.Percentage,Less.Than.40,40-60,60-80,80-100,Less.Than.40.Percentage,40-60.Percentage,60-80.Percentage,80-100.Percentage,Subject
```

The data is analysed using `analysis.r`.

A Python version of the analysis is also available in `pandacode.py`.