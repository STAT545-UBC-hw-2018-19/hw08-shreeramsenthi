# Stat547 Assignment 3: Shiny

This is my submission for assignment 3 of the 2018 iteration of the Stat547 course at UBC.

In the last assignment in Stat545 we make use of the `devtools` and `testthat` packages to build publish our own packages. This week, we are exploring the use of `shiny` to build interactive websites in R.

Specifically, we began with a data set and simple website courtesy of [Dean Attali](https://deanattali.com/blog/building-shiny-apps-tutorial) that outputs a table and histogram of some alcoholic drinks available at the BCL. See [here](https://deanattali.com/blog/building-shiny-apps-tutorial/#12-final-shiny-app-code) for the original code and data set.

From here, we were tasked with adding functionality or UI changes to improve the utility and accessibility of the data. I chose to focus on making the following changes:

1) Filter results by name

2) Add option to filter by type and subtype

3) Change the x-axis of the plot

Check out the code [here](https://github.com/STAT545-UBC-students/hw08-shreeramsenthi/blob/master/bcl/app.R) and a live version of the final product hosted on shinyapps.io [here](https://shreeramsenthi.shinyapps.io/BCL-App/)!
