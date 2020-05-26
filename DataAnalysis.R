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
  }),stringsAsFactors = F)
Df104 = data.frame(lapply(Df104, function(x) {
  gsub("—|部門|…", "", x)
}),stringsAsFactors = F)
Df104 = data.frame(lapply(Df104, function(x) {
  gsub("、", "_", x)
}),stringsAsFactors = F)

Df107$經常性薪資.薪資 = as.numeric(Df107$經常性薪資.薪資)
Df104$經常性薪資.薪資 = as.numeric(Df104$經常性薪資.薪資)

Df107$SalaryIncreaseRatio = Df107$經常性薪資.薪資/Df104$經常性薪資.薪資

#sort

Df107 = Df107[order(Df107$SalaryIncreaseRatio, decreasing = T),]

#Q1
Df107sort = Df107 %>%
  filter(SalaryIncreaseRatio>1) %>%
  select(大職業別,SalaryIncreaseRatio)
  
head(Df107sort,10)
str(Df107)

#Q2
Over5 = Df107 %>%
  filter(SalaryIncreaseRatio>1.05) %>%
  select(大職業別)

head(Over5,10)

#Q3
Df107$大職業別 = as.character(Df107$大職業別)
Df104$經常性薪資.薪資 = as.numeric(Df104$經常性薪資.薪資)
str = strsplit(Df107$大職業別,"-")

for(n in 1:nrow(Df107)){
  Df107$Category[n] = str[[n]][1]
  print(str[[n]][1])
}

table(Df107$Category)

#Q4
Df107$經常性薪資.女.男 = as.numeric(Df107$經常性薪資.女.男)
Df104$經常性薪資.女.男 = as.numeric(Df104$經常性薪資.女.男)

maleOrder107 = Df107 %>%
  filter(經常性薪資.女.男<100) %>%
  select(大職業別, 經常性薪資.女.男)

maleOrder107 = maleOrder107[order(maleOrder107$經常性薪資.女.男),]
maleOrder107

maleOrder104 = Df104 %>%
  filter(經常性薪資.女.男<100) %>%
  select(大職業別, 經常性薪資.女.男)

maleOrder104 = maleOrder104[order(maleOrder104$經常性薪資.女.男),]
maleOrder104

femaleOrder107 = Df107 %>%
  filter(經常性薪資.女.男>100) %>%
  select(大職業別, 經常性薪資.女.男)

femaleOrder107 = femaleOrder107[order(femaleOrder107$經常性薪資.女.男, decreasing = T),]
femaleOrder107

femaleOrder104 = Df104 %>%
  filter(經常性薪資.女.男>100) %>%
  select(大職業別, 經常性薪資.女.男)

femaleOrder104 = femaleOrder104[order(femaleOrder104$經常性薪資.女.男, decreasing = T),]
femaleOrder104

str(Df107)

#Q5
Df107$大學.薪資 = as.numeric(Df107$大學.薪資)
Df107$研究所.薪資 = as.numeric(Df107$研究所.薪資)

Df107$IncreaseFromDegree = Df107$研究所.薪資/Df107$大學.薪資
ms107 = Df107 %>%
  select(大職業別, 研究所.薪資, 大學.薪資, IncreaseFromDegree)

ms107 = ms107[order(ms107$IncreaseFromDegree, decreasing = T),]
ms107

#Q6

#不動產業-專業人員、金融及保險業-技術員及助理專業人員、工業-專業人員、製造業-事務支援人員、服務業-專業人員
Df107$IncreaseAmount = Df107$研究所.薪資-Df107$大學.薪資
position5 = Df107 %>%
  select(大職業別, 研究所.薪資, 大學.薪資, IncreaseAmount) %>%
  filter(大職業別 %in% c("不動產業-專業人員","金融及保險業-技術員及助理專業人員","工業-專業人員","製造業-事務支援人員","服務業-專業人員"))
position5


