library(shinyjs)
library(shinyBS)
library(DT)
library(plotly)
require(visNetwork, quietly = TRUE)


css <- ".mandatory_star { color: red; }
        .shiny-output-error { visibility: hidden; }
        .shiny-output-error::before {
          visibility: visible;
          content: 'An error occurred. Please contact one of the admins (see \"About\" section for emails).'; }
        .navbar-header .navbar-brand {padding:0;margin:-20px 0;padding:1px}
        .modal {overflow-y: scroll;}
        .loadmessage {
               position: fixed;
               top: 0px;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 100%;
               color: #000000;
               background-color: '#CCFF66';
               z-index: 105;
        }
        .select2-container {
            width: 53% !important;
            margin-bottom: 20px !important;
        }
        .btn {
            color: #333;
            background-color: #fff;
            border-color: #ccc;
        }
       "

shinyUI(fluidPage(
    useShinyjs(),
    shinyjs::inlineCSS(css),
    titlePanel(title=div(img(src="images/combined_logos.png", height=55))),
    tagList(
      tags$link(rel="stylesheet",type="text/css"),
      tags$script("Shiny.addCustomMessageHandler('resetValue', function(variableName) {
                                        Shiny.onInputChange(variableName, null);});
                         Shiny.addCustomMessageHandler('resetEmpty', function(variableName) {
                                        Shiny.onInputChange(variableName, '');});"),
      tags$style("#network{height:100vh !important;}")
    ),
    fluidRow(
      column(6,
             fluidRow(
             column(6,bsCollapse(id = "collapsehowto", open = "NULL",
                        bsCollapsePanel("How to",
                                        tags$div(
                                            tags$p('You can explore this database by interacting with both the network graph below or the table to the right.'),
                                            tags$ul(
                                              tags$li('Click on a Node in the network to learn more about a person or use the details button in the table.'),
                                              tags$li('Hover over the arrows to explore how people help each other.'),
                                              tags$li('To add your data click on "Join us!".'),
                                              tags$li('To edit your data, go to the detailed view and click on "Edit".'))
                        )))),
             column(6,bsCollapse(id = "collapsejoin", open = "NULL",
                                 bsCollapsePanel("Join us!",
                                                 tags$div(
                                                 tags$h4('Thank you for joining the network!'),
                                                 tags$p("By filling in your skills you can give back to our PhD community and open possibilities for more interaction across institutes and disciplines."),
                                                 tags$p("Please also make sure to fill in some of your own needs. It may be that people do not even know they posses a skill that could be helpful to others.")
                                                ),
                                                actionButton("buttonAdd", "Add your Data")
                                                )))),
             visNetworkOutput("network")),
      column(6,
             fluidRow(
               column(12,bsCollapse(id = "collapseabout", open = "NULL",
                                   bsCollapsePanel("About",
                                                   tags$div(
                                                       tags$h4("Hi, welcome to our little database of skills!"),
                                                       tags$p("Have you ever needed help during your PhD but were not sure who to ask? Do you miss teamwork as a lone science warrior? Do you want to connect with your peers outside work? With 25 doctoral students in the Language in Interaction (LiI) consortium and 76 in the International Max Planck Research School (IMPRS, cohorts 2014-2017) there is an immense amount of talent & interests surrounding us! This database is meant to efficiently connect doctoral students by linking the ones who need help to the ones who can offer help - both in work as well as leisure."),
                                                       tags$p("You can explore our database by interacting with both the network graph or the table. Just click on a circle to learn more about that person's skills & needs! Or explore who is is helping out by hovering over the arrows!"),
                                                       tags$p("Would you like to join? Simply add your data and be part of our network!"),
                                                       tags$p("For questions concerning the database please contact one of the admins:"),
                                                       tags$ul(
                                                         tags$li('Sophie Arana: s.arana@donders.ru.nl'),
                                                         tags$li('Chara Tsoukala: c.tsoukala@let.ru.nl'),
                                                         tags$li('Anne Mickan: a.mickan@donders.ru.nl'))
                                                     ),
                                                  actionButton("buttonStats", "See statistics"),
                                                  bsModal("modalstats", "Statistics", "buttonStats",
                                                          splitLayout(plotlyOutput("piePlotSkills"), plotlyOutput("piePlotNeeds")))
                                                        )
                                                  ))),
             tags$head(tags$style(
               HTML("input[type='search']:disabled {visibility:hidden}")
             )),
             DT::dataTableOutput("database"), tags$hr()),
              conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                       tags$div("Loading...",id="loadmessage")
      )
    )
 ) # fluidPage
) # shinyUI
