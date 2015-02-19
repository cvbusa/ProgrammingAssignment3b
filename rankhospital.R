#

rankhospital <-function(state, outcome, num = "best")
{  
     ## Read outcome data
     source("./getdata.R")
     # dfoutcome  : outcome-of-care-measure.csv
     # dfhospital : hospital-data.csv
     dfcolnames <-data.frame(colnames = names(dfoutcome))
     # column  2 : hospital
     # column  7 : state
     # column 11 : death rate heart attack
     # column 17 : death rate heart failure
     # column 23 : death rate pneumonia
     dr_cols <-c(2,7,11,17,23)   # hospital, state and 3 death rate columns
     names(dfoutcome)[dr_cols] <-c("hospital","state","heart attack",
                                           "heart failure","pneumonia")
     dfDeathRate <-dfoutcome[, dr_cols]  # 
     # convert 3 death rate columns to numeric
     num_cols <-c("heart attack","heart failure","pneumonia")
     dfDeathRate[,num_cols] = suppressWarnings(apply(dfDeathRate[,num_cols], 2,
                                                     function(x) as.numeric(x)))
     
     ## Check that state and outcome are valid
     if (!sum(grepl(state, dfDeathRate$state))) {stop("invalid state")}
     if (!sum(grepl(outcome, names(dfDeathRate)))) {stop("invalid outcome")}
     
     # remove incomplete cases for the selected outcome
     dfDeathRate <-dfDeathRate[!is.na(dfDeathRate[[outcome]]),]

     ## Return hospital name of the selected state, outcome and rank
     # filter by state
     dfDeathRate <-dfDeathRate[dfDeathRate$state == state,]
     # sort descending by outcome and by hospital
     dfDeathRate <-dfDeathRate[order(dfDeathRate[[outcome]],dfDeathRate$hospital),]
     # select the name of the ranked hospital
     if (num == "best") {num <-1}
     if (num == "worst") {num <-nrow(dfDeathRate)}
     dfDeathRate[num,"hospital"]
}
