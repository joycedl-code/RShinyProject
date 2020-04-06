##setwd(choose.dir())

list.files(pattern = ".csv")


##dat <- read.csv("contries+visited.csv", sep=",")
dat <- contries.visited
View(dat)
dim(dat)
library(stringr)

country <- sapply(dat$Location, function(x) str_split(x, pattern=","))
country <- sapply(country, function(x) x[length(x)])
country <- sapply(country, function(x) substr(x, start = 2, stop=str_length(x)))

country[country=='adagascar'] <- 'Madagascar'
country[country=='Italy\n'] <- 'Italy'
country[country=='ustrian Alps'] <- 'Austria'

country_freq <- as.data.frame(table(country))

library(ggplot2)

country_data <- map_data("world")

country_map <- merge(country_data, country_freq, 
                     by.x = "region", by.y="country", all.x = TRUE, all.y=TRUE)
country_map$Freq[is.na(country_map$Freq)] <- 0

View(country_map)

# ggplot(country_map) +
#   aes(long, lat, group=group)+
#   geom_polygon(aes(fill=1))


ggplot()+
  geom_map(data=country_data,  map= country_data, 
           aes(x=long, y=lat, group=group, map_id=region), 
           fill="white", colour="#7f7f7f")+
  geom_map(data=country_map, map=country_data, 
           aes(fill=Freq, map_id=region), colour="#7f7f7f")+
  scale_fill_continuous(low="thistle2", high="darkred", guide="colorbar")+
  theme_bw()
