#Solar school Data
solar_school_public_unique_all <- read.csv("/Users/xuegao/Library/CloudStorage/Box-Box/Xue Box/SolarSchool/Data/Final/solar_school_public_unique_all.csv")
solar_school_public_unique_all$solar <- 1

#NCES data (all US K-12 schools)
school_all <- read.csv("/Users/xuegao/Library/CloudStorage/Box-Box/Xue Box/SolarSchool/Data/Final/school_all.csv")

#Merge Solar school and NCES data
data_merged_all <- merge(school_all, solar_school_public_unique_all, by=c("School.ID.NCES"), all=T)

data_merged_all$solar[is.na(data_merged_all$solar)==T] <- 0
data_merged_all$solar <- as.factor(data_merged_all$solar)
data_merged_all$NCES.district.ID <- str_sub(data_merged_all$School.ID.NCES, end = -6)

data_merged_all$Year1 <- str_sub(data_merged_all$Year, end = 4)
data_merged_all$Year1 <- as.numeric(data_merged_all$Year1)

data_merged_all$Pupil.Teacher.Ratio<- as.numeric(data_merged_all$Pupil.Teacher.Ratio..Public.School)
data_merged_all$FTE.Teachers<- as.numeric(data_merged_all$Full.Time.Equivalent..FTE..Teachers..Public.School)
data_merged_all$male<- as.numeric(data_merged_all$Male)
data_merged_all$female<- as.numeric(data_merged_all$Female)
data_merged_all$total.students<- as.numeric(data_merged_all$Total.Students.x)
data_merged_all$Free.Lunch<- as.numeric(data_merged_all$Free.Lunch.Eligible)
data_merged_all$American.Native<- as.numeric(data_merged_all$American.Indian.Alaska.Native)
data_merged_all$Asian.students<- as.numeric(data_merged_all$Asian)
data_merged_all$Hispanic.students<- as.numeric(data_merged_all$Hispanic)
data_merged_all$Black.students<- as.numeric(data_merged_all$Black)
data_merged_all$White.students <- as.numeric(data_merged_all$White)

data_merged_all$male_percent <- data_merged_all$male/data_merged_all$total.students
data_merged_all$Free.Lunch_percent<- data_merged_all$Free.Lunch/data_merged_all$total.students
data_merged_all$Asian.percent<- data_merged_all$Asian.students/data_merged_all$total.students
data_merged_all$Hispanic.percent<- data_merged_all$Hispanic.students/data_merged_all$total.students
data_merged_all$Black.percent <- data_merged_all$Black.students/data_merged_all$total.students
data_merged_all$White.percent <- data_merged_all$White.students/data_merged_all$total.students
data_merged_all$American.Native.percent <- data_merged_all$American.Native/data_merged_all$total.students

data_merged_all$location<-NA
data_merged_all$location[data_merged_all$Locale == "11-City: Large"] <- "City"
data_merged_all$location[data_merged_all$Locale == "12-City: Mid-size"] <- "City"
data_merged_all$location[data_merged_all$Locale == "13-City: Small"]<- "City"
data_merged_all$location[data_merged_all$Locale == "21-Suburb: Large"]<- "Suburb"
data_merged_all$location[data_merged_all$Locale == "22-Suburb: Mid-size"]<- "Suburb"
data_merged_all$location[data_merged_all$Locale == "23-Suburb: Small"]<- "Suburb"
data_merged_all$location[data_merged_all$Locale == "31-Town: Fringe"]<- "Town"
data_merged_all$location[data_merged_all$Locale == "32-Town: Distant"]<- "Town"
data_merged_all$location[data_merged_all$Locale == "33-Town: Remote"]<- "Town"
data_merged_all$location[data_merged_all$Locale == "41-Rural: Fringe"]<- "Rural"
data_merged_all$location[data_merged_all$Locale == "42-Rural: Distant"]<- "Rural"
data_merged_all$location[data_merged_all$Locale == "43-Rural: Remote"]<- "Rural"

