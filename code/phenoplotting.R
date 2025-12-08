# read in libraries
library(dplyr)
library(lubridate)
library(tidyr)
library(ggplot2)

# read in testdata from 2025
data <- read.csv("data/testdata_2025.csv", header = TRUE)

# sample down to only the columns we need
data <- data %>%
  select(ec5_uuid,date,plot,species_common,observer,comments)

# convert date column form European to american
data <- data %>%
  mutate(
    date = dmy(date),              
    date = format(date, "%m/%d/%Y")  
  )

# create phenology plot (only includes sampled dates)
phenoplot <- ggplot(data, aes(x = date, y = species_common)) +
  geom_tile(fill = "#4C9A2A") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Garden Bloom Phenology",
    x = "Date",
    y = "Species"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )

# save the plot
ggsave(
  filename = "plots/garden_phenology_sampled_dates.png",
  plot = phenoplot,                                  
  width = 12,                                         
  height = 8,                                         
  dpi = 300                                           
)

# get all dates that were sampled
sampled_dates <- unique(data$date)

# create complete grid of species × full date range
complete_data <- expand.grid(
  species_common = unique(data$species_common),
  date = format(seq(as.Date("2025-11-01"), as.Date("2025-12-01"), by = "day"), "%m/%d/%Y")
) %>%
  # flag whether that date was sampled at all
  mutate(sampled = ifelse(date %in% sampled_dates, TRUE, FALSE)) %>%
  # join with original data
  left_join(data, by = c("species_common", "date")) %>%
  # create bloom status
  mutate(status = case_when(
    !sampled ~ "No Data",
    !is.na(ec5_uuid) ~ "In Bloom",
    TRUE ~ "Not in Bloom"
  ))

# create phenology plot including specified date range
phenoplot2 <- ggplot(complete_data, aes(x = date, y = species_common, fill = status)) +
  geom_tile(color = "white") +
  scale_fill_manual(values = c(
    "In Bloom" = "#4C9A2A",       
    "Not in Bloom" = "#FFFFFF",   
    "No Data" = "#D3D3D3"         
  )) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Garden Bloom Phenology (Full Date Range)",
    x = "Date",
    y = "Species",
    fill = "Status"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )

# save the plot
ggsave(
  filename = "plots/garden_phenology_full_range.png",
  plot = phenoplot2,                                  
  width = 12,                                         
  height = 8,                                         
  dpi = 300                                           
)