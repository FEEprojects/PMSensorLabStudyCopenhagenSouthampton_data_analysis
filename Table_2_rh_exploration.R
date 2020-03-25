# This script takes output the summary 
# of the temperature and humidity readings from
# the Sensirion SHT35 sensor in the four Air quality monitors
# The results of summary_rh_temp are used for "Table 2. Median Humidity and Temperature readings averaged from the four Sensirion SHT35, for
# each of the five experiments performed."


source("utilities.R")
source("variables.R")


df <- readRDS(file = sensor_raw_file) 
df %>%
  filter(sensor == "SHT35") %>%
  group_by(exp) %>%
  summarise(temp = mean(temperature, na.rm = TRUE), 
            temp_median = median(temperature, n.rm = TRUE),
            temp_min = min(temperature, na.rm = TRUE), 
            temp_max = max(temperature, na.rm = TRUE),
            temp_sd = sd(temperature, na.rm = TRUE),
            rh = mean(humidity, na.rm = TRUE), 
            rh_median = median(humidity, na.rm = TRUE),
            rh_min = min(humidity, na.rm = TRUE),
            rh_max = max(humidity, na.rm = TRUE),
            rh_sd = sd(humidity, na.rm= TRUE)) ->summary_rh_temp

summary_rh_temp


df %>%
  filter(sensor == "SHT35") %>%
  group_by(exp,site) %>%
  summarise(temp = mean(temperature, na.rm = TRUE), 
            temp_median = median(temperature, n.rm = TRUE),
            temp_min = min(temperature, na.rm = TRUE), 
            temp_max = max(temperature, na.rm = TRUE),
            temp_sd = sd(temperature, na.rm = TRUE),
            rh = mean(humidity, na.rm = TRUE), 
            rh_median = median(humidity, na.rm = TRUE),
            rh_min = min(humidity, na.rm = TRUE),
            rh_max = max(humidity, na.rm = TRUE),
            rh_sd = sd(humidity, na.rm= TRUE)) ->summary_rh_temp_site

summary_rh_temp_site