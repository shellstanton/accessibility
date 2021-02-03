
### Need alternative way to generate polygon(s) to submit to WorldPop

##### Reclassify 'leastcost_motor' and extract from 'pop_data'

# Create rasterlayer from 'lcm_df' (remove 'layer' column prior)
View(lcm_df)
lcm_df$layer = NULL
View(lcm_df)

# Create reaster
lcm_raster <- rasterFromXYZ(lcm_df)
plot(lcm_raster)

# Create matrix
rcl_matrix <- c(0, 30, 1, # 30 minutes
                30, 60, 2, # 1 hour
                60, 180, 3, # 3 hours
                180, 360, 4, # 6 hours 
                360, 720, 5, # 12 hours
                720, 100000, 6 # 12+ hours
)

rcl_matrix <- matrix(rcl_matrix, ncol=3, byrow=TRUE)
View(rcl_matrix)

# Reclassify 'lcm_raster' with 'rcl_matrix' 
lcm_pop_data_rcl <- reclassify(lcm_raster, rcl_matrix, include.lowest=TRUE)
lcm_pop_data_rcl

### Attempted to convert lcm_pop_data_rcl to polygon(s) using 'rasterToPolygons' but took 3+ hours and so canceled

# Check as data.frame
lcm_rcl_pop_data_df <- as.data.frame(lcm_pop_data_rcl, xy = TRUE)
View(lcm_rcl_pop_data_df)


##### Try to generate polygon(s)

##### 1.
# install.packages("FRK")
library(FRK)

# Create spatialpolygon(s) from 'lcm_rcl_pop_data_df'
lcm_rcl_pop_data_polygons <- df_to_SpatialPolygons(lcm_rcl_pop_data_df, "mins", c("x","y"), CRS())

plot(lcm_rcl_pop_data_polygons)

lcm_rcl_pop_data_polygons
# spatialpolygons

## Can this be saved as polygon (.shp) and uploaded to WorldPop?

## Save as shapefile

library(rgdal)
writeOGR(lcm_rcl_pop_data_polygons, 
         dsn = './lcm_rcl_polygons/lcm_rcl_polygons', 
         layer = 'lcm_rcl_polygons', 
         driver = "ESRI Shapefile")
# Error in writeOGR(lcm_rcl_pop_data_polygons, dsn = "lcm_rcl_pop_data_polygons_shp",  : obj must be a SpatialPointsDataFrame, SpatialLinesDataFrame or SpatialPolygonsDataFrame



##### 2: stars package
lcm_pop_data_rcl

library(stars)

lcm_pop_data_rcl_sf =  st_contour(lcm_pop_data_rcl, contour_lines = TRUE, breaks = 1:6)






lcm_rcl_pop_data_polygons_converted <- st_cast(lcm_rcl_pop_data_polygons, "POLYGON")











# load package
library(wpCPR)

wpCPRPopulation (year=2020,
                 shapeFilePath = "lcm_rcl_pop_data_polygons",
                 outputFilePath = NULL,
                 apikey = NULL,
                 callbacktime = 5,
                 maxexectime = 3600,
                 apiurl = NULL,
                 verbose = TRUE)