data_merged_all$poor_school <- 0
data_merged_all$poor_school[data_merged_all$Free.Lunch_percent >0.5] <- 1
data_merged_all$white_school <- 0
data_merged_all$white_school[data_merged_all$White.percent>0.5] <- 1
data_merged_all$white_school <- as.factor(data_merged_all$white)
data_merged_all$black_school <- 0
data_merged_all$black_school[data_merged_all$Black.percent>0.5] <- 1
data_merged_all$black_school <- as.factor(data_merged_all$black)
data_merged_all$hispanic_school <- 0
data_merged_all$hispanic_school[data_merged_all$Hispanic.percent>0.5] <- 1
data_merged_all$hispanic_school <- as.factor(data_merged_all$hispanic)
data_merged_all$asian_school <- 0
data_merged_all$asian_school[data_merged_all$Asian.percent>0.5] <- 1
data_merged_all$asian_school <- as.factor(data_merged_all$asian)

data_merged_all$race_school <- "Non"
data_merged_all$race_school[data_merged_all$white_school==1] <- "white"
data_merged_all$race_school[data_merged_all$black_school==1] <- "black"
data_merged_all$race_school[data_merged_all$hispanic_school==1] <- "Hispanic"
data_merged_all$race_school[data_merged_all$asian_school==1] <- "Asian"
data_merged_all$race_school <- as.factor(data_merged_all$race_school)

#write.csv(data_merged_all, '/Users/xuegao/Library/CloudStorage/Box-Box/Xue Box/SolarSchool/Data/Final/data_merged.csv')

#Merge Merge PPA, ARRA, and NEM Policies
PPA.Policy <- read.csv('/Users/xuegao/Library/CloudStorage/Box-Box/Xue Box/SolarSchool/Data/Final/PPA.Policy.csv')

data_merged_all_policy <- merge(data_merged_all, PPA.Policy, by="State.Name", all=T)
data_merged_all_policy <- subset(data_merged_all_policy, data_merged_all_policy$Year!="NA")
data_merged_all_policy$PPA1[data_merged_all_policy$PPA =="Yes"] <- 1
data_merged_all_policy$PPA1[data_merged_all_policy$PPA!="Yes"] <- 0

data_merged_all_policy$PPA_adoption <- 0
data_merged_all_policy$PPA_adoption[data_merged_all_policy$PPA1 == 1 & data_merged_all_policy$Year1 >= data_merged_all_policy$PPA.adoption.year] <- 1

NEM <- read.csv(file="/Users/xuegao/Library/CloudStorage/Box-Box/Xue Box/SolarSchool/Data/Final/NEM_state_year.csv")
NEM$net_meter <- as.factor(NEM$net_meter)

data_merged_all_policy <- merge(data_merged_all_policy, NEM, by= c("State.Name","Year1"), all = T)

ARRA <- read.csv("/Users/xuegao/Library/CloudStorage/Box-Box/Xue Box/SolarSchool/Data/Final/ARRA_data.csv")
ARRA[ARRA=="yes"] <- 1
ARRA[ARRA=="no"] <- 0

data_merged_all_policy_arra <- merge(data_merged_all_policy, ARRA, by=c("State.y"), all.x = T)

data_merged_all_policy_arra$DID <- as.numeric(as.character(data_merged_all_policy_arra$PPA1)) * as.numeric(as.character(data_merged_all_policy_arra$PPA_adoption))
data_merged_all_policy_arra$DID <- as.factor(data_merged_all_policy_arra$DID)

# from 2010 to 2013 is the ARRA policy period#
data_merged_all_policy_arra$period <- 0
data_merged_all_policy_arra$period[as.numeric(as.character(data_merged_all_policy_arra$Year1)) < 2014] <- 1
data_merged_all_policy_arra$arra_DID <- as.numeric(as.character(data_merged_all_policy_arra$ARRA)) * as.numeric(as.character(data_merged_all_policy_arra$period))
#data_merged_all_policy_arra[data_merged_all_policy_arra== "†"] <- NA

#Calculate Peer Effect variables####
#solar school data with merged school-level NCES data
solar3 <- read.csv('/Users/xuegao/Library/CloudStorage/Box-Box/Xue Box/SolarSchool/Data/Final/2308_school.with.solar.new.csv')

solar3$race_school <- "Non"
solar3$race_school[solar3$white_school==1] <- "white"
solar3$race_school[solar3$black_school==1] <- "black"
solar3$race_school[solar3$hispanic_school==1] <- "Hispanic"
solar3$race_school[solar3$asian_school==1] <- "Asian"
solar3$race_school <- as.factor(solar3$race_school)

