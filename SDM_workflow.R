################################################################################
##### Species Distribution Modelling Workflow
################################################################################
# This code reads in GBIF txt files on species occurrence, and WorldClim environmental data and 
#conducts species distribution modelling using... 

# Nichar Gregory - Logan Bioinformatics
# 15/03/25

# Convert to functions. 

setwd("/Users/nichargregory/Documents/Projects/Consultancies/Logan Bioinformatics/SDM")

# Download libraries
install.packages("terra")
install.packages("geodata")
install.packages("predicts")


# Download 19 bioclimatic variables from Worldclim using the geodata package, 
# at a resolution of 2.5 minutes of a degree. 

bioclim_data <- worldclim_global(var = "bio",
                                 res = 2.5,
                                 path = "data/")

# Read in occurrence data
obs_data <- read.csv(file = "data/Carnegiea-gigantea-GBIF.csv")

#Check data looks okay, paying particular attention to NAs, as we have to remove these. 
summary(obs_data)

# Remove NAs
obs_data <- obs_data[!is.na(obs_data$latitude), ]

# Check that no NA's remaining
summary(obs_data)

# Exploratory analysis: assess geographic distribution of the species of interest

# Determine geographic extent of our data
max_lat <- ceiling(max(obs_data$latitude))
min_lat <- floor(min(obs_data$latitude))
max_lon <- ceiling(max(obs_data$longitude))
min_lon <- floor(min(obs_data$longitude))

# Store boundaries in a single extent object
geographic_extent <- ext(x = c(min_lon, max_lon, min_lat, max_lat))


# Download data with geodata's world function to use for our base map
world_map <- world(resolution = 3,
                   path = "data/")

# Crop the map to our area of interest
my_map <- crop(x = world_map, y = geographic_extent)

# Plot the base map
plot(my_map,
     axes = TRUE, 
     col = "grey95")

# Add the points for individual observations
points(x = obs_data$longitude, 
       y = obs_data$latitude, 
       col = "olivedrab", 
       pch = 20, 
       cex = 0.75)


