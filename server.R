library(hbgd)

shinyServer(function(input, output) {
  
#### FIRST TAB ####
  
  ## Loading in the csv file
  datasetInput <- eventReactive(input$goButton, {
    
    # if there is no csv file, there will be no output
    if (is.null(input$file1))
      return(NULL)
    
    fileRead <- input$file1
    
    inFile<-read.csv(fileRead$datapath, header=T)
    
    inFile$gender<-as.numeric(as.character((inFile$gender)))
    inFile$gender<-ifelse(inFile$gender == 1, "Male", ifelse(inFile$gender == 0, "Female", NA))
    names(inFile)[names(inFile) == 'gestage'] <- 'gagebrth'
    names(inFile)[names(inFile) == 'weight'] <- 'wtkg'
    names(inFile)[names(inFile) == 'gender'] <- 'sex'
    names(inFile)[names(inFile) == 'hc_cm'] <- 'hcircm'
    
    
    inFile$gagebrth<-as.numeric(as.character((inFile$gagebrth)))
    inFile$wtkg<-as.numeric(as.character((inFile$wtkg)))
    inFile$hcircm<-as.numeric(as.character((inFile$hcircm)))
    inFile$age_weeks<-as.numeric(as.character((inFile$age_weeks)))*7
    inFile$length<-as.numeric(as.character((inFile$length)))
    
    
    ########### ONE WHO
    
    WHOData<-inFile
    
    names(WHOData)[names(WHOData) == 'length'] <- 'htcm'
    WHOData["WHO_lenZScore"] <- NA
    WHOData["WHO_lenCentile"] <- NA
    
    WHOData["WHO_wtZScore"] <- NA
    WHOData["WHO_wtCentile"] <-NA
    
    WHOData["WHO_headZScore"] <- NA
    WHOData["WHO_headCentile"] <- NA
    
    
    badRowsWHO<-WHOData[( !is.numeric(WHOData$age_weeks) | WHOData$age_weeks<=0 | is.na(WHOData$age_weeks)) | is.na(WHOData$sex) ,]
    
    #keeping the good rows that can go ahead and be pushed through the calc. 
    # goodRowsWHO<-WHOData[( is.numeric(WHOData$age_weeks) & WHOData$age_weeks>0),]
    goodRowsWHO<-WHOData[!(WHOData$subjid %in% badRowsWHO$subjid),]
    
    ################### WHO ANALYSIS 
    
    if (nrow(goodRowsWHO) == 0){ 
    } else {
      goodRowsWHO$WHO_lenZScore <- who_htcm2zscore(goodRowsWHO$age_weeks, goodRowsWHO$htcm, sex = goodRowsWHO$sex)
      goodRowsWHO$WHO_lenCentile <- who_htcm2centile(goodRowsWHO$age_weeks, goodRowsWHO$htcm, sex = goodRowsWHO$sex)
      
      goodRowsWHO$WHO_wtZScore <- who_wtkg2zscore(goodRowsWHO$age_weeks, goodRowsWHO$wtkg, sex = goodRowsWHO$sex)
      goodRowsWHO$WHO_wtCentile <- who_wtkg2centile(goodRowsWHO$age_weeks, goodRowsWHO$wtkg, sex = goodRowsWHO$sex)
      
      goodRowsWHO$WHO_headZScore <- who_hcircm2zscore(goodRowsWHO$age_weeks, goodRowsWHO$hcircm, sex = goodRowsWHO$sex)
      goodRowsWHO$WHO_headCentile <- who_hcircm2centile(goodRowsWHO$age_weeks, goodRowsWHO$hcircm, sex = goodRowsWHO$sex)
    }
    
    WHO <- rbind(goodRowsWHO, badRowsWHO)
    names(WHO)[names(WHO) == 'htcm'] <- 'length'
    rownames(WHO)<-NULL
    
    
    ########### ONE IGB
    
    IGBData<-inFile
    
    # IGBData$age_weeks <- NULL
    names(IGBData)[names(IGBData) == 'length'] <- 'lencm'
    IGBData["igb_lenZScore"] <- NA
    IGBData["igb_lenCentile"] <- NA
    
    IGBData["igb_wtZScore"] <- NA
    IGBData["igb_wtCentile"] <-NA
    
    IGBData["igb_headZScore"] <- NA
    IGBData["igb_headCentile"] <- NA
    
    
    badRowsIGB<-IGBData[(IGBData$gagebrth>300) | (IGBData$gagebrth<=232) | !is.numeric(IGBData$gagebrth) | is.na(IGBData$gagebrth) 
                        | is.na(IGBData$sex) | (IGBData$age_weeks>0),]
    
    #keeping the good rows that can go ahead and be pushed through the calc. 
    # goodRowsIGB<-IGBData[!((inFile$gagebrth>300) | (inFile$gagebrth<=232)) & is.numeric(inFile$gagebrth),]
    
    goodRowsIGB<-IGBData[!(IGBData$subjid %in% badRowsIGB$subjid),]
    
    ################### IGB ANALYSIS 
    if (nrow(goodRowsIGB) == 0){ 
    } else {
      goodRowsIGB$igb_lenZScore <- igb_lencm2zscore(goodRowsIGB$gagebrth, goodRowsIGB$lencm, sex = goodRowsIGB$sex)
      goodRowsIGB$igb_lenCentile <- igb_lencm2centile(goodRowsIGB$gagebrth, goodRowsIGB$lencm, sex = goodRowsIGB$sex)
      
      goodRowsIGB$igb_wtZScore <- igb_wtkg2zscore(goodRowsIGB$gagebrth, goodRowsIGB$wtkg, sex = goodRowsIGB$sex)
      goodRowsIGB$igb_wtCentile <- igb_wtkg2centile(goodRowsIGB$gagebrth, goodRowsIGB$wtkg, sex = goodRowsIGB$sex)
      
      goodRowsIGB$igb_headZScore <- igb_hcircm2zscore(goodRowsIGB$gagebrth, goodRowsIGB$hcircm, sex = goodRowsIGB$sex)
      goodRowsIGB$igb_headCentile <- igb_hcircm2centile(goodRowsIGB$gagebrth, goodRowsIGB$hcircm, sex = goodRowsIGB$sex)
    }
    IGB <- rbind(goodRowsIGB, badRowsIGB)
    names(IGB)[names(IGB) == 'lencm'] <- 'length'
    
    IGB<-(IGB[!grepl('NA', rownames(IGB)),])
    
    rownames(IGB)<-NULL
    
    ###############
    
    totalDataset<-merge(IGB,WHO,by=c("subjid","sex","gagebrth","hcircm","wtkg","length","age_weeks"),all=T)
    totalDataset$age_weeks<-totalDataset$age_weeks/7
    totalDataset$sex<-ifelse(inFile$sex == "Male", 1, ifelse(inFile$sex == "Female", 0, NA))
    names(totalDataset)[names(totalDataset) == 'gagebrth'] <- 'gestage'
    names(totalDataset)[names(totalDataset) == 'wtkg'] <- 'weight'
    names(totalDataset)[names(totalDataset) == 'sex'] <- 'gender'
    names(totalDataset)[names(totalDataset) == 'hcircm'] <- 'hc_cm'
    
    return(totalDataset)
  })
  
  output$table <- renderTable({
    datasetInput()
  })
  
  
  ## this is for illustrative purposes to show what format the files should be in
  output$table2 <- renderTable({
    header  = c("subjid**",  "gender**",	"gestage**",	"hc_cm",	"weight",	"length", "age_weeks") 
    format  = c("Numeric","Numeric (Male=1, Female=0)","Gestational age at birth (days)","Head circumference (cm)",
                "weight (kg)", "Recumbent length (cm)", "Age in whole weeks")
    df = data.frame(header, format) 
    
  })
  
  ## an option to download the generated csv
  output$downloadData <- downloadHandler(
 
    filename = function() { paste0("GrowthStandardsFile_",Sys.Date(), '.csv') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )


### SECOND TAB ###
output$value <- renderPrint({input$percentile})


output$centileOutput<-renderText({
  if(input$choiceCentile==1){
    measurement<-"head circumference (cm) "
    tempCentile<-igb_centile2hcircm(input$gagebrthCentile, p = input$percentile, sex = input$sexCentile)
  }
  if(input$choiceCentile==2){
    measurement<-"length (cm)"
    tempCentile<-igb_centile2lencm(input$gagebrthCentile, p = input$percentile, sex = input$sexCentile)
  }
  if(input$choiceCentile==3){
    measurement<-"weight (kg)"
    tempCentile<-igb_centile2wtkg(input$gagebrthCentile, p = input$percentile, sex = input$sexCentile)
  }
  # return(tempCentile)
  return(c("A",input$sexCentile, "baby who is ", input$gagebrthCentile, "days old under the", paste0(input$percentile, "th Centile has a"), measurement, "of", round(tempCentile, 3)))
  
})



})
