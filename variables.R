
sensor_delay_corrected<-"datasets/sensor_delay_corrected.rds"
sensor_raw_file <- "datasets/sensors.rds"
sensor_blank <- "datasets/sensors_blank.rds"
dusttrak_file <- "datasets/dusttrak.rds"
ops_file <- "datasets/ops.rds"
nanotracer_file <- "datasets/nanotracer.rds"
dht22_file <- "datasets/dht22.rds"

# List of experimental conditions and of sensors
cdt <- readRDS("datasets/conditions_corrected.Rds")
sensor_list <- read.csv("datasets/List of sensors per box.csv")
