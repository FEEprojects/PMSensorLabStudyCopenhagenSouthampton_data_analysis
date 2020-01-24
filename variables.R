
sensor_delay_corrected<-"dataset/sensor_delay_corrected.rds"
sensor_raw_file <- "dataset/sensors.rds"
dusttrak_file <- "dataset/dusttrak.rds"
ops_file <- "dataset/ops.rds"
nanotracer_file <- "dataset/nanotracer.rds"
dht22_file <- "dataset/dht22.rds"

# List of experimental conditions and of sensors
cdt <- readRDS("datasets/conditions_corrected.Rds")
sensor_list <- read.csv("datasets/List of sensors per box.csv")
