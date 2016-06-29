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
    
    ### DATA CLEANING/VALIDATION ###
    
    # taking out Rows that have a gestat. birth that is outside the realm of the calculator, 
    # or if it's not numeric and saving them for later as "badRows"
    badRows<-inFile[(inFile$gagebrth>300) | (inFile$gagebrth<=232) | !is.numeric(inFile$gagebrth),]
    
    #keeping the good rows that can go ahead and be pushed through the calc. 
    goodRows<-inFile[!((inFile$gagebrth>300) | (inFile$gagebrth<=232) | !is.numeric(inFile$gagebrth)),]
    
    
    if((input$len)==TRUE){
      goodRows$lenZScore <- igb_lencm2zscore(goodRows$gagebrth, goodRows$lencm, sex = goodRows$sex)
      
    }
    
    if((input$wt)==TRUE){
      goodRows$wtZScore <- igb_wtkg2zscore(goodRows$gagebrth, goodRows$wtkg, sex = goodRows$sex)
      
    }
    
    if((input$headcm)==TRUE){
      goodRows$headZScore <- igb_hcircm2zscore(goodRows$gagebrth, goodRows$hcircm, sex = goodRows$sex)
    }
    
    
    # adding back the "badRows" 
    mydata <- merge(goodRows, badRows, by=c("subjid", "sex" ,"gagebrth", "hcircm" ,"wtkg" ,"lencm"),
                    all=TRUE)
    
    return(mydata)
    
  })
  
  output$table <- renderTable({
    datasetInput()
  })
  
  
  ## this is for illustrative purposes to show what format the files should be in
  output$table2 <- renderTable({
    header  = c("subjid",  "sex",	"gagebrth",	"hcircm",	"wtkg",	"lencm") 
    format  = c("Numeric","Male or Female","Gestational age at birth (days)","Head circumference (cm)",
                "weight (kg)", "Recumbent length (cm)")
    df = data.frame(header, format) 
    
  })
  
  ## an option to download the generated csv
  output$downloadData <- downloadHandler(
 
    filename = function() { paste0("IntergrowthFile_",Sys.Date(), '.csv') },
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
