# This script apply Dynamic Time Warping to the HPMA115S0 and SDS018 models to 
# correct the time delay observed for these sensors.

source("utilities.R")
source("variables.R")
require(dplyr)
require(lubridate)
require(dtw)
require(splitstackshape)


df <-prepare_sensor_data(sensor_raw_file, cdt) %>%
  select(date, sensor, site, PM25, exp, source, variation)

df2<-cSplit(indt=df,splitCols = c("sensor"),sep="-",direction="wide",drop=FALSE)
df2 %>%
  select(-sensor_2,-sensor_3)->df

dt <- prepare_dusttrak_data(dusttrak_file, cdt)




df_sensor <- df %>%
  filter(exp != "") %>%
  filter(sensor_1 == "HPMA115S0")


# Initialise the result data frame
res <- df_sensor %>%
  filter(exp == "empty")



for(expe in unique(df_sensor$exp)){
  
  df_sensor_exp <- df_sensor %>%
    filter(exp == expe)
  
  dt_exp <- dt %>%
    filter(exp == expe)
  
  for(sens in unique(df_sensor$sensor)){
    
    
    
    query<- df_sensor_exp %>%
      filter(sensor == sens) %>%
      arrange(date)
    if(nrow(query)==0){next}
    query_diff<-finite.differences(as.numeric(query$date),query$PM25 )
    
    template<- dt_exp %>%
      arrange(date) 
    template_diff<-finite.differences(as.numeric(template$date), template$pm2.5)
    
    alignment<-dtw(query_diff,template_diff, keep=TRUE, step.pattern = mori2006)
    wq<-warp(alignment,index.reference=FALSE);
    
    #     p<-ggplot(data=template, aes(x=template$date, y = template$pm2.5)) +geom_line() + 
    #     geom_line(aes(x = template$date, y = query$PM25[wq],color="Corrected data"))+ 
    #     geom_line(data=query, aes(x = date, y=PM25, color = "Original data"))+ 
    #     ggtitle(paste0("mori2006", " - ", expe))
    # print(p)
    query_1 <-query[wq,]
    query_1$date <- template$date
    
    res <- rbind(res, query_1)
    # ggplot(data=template, aes(x=template$date, y = template$pm2.5)) +geom_line() + geom_line(aes(x = query_1$date, y = query_1$PM25,color="Corrected data"))
  }
  
}


df_sensor <- df %>%
  filter(exp != "") %>%
  filter(sensor_1 == "SDS018")

for(expe in unique(df_sensor$exp)){
  
  df_sensor_exp <- df_sensor %>%
    filter(exp == expe)
  
  dt_exp <- dt %>%
    filter(exp == expe)
  
  for(sens in unique(df_sensor$sensor)){
    
    
    
    query<- df_sensor_exp %>%
      filter(sensor == sens) %>%
      arrange(date)
    if(nrow(query)==0){next}
    query_diff<-finite.differences(as.numeric(query$date),query$PM25 )
    
    template<- dt_exp %>%
      arrange(date) 
    template_diff<-finite.differences(as.numeric(template$date), template$pm2.5)
    
    alignment<-dtw(query_diff,template_diff, keep=TRUE, step.pattern = mori2006)
    wq<-warp(alignment,index.reference=FALSE);
    
    p<-ggplot(data=template, aes(x=template$date, y = template$pm2.5)) +geom_line() + geom_line(aes(x = template$date, y = query$PM25[wq],color="Corrected data"))+ geom_line(data=query, aes(x = date, y=PM25, color = "Original data"))+ ggtitle("mori2006")
    p
    query_1 <-query[wq,]
    query_1$date <- template$date
    
    res <- rbind(res, query_1)
    # ggplot(data=template, aes(x=template$date, y = template$pm2.5)) +geom_line() + geom_line(aes(x = query_1$date, y = query_1$PM25,color="Corrected data"))
  }
  
}


df_sensor <- df %>%
  filter(exp != "") %>%
  filter(sensor_1 == "OPCR1")

res <- rbind(res, df_sensor)

df_sensor <- df %>%
  filter(exp != "") %>%
  filter(sensor_1 == "PMS5003")

res <- rbind(res, df_sensor)

df_sensor <- df %>%
  filter(exp != "") %>%
  filter(sensor_1 == "SPS030")

res <- rbind(res, df_sensor)

res %>%
  saveRDS(file = "datasets/sensor_delay_corrected.rds")
