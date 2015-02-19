#
rankall <-function(outcome, num = "best")
{
     ## Read outcome data and return 2 data frames
     # dfoutcome  : outcome-of-care-measure.csv
     # dfhospital : hospital-data.csv
     source("./getdata.R")

     dfcolnames <<-data.frame(colnames = names(dfoutcome))
     # column  2 : hospital
     # column  7 : state
     # column 11 : death rate heart attack
     # column 17 : death rate heart failure
     # column 23 : death rate pneumonia
     dr_cols <-c(2,7,11,17,23)   # hospital, state and 3 death rate columns
     names(dfoutcome)[dr_cols] <-c("hospital","state","heart attack",
                                   "heart failure","pneumonia")
     dfDeathRate <-dfoutcome[, dr_cols]
     # convert 3 death rate columns to numeric
     num_cols <-c("heart attack","heart failure","pneumonia")
     #
     dfDeathRate[,"heart attack"] <-suppressWarnings(as.numeric(dfDeathRate[,"heart attack"]))
     dfDeathRate[,"heart failure"] <-suppressWarnings(as.numeric(dfDeathRate[,"heart failure"]))
     dfDeathRate[,"pneumonia"] <-suppressWarnings(as.numeric(dfDeathRate[,"pneumonia"]))   
     #dfDeathRate[,num_cols] = suppressWarnings(apply(dfDeathRate[,num_cols], 2,function(x) as.numeric(x)))

     ## Check that outcome is valid : grep outcome in header names
     if (!sum(grepl(outcome, names(dfDeathRate)))) {stop("invalid outcome")}
     
     # remove incomplete cases of the selected outcome
     dfna.rm <-dfDeathRate[!is.na(dfDeathRate[[outcome]]),]
     
     ## For each state, find the hospital of the given rank
     # sort by state, by outcome and by hospital
     dfna.rm <-dfna.rm[order(dfna.rm$state,dfna.rm[[outcome]],dfna.rm$hospital),]
     # split into list of state data frames
     listdfna.rm <-split(dfna.rm,f = dfna.rm$state, drop = T)

     # create a data frame row (rowname, hospital, state) in dfRank for each state in listdfna.rm
     if (exists("dfRank")) {rm("dfRank")}
     # loop through each state data frame name in listdfna.rm 
     for (i in names(listdfna.rm))
     {
          if (!exists("dfRank")) 
          {
               dfRank <-data.frame(row.names = i, hospital =NA, state = i)
          } else
          {
               dfRank <-rbind(dfRank, data.frame(row.names = i, hospital =NA, state = i))
          }    
     }

     # create a hospital name vector (rhospitalAll) with the requested ranked hospital name
     if(exists("rhospitalAll")) {rm("rhospitalAll")}
     # loop through each state data frame element in listdfna.rm
     for (i in listdfna.rm)
     {
          xnum <-num
          lastrow <-nrow(i)
          if (num == "best") {xnum <-1}
          if (num == "worst") {xnum <-lastrow}
          #
          #i <-i[order(i[[outcome]],i$hospital),]
          #
          if(xnum <= lastrow)
          {
               #print(i[num,"hospital"])
               rhospital <-i[xnum,"hospital"]
          } else
          {
               #print(NA)
               rhospital <-"NA"
          }
          if(exists("rhospitalAll")) {rhospitalAll <-c(rhospitalAll,rhospital)} else {rhospitalAll <-rhospital}
          #print(c(xnum,lastrow))
     }
     
     # update hospital column in dfRank data frame using the rhospitalAll vector
     dfRank$hospital <-rhospitalAll
     # for debugging, push a list with data structures to the environment outside the function 
     rankall_debuglist <<-list(dfRank,listdfna.rm,dfna.rm,dfDeathRate)
     # auto-return the dfRank data frame
     dfRank   
}
