library(hbgd)

shinyUI(navbarPage("Intergrowth CDC", 
                   ### FIRST TAB ###
                   tabPanel("Intergrowth Birth Standards (232 to 300 days)",
                            pageWithSidebar(
                              
                              
                              headerPanel(''),
                              sidebarPanel(    
                                h4(p(style = "color:dodgerblue","Step 1.")),
                                "Prepare the data file like so:",hr(),
                                
                                tableOutput('table2'),
                                #     img(src = 'capture.PNG', align = "center"),
                                #     hr(),
                                h4(p(style = "color:dodgerblue","Step 2.")),
                                "Upload the data file (only .csv accepted)",
                                hr(),
                                fileInput('file1', 'Choose CSV File',
                                          accept=c('text/csv', 
                                                   'text/comma-separated-values,text/plain', 
                                                   '.csv')),
                                hr(),
                                checkboxInput('headcm', 'Head Circumference'),
                                checkboxInput('wt', 'Weight'),
                                checkboxInput('len', 'Length'),
                                actionButton("goButton", "Start Analysis!")
                                #,
                                # radioButtons('mm', 'Measurement:',
                                #              c("Centile" = 1, "Z-Score" = 2))
                                
                              ),
                              mainPanel(  h4(p(style = "color:dodgerblue","Output")),
                                          hr(),
                                          
                                          
                                          tableOutput('table'),
                                          
                                          h4(p(style = "color:dodgerblue","Download the data")),
                                          downloadButton('downloadData', 'Download')
                              )
                            )),
                   
                   ### SECOND TAB ###
                   tabPanel("Centile calculator (232 to 300 days)",
                            pageWithSidebar(
                              headerPanel('Centile calculator'),
                              
                              sidebarPanel(sliderInput("percentile", label = h3("Pick a centile:"), 
                                                       min = 0.01, 
                                                       max = 99.99, value = 50),
                                           h5(p(style = "color:dodgerblue","You've selected this centile:")),
                                           verbatimTextOutput("value"),
                                           
                                           radioButtons("sexCentile", label = h3("Sex:"),
                                                        choices = list("Male" = "Male", "Female" = "Female"), 
                                                        selected = "Male"),
                                           
                                           
                                           numericInput("gagebrthCentile", label = h3("Gestational birth in days (232-300)"),
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