solar3[solar3== "†"] <- NA

school_state <- data_merged_all_policy %>%
  group_by(State.Name, County.Name, NCES.district.ID, Year1) %>%
  summarize(school_Num = n())

solar_new_state <- solar3 %>%
  group_by(State.Name, County.Name, NCES.district.ID, Year1) %>%
  summarize(solar_new = n())

solar_new_poor <- solar3 %>%
  group_by(State.Name, County.Name, NCES.district.ID, poor_school, Year1) %>%
  summarize(solar_poor_new = n())%>% 
  filter(poor_school==1)

solar_new_white <- solar3 %>%
  group_by(State.Name, County.Name, NCES.district.ID, white_school, Year1) %>%
  summarize(solar_white_new = n())%>% 
  filter(white_school==1)

solar_new_black <- solar3 %>%
  group_by(State.Name, County.Name, NCES.district.ID, black_school, Year1) %>%
  summarize(solar_black_new = n())%>% 
  filter(black_school==1)

solar_new_Hispanic <- solar3 %>%
  group_by(State.Name, County.Name, NCES.district.ID, hispanic_school, Year1) %>%
  summarize(solar_hispanic_new = n())%>% 
  filter(hispanic_school==1)

solar_new_Asian <- solar3 %>%
  group_by(State.Name, County.Name, NCES.district.ID, asian_school, Year1) %>%
  summarize(solar_Asian_new = n())%>% 
  filter(asian_school==1)

summary <- merge(school_state, solar_new_state, by=c("State.Name","County.Name","NCES.district.ID","Year1"), all=T)
summary1 <- merge(summary, solar_new_poor, by=c("State.Name","County.Name","NCES.district.ID","Year1"), all=T)
summary2 <- merge(summary1, solar_new_white, by=c("State.Name","County.Name","NCES.district.ID","Year1"), all=T)
summary3 <- merge(summary2, solar_new_black, by=c("State.Name","County.Name","NCES.district.ID","Year1"), all=T)
summary4 <- merge(summary3, solar_new_Hispanic, by=c("State.Name","County.Name","NCES.district.ID","Year1"), all=T)
summary5 <- merge(summary4, solar_new_Asian, by=c("State.Name","County.Name","NCES.district.ID","Year1"), all=T)
summary5 <- summary5[,c(-7,-9,-11,-13,-15)]
summary5[is.na(summary5)==T] <- 0
summary_by_race_eco <- summary5

library(dplyr) 
summary <- summary_by_race_eco %>%
  group_by(State.Name, County.Name, Year1) %>%
  summarize(school_Num = sum(school_Num),
            solar_new = sum(solar_new),
            solar_poor_new = sum(solar_poor_new),
            solar_white_new = sum(solar_white_new),
            solar_black_new = sum(solar_black_new),
            solar_Hispanic_new = sum(solar_hispanic_new),
            solar_Asian_new = sum(solar_Asian_new))
summary$County.Name[summary$County.Name==0] <-NA

summary <- summary %>% 
  group_by(State.Name, County.Name) %>% 
  mutate(solar_new_cumsum = cumsum(solar_new),
         solar_poor_cumsum = cumsum(solar_poor_new),
         solar_white_cumsum = cumsum(solar_white_new),
         solar_black_cumsum = cumsum(solar_black_new),
         solar_Hispanic_cumsum = cumsum(solar_Hispanic_new),
         solar_Asian_cumsum = cumsum(solar_Asian_new))

data_merged_all_policy_peer_arra <- merge(data_merged_all_policy_arra, summary, by=c("State.Name", "County.Name", "Year1"), all.x=T)

#Models#
library(clubSandwich)
library(sandwich)
library(lmtest)
library(fixest)

# Model 1 Solar Adoption Disparity
data_merged_all_policy_peer_arra$solar <- as.numeric(as.character(data_merged_all_policy_peer_arra$solar))
model_both <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent + Free.Lunch_percent + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent  + total.students  + as.factor(location) |as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_both)

# Model 2 Solar Adoption Disparity, PPA, and ARRA
model_policy_DID <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  Free.Lunch_percent + Asian.percent + Hispanic.percent + Black.percent 
                          + American.Native.percent + total.students+ as.factor(location)+DID + net_meter+ arra_DID |as.factor(County.Name)^as.factor(Year1),
                          family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_policy_DID)

