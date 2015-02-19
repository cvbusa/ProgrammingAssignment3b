#
source("./rankall.R")
#
tail(rankall("pneumonia"),3)
tail(rankall("pneumonia",20),3)
tail(rankall("pneumonia","worst"),3)
#
head(rankall("heart attack",20), 10)
tail(rankall("pneumonia","worst"),3)
tail(rankall("heart failure"),10)

#
source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R")
#
submit()

