install.packages("dplyr")
install.packages("Hmisc")
library(dplyr)
library(Hmisc)

#Heart Disease Dataset extracted from Kaggle

heart_data<-read.csv("heart.csv") 
View(heart_data)

##################### DESCRIPTIVE STATISTICS ##################################


describe(heart_data)
summary(heart_data)

#summary of the heart diseases by age
d_age<- heart_data %>% group_by(Age)
dsumm_age<- summarise(d_age,heartdiseaseCount_by_Age=sum(HeartDisease==0))
View(dsumm_age)

#Summary of the Heart Disease by gender
d_sex<- heart_data %>% group_by(Sex)
summ_sex<- summarise(d_sex,heartDiseaseCount_by_Gender=sum(HeartDisease==0))
View(summ_sex)

###################### DATA TRANSFORMATION ###################################

#Mutated a new column target with factors 1- No disease(N) and 0 - disease(Y)

heart_data<-mutate(heart_data,target=factor(heart_data$HeartDisease,levels=c(1,0),labels = c("N","Y")))


#Arrange the data by age 

f1<-arrange(heart_data,Age)
View(f1)

# List of patients with heart disease by high cholestrol
List_high_cholestrol<-filter(f1,f1$Cholesterol>200,f1$HeartDisease==0)
View(List_high_cholestrol)

####################### PLOTS ######################################################

#Heart Disease frequency as age increases

hist(heart_data$Age [heart_data$HeartDisease==0],
     xlim = c(20,100) ,#Limiting the scale on x
     ylim = c(0,120),
     breaks = 10,
     main="Heart Diseases Frequency by Age",
     xlab= "Age",
     ylab="Frequency of Heart Diseases",
     col="red")

#Plot for Maximum heartrate by age in case of heart patients

plot(heart_data$Age[heart_data$HeartDisease==0],heart_data$MaxHR[heart_data$HeartDisease==0],
     pch=19, #solid circle
     cex=1.5, #make 150% size
     col="blue",
     xlab="Age of the people with heart diseases",
     ylab=" Max HR of the people with Heart Diseases")