#Model 3. PPA Policy Impact Heterogeneity
model_ppa_heter <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  Free.Lunch_percent*DID + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + total.students+ as.factor(location)+net_meter +arra_DID |as.factor(County.Name)^as.factor(Year1),
                         family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_ppa_heter)

#Model 4. ARRA Policy Impact Heterogeneity
model_arra_heter <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  Free.Lunch_percent*arra_DID + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + total.students+ as.factor(location) +net_meter+ DID |as.factor(County.Name)^as.factor(Year1),
                          family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_arra_heter)

#Model 5. Poor vs. Non-poor Peer effects
data_merged_all_policy_peer_arra$solar_nonpoor_cumsum <- data_merged_all_policy_peer_arra$solar_new_cumsum - data_merged_all_policy_peer_arra$solar_poor_cumsum
data_merged_all_policy_peer_arra$solar_nonwhite_cumsum <- data_merged_all_policy_peer_arra$solar_new_cumsum - data_merged_all_policy_peer_arra$solar_white_cumsum

model1_peer_comp <- feglm(solar ~  lag(solar_nonpoor_cumsum, 1) + lag(solar_poor_cumsum, 1) + male_percent + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + Free.Lunch_percent  + total.students  + as.factor(location)+net_meter+DID+arra_DID |as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=subset(data_merged_all_policy_peer_arra, data_merged_all_policy_peer_arra$poor_school==1))
summary(model1_peer_comp)

#Model 6. White vs. Non-white Peer effects
model1_peer_comp_race <- feglm(solar ~  lag(solar_nonwhite_cumsum, 1) + lag(solar_white_cumsum, 1) + male_percent + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + Free.Lunch_percent  + total.students  + as.factor(location)+net_meter+DID+arra_DID |as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=subset(data_merged_all_policy_peer_arra, data_merged_all_policy_peer_arra$race_school!="white"))
summary(model1_peer_comp_race)

#Model 7. funding type models for PPA (can only include schools with solar installation)
model_funding_PPA <-  feglm(finding_ppa ~ lag(solar_new_cumsum,1) +  male_percent +  Free.Lunch_percent  + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + total.students+ as.factor(location)+net_meter
                                   |as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data= subset(solar_school_merge, solar_school_merge$DID==1))
summary(model_funding_PPA)

#Model 8. funding type models for grant (can only include schools with solar installation)
model_funding_grant <-  feglm(finding_grant ~ lag(solar_new_cumsum,1) +  male_percent +  Free.Lunch_percent + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + total.students+ as.factor(location)+net_meter
                              |as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=subset(solar_school_merge,solar_school_merge$arra_DID==1))
summary(model_funding_grant)

#Robustness: Models using poor school####
data_merged_all_policy_peer_arra$poor_school[data_merged_all_policy_peer_arra$Free.Lunch_percent >0.5] <- 1

#Model 8. Test the installation disparity
data_merged_all_policy_peer_arra <- within(data_merged_all_policy_peer_arra, race_school <- relevel(factor(race_school), ref = "white"))
model_both_1 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent + as.factor(poor_school) + as.factor(race_school) + total.students + as.factor(location)|as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_both_1)

#Model 9. Test the impact of PPA and ARRA (two policies) on solar adoptions using DID models
model_policy_DID_1 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent + as.factor(poor_school) + as.factor(race_school) + total.students + as.factor(location)+DID + net_meter+ arra_DID|as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_policy_DID_1)

#Model 10. The heterogeneity of policy impacts
model_ppa_heter_1 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  as.factor(poor_school)*DID + as.factor(race_school) + total.students+ as.factor(location)+net_meter+ arra_DID |as.factor(County.Name)^as.factor(Year1),
                           family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_ppa_heter_1)

#Model 11. The heterogeneity of policy impacts
model_arra_heter_1 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  as.factor(poor_school)*arra_DID + as.factor(race_school)  + total.students+ as.factor(location) +net_meter + DID |as.factor(County.Name)^as.factor(Year1),
                            family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_arra_heter_1)

#Event study figure
model_ppa_event <- feglm(solar ~ i(event_ppa, PPA1) | as.factor(County.Name) ^ as.factor(Year1),
                                   family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)

