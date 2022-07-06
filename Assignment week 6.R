#Activity 1
getwd()

library(tidyverse)
library(readr)
stormdata <- read.csv("/Users/saramonedero/Desktop/A6/StormEvents_details-ftp_v1.0_d1997_c20220425.csv")

#Activity 2 - Limit the dataframe to the following columns
head(stormdata, 2)

myvars<- c("BEGIN_TIME", "END_TIME", "EPISODE_ID", "EVENT_ID", "STATE", "STATE_FIPS", "CZ_NAME", "CZ_TYPE", "CZ_FIPS", "EVENT_TYPE", "SOURCE", "BEGIN_LAT", "BEGIN_LON", "END_LAT", "END_LON") 
newdata <- stormdata[myvars]

head(newdata)

#Activity 3 - Arrange the data by the state name 
arrange(newdata, STATE)

#Activity 4 - Change state and county names to title case head
str_to_title("CZ_NAME")
str_to_title("STATE")

head(newdata, 3)

#Activity 5 - Limit to the events listed by county FIPS (CZ_TYPE of “C”) and then remove the CZ_TYPE column
filter(newdata, CZ_TYPE == "C")
select(newdata, -CZ_TYPE)
       

#Activity 6 - Pad the state and county FIPS with a “0” at the beginning
str_pad(newdata$STATE_FIPS, width = 3, side = 'left', pad = "0")
unite(newdata, STATE_FIPS, CZ_FIPS, col = FIPS, sep = "_", remove = TRUE )


#Activity 7 - Change all the column names to lower case. I will use the rename_all function with (tolower) function
rename_all(newdata, tolower)

#Activity 8 - There is data that comes with Base R on U.S. states (data("state")). Use that to create a dataframe with the state name, area, and region.

data("state")
us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)
us_state_info
rename(us_state_info, c("state"="Var1"))

#Activity 9 - Create a dataframe with the number of events per state in the year of your birth. 
statefreq <- data.frame(table(newdata$STATE))
state_freq <- rename(statefreq, c("state"="Var1"))
newstate_freq<-(mutate_all(state_freq, tolower)) 
                 
usa_info <- mutate_all(us_state_info, tolower)

#9. (continued) Merge in the state information dataframe you just created. You don't need to remove any states that are not in the state information dataframe (the merge function will only merge common states).
merged <- merge(x=newstate_freq, y=usa_info, by.x="state", by.y="state")
head(merged)


#10 - Plot
library(ggplot2)
storm_plot <- ggplot(merged, aes(x = area, y = Freq)) + 
  geom_point(aes(color = region)) +
  labs(x = "Land area (square miles)",
       y = "# of storm events in 2017")

storm_plot


