library(jsonlite)
library(dplyr)
#Input data
url107 = "/Users/caichengyun/Documents/User/CGU/Subject/四下/Big_Data_Analytical_Methods/HWs/108bigdatacguim-hw1-jcratebo703/jsonFile/107年各教育程度別初任人員每人每月經常性薪資─按大職類分.json"
url104 = "http://ipgod.nchc.org.tw/dataset/b6f36b72-0c4a-4b60-9254-1904e180ddb1/resource/63ecb4a9-f634-45f4-8b38-684b72cf95ba/download/0df38b73f75962d5468a11942578cce5.json"

#Clean & manipulation
Df104 = fromJSON(url104)
Df107 = fromJSON(url107)
Df107 = data.frame(lapply(Df107, function(x) {
  gsub("—|…", "", x)
  }))
Df104 = data.frame(lapply(Df104, function(x) {
  gsub("—|部門|…", "", x)
}))
Df104 = data.frame(lapply(Df104, function(x) {
  gsub("、", "_", x)
}))

Df107$經常性薪資.薪資 = as.numeric(Df107$經常性薪資.薪資)
Df104$經常性薪資.薪資 = as.numeric(Df104$經常性薪資.薪資)

Df107$SalaryIncreaseRatio = Df107$經常性薪資.薪資/Df104$經常性薪資.薪資

#sort

Df107 = Df107[order(Df107$SalaryIncreaseRatio, decreasing = T),]

#Q1
Df107 %>%
  filter(SalaryIncreaseRatio>1) %>%
  select(大職業別) %>%
  head(10)
str(Df107)

#Q2
Df107 %>%
  filter(SalaryIncreaseRatio>1.05) %>%
  select(大職業別)
str(Df107)

#Q3
Df107$大職業別 = as.character(Df107$大職業別)
Df104$經常性薪資.薪資 = as.numeric(Df104$經常性薪資.薪資)
str = strsplit(Df107$大職業別,"-")

splitFunc =  function(){
  
}

for(n in 1:nrow(Df107)){
  Df107$Category[n] = str[[n]][1]
  print(str[[n]][1])
}

table(Df107$Category)




