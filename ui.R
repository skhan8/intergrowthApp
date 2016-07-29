library(hbgd)



shinyUI(navbarPage("Birth Standards - CDC", 
                   ### FIRST TAB ###
                   tabPanel("Birth Standards by Intergrowth (168 days to 300 days) and WHO standards",
                            pageWithSidebar(
                                                          
                              headerPanel(''),
                              sidebarPanel(    
                                h4(p(style = "color:dodgerblue","Step 1.")),
                                "Prepare a data file in the following format:",                            
                                tableOutput('table2'),"** means required",
                                #     img(src = 'capture.PNG', align = "center"),
                                   hr(),
                                h4(p(style = "color:dodgerblue","Step 2.")),
                                "Upload the data file (accepted format: .csv)",
                                fileInput('file1', 'Choose CSV File',
                                          accept=c('text/csv', 
                                                   'text/comma-separated-values,text/plain', 
                                                   '.csv')),
                                hr(),
#                                 h4(p(style = "color:dodgerblue","Step 3.")),"Choose one or more standards to create:",
#                                 checkboxInput('headcm', 'Head Circumference'),
#                                 checkboxInput('wt', 'Weight'),
#                                 checkboxInput('len', 'Length'),
                                actionButton("goButton", "Start Analysis!")
                                #,
                                # radioButtons('mm', 'Measurement:',
                                #              c("Centile" = 1, "Z-Score" = 2))
                                
                              ),
                              mainPanel(  
                                          h4(p(style = "color:dodgerblue","Download the data")),
                                          "Once the output table appears below, you can download the data.",br(),
                                          em("Tip: You may need to open the app in your local browser (see: 'Open In browser' (top-left)) to download successfully"),
                                          hr(),
                                          downloadButton('downloadData', 'Download'),
                                          h4(p(style = "color:dodgerblue","Output")),
                                          hr(),
                                          tableOutput('table')
                                          
                                         
                              )
                            )),
                   
                   ### SECOND TAB ###
                   tabPanel("Centile calculator (168 to 300 days)",
                            pageWithSidebar(
                              headerPanel('Centile calculator'),
                              
                              sidebarPanel(numericInput("percentile", label = h3("Pick a centile:"), 
                                                       min = 0.01, 
                                                       max = 99.99, value = 50),
                                           h5(p(style = "color:dodgerblue","You've selected this centile:")),
                                           verbatimTextOutput("value"),
                                           
                                           radioButtons("sexCentile", label = h3("Sex:"),
                                                        choices = list("Male" = "Male", "Female" = "Female"), 
                                                        selected = "Male"),
                                           
                                           
                                           numericInput("gagebrthCentile", label = h3("Gestational birth in days (168-300)"),
                                                        min=231, max=300, value=270)
#                                            ,
#                  
#                                            actionButton("goButton2", "Start Analysis!")
                                           
                                           
                              ),
                              mainPanel(                            
                                
                                radioButtons("choiceCentile", label = h3("Choose a measurement:"),
                                             choices = list("Head circ. (cm)" =  1, "Length (cm)" = 2, 
                                                            "Weight (kg)"= 3), selected = 1),
                                hr(),br(),br(),br(),
                                h4(p(style = "color:dodgerblue","The result:")),
                                          verbatimTextOutput("centileOutput"))
                            )
                   )
))