summary(model_ppa_event)

iplot(model_ppa_event, main = "Impact of PPA on Solar Adoption in K-12 Schools"
      ,xlab = "Years Relative to PPA Adoption", ylab = "Log(odds) of Solar Adoption")
abline(v=0, col="blue")

#Robustness: Models using Title-I####

#Model 12. Test the installation disparity
model_both_2 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent + as.factor(Title.I) + as.factor(race_school) + total.students + as.factor(location)|as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_both_2)

#Model 13. Test the impact of PPA and ARRA (two policies) on solar adoptions using DID models
model_policy_DID_2 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent + as.factor(Title.I) + as.factor(race_school) + total.students + as.factor(location)+DID + net_meter+ arra_DID|as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_policy_DID_2)

#Model 14. The heterogeneity of PPA policy impacts
model_ppa_heter_2 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  as.factor(Title.I) *DID + as.factor(race_school) + total.students+ as.factor(location)+net_meter+arra_DID  |as.factor(County.Name)^as.factor(Year1),
                           family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_ppa_heter_2)

#Model 15. The heterogeneity of ARRA policy impacts
model_arra_heter_2 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  as.factor(Title.I)*arra_DID + as.factor(race_school)  + total.students+ as.factor(location) +net_meter + DID|as.factor(County.Name)^as.factor(Year1),
                            family=binomial(link='logit'),data=data_merged_all_policy_peer_arra)
summary(model_arra_heter_2)

#Robustness: excluding small systems####
data_merged_all_policy_peer_arra_sub <- subset(data_merged_all_policy_peer_arra, data_merged_all_policy_peer_arra$Solar.Capacity..kW.>9.99 | is.na(data_merged_all_policy_peer_arra$Solar.Capacity..kW.)==T)

#Model 16. Test the installation disparity
model_both_9.99 <- feglm(solar ~ lag(solar_new_cumsum,1) +male_percent + Free.Lunch_percent + Asian.percent + Hispanic.percent 
                         + Black.percent + American.Native.percent  + total.students  + as.factor(location) + net_meter 
                         |as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=data_merged_all_policy_peer_arra_sub)
summary(model_both_9.99)

#Model 17. Test the installation disparity
model_econ_9.99 <- feglm(solar ~ lag(solar_new_cumsum,1) +male_percent + Free.Lunch_percent  + total.students  + as.factor(location) + net_meter 
                         |as.factor(County.Name)^as.factor(Year1),family=binomial(link='logit'),data=data_merged_all_policy_peer_arra_sub)
summary(model_econ_9.99)

#Model 18. PPA and ARRA policy impacts
model_policy_DID_9.99 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  Free.Lunch_percent + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + total.students+ as.factor(location)+DID + net_meter+ arra_DID |as.factor(County.Name)^as.factor(Year1),
                               family=binomial(link='logit'),data=data_merged_all_policy_peer_arra_sub)
summary(model_policy_DID_9.99)

#Model 19. PPA and ARRA policy impacts
model_policy_DID_econ_9.99 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  Free.Lunch_percent  + total.students+ as.factor(location)+DID + net_meter+ arra_DID |as.factor(County.Name)^as.factor(Year1),
                                    family=binomial(link='logit'),data=data_merged_all_policy_peer_arra_sub)
summary(model_policy_DID_econ_9.99)

#Model 20. The heterogeneity of PPA policy impacts
model_ppa_heter_9.99  <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  Free.Lunch_percent*DID + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + total.students+ as.factor(location)+net_meter +arra_DID|as.factor(County.Name)^as.factor(Year1),
                               family=binomial(link='logit'),data=data_merged_all_policy_peer_arra_sub)
summary(model_ppa_heter_9.99)

#Model 21. The heterogeneity of ARRA policy impacts
model_arra_heter_9.99 <- feglm(solar ~ lag(solar_new_cumsum,1) + male_percent +  Free.Lunch_percent*arra_DID + Asian.percent + Hispanic.percent + Black.percent + American.Native.percent + total.students+ as.factor(location) +net_meter +DID |as.factor(County.Name)^as.factor(Year1),
                               family=binomial(link='logit'),data=data_merged_all_policy_peer_arra_sub)
summary(model_arra_heter_9.99)
