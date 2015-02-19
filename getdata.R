# User ID     9065158
# Submission Login	charles@charlesbrown.com
# Submission Password	Err86Mf4e2
# Course  rprog-011

# data    "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"

# source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R") ; submit()

strDataDir <-""
if(strDataDir == "") {strfsep <- ""} else {strfsep <- "/"}
strPathDataDir <-file.path(getwd(), strDataDir, fsep = strfsep)

if(!file.exists(strPathDataDir)) {dir.create(strPathDataDir)}

strUrl <-"https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"
strZipFilename <-"data3.zip"
strPathZipFilename <-file.path(strPathDataDir, strZipFilename, fsep = "/")
if(!file.exists(strPathZipFilename))
{
     download.file(strUrl, strPathZipFilename, method = "curl", mode = "wb")
}

listOfFiles <-unzip(strPathZipFilename, exdir = strPathDataDir)

dfoutcome  <-read.csv(listOfFiles[3], colClasses = "character")
dfhospital <-read.csv(listOfFiles[2], colClasses = "character")
