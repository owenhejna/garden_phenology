# Monitor flowering plant phenology in your own garden

## Table of contents

1. [Goals of repository](#goals-of-repository)
2. [Workflow](#workflow)
3. [File descriptions](#file-descriptions)

## Goals of repository
The goals of this repository are to create...
- A data collection workflow for anyone with access to a phone to collect flowering plant phenology data
- A simple and reproducible way for folks to visualize the data for their own garden once collected
- A fun way to record the blooming times of the plants in your own garden!

## Workflow

1. Create data collection project on EpiCollect
The easiest way to collect data for this workflow is to setup an EpiCollect(https://five.epicollect.net/) project.
Create the following survey questions to work in correspondence with code: "What is the date?","Which plot are you surveying","What species is/are blooming in that plot?","Observer","Comments"
Tip: It is easiest to use the checkbox selection type for the species observations. This makes it so you can submit one observation per plot per day instead of one observation per species in every plot. The code will automatically break up the list of observed species in the plot into individual rows.
2. Setup google sheet to read in Epi data
The easiest way to read you Epicollect data into a csv is to setup a google sheet that runs the "" script. This script will read in the epicollect project data, create individual species observation rows from lists, and even changes column names.
Create a new google sheet and select Extensions in the toolbar, then Apps Script. Now you can paste in the given "" script (MAKE SURE TO CHANGE API LINK AND SHEET NAME, lines 3 and 6 respectively) and click run. This will read your epicollect project data into whatever sheet you specify in your open google sheet.

A CHUNK OF DATA HERE

3. Create plots using R script
Delete the first row from your google sheet data (the row that denotes when you read in from epi) and then save it as a .csv file.
Run "" code, change file paths if need be (filepaths in R code are relatively pathed by default, downloading the whole repo is probably easiest option).

A PLOT HERE

## File descriptions

### code

#### phenoplotting.R
This R code is used at the end of the workflow in order to visualize the flower phenology data. This code requires a .csv input and creates two plots based on the provided data. First (garden_phenology_sampled_dates.png) is a phenology plot of only dates where flowering plants were monitored. Second (output=garden_phenology_full_range.png) is a phenology plot for a given range of dates (see line 50). The plot organizes cells into the following categories: In Bloom, Not In Bloom, and No Data

#### epitogoogle.js
This code is required to read in Epicollect data to a google sheet. This google sheet can then be saved as a csv (REMINDER! Delete the first row of sheet before saving as .csv). Lines 3 and 6 need to be changed for respective Epicollect link and sheet name.

### data

#### testdata_2025.csv
This is data collected from Owen's gardens at the end of 2025 as a pilot for this project. Now that things are set up we are ready for a full 2026 sampling season!

### plots

#### garden_phenology_sampled_dates.png
This plot represents flowering plant phenology data for all sampled dates in the 2025 pilot season.

#### garden_phenology_full_range.png
This plot represents flowering plant phenology data for all dates between 12/1-11/1/2025. This plot is more likely what finalized outputs will look like.


[Back to top ⤒](#monitor-flowering-plant-phenology-in-your-own-garden)
