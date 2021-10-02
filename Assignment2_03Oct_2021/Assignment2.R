#1.Age = 40, Experience = 10, Income = 84, Family = 2, CCAvg = 2, Education_1 = 0, Education_2 = 1, Education_3 = 0, Mortgage = 0, Securities Account = 0, 
#CD Account = 0, Online = 1, and Credit Card = 1. Perform a k-NN classification with all predictors except ID and ZIP code using k = 1. 
#Remember to transform categorical predictors with more than two categories into dummy variables first.
#Specify the success class as 1 (loan acceptance), and use the default cutoff value of 0.5. How would this customer be classified?

#2.What is a choice of k that balances between overfitting and ignoring the predictor information?

#3.Show the confusion matrix for the validation data that results from using the best k.

#4.Consider the following customer: Age = 40, Experience = 10, Income = 84,Family = 2, CCAvg = 2, Education_1 = 0, Education_2 =1, Education_3 = 0,Mortgage = 0, Securities Account = 0, CD Account = 0, Online = 1 and CreditCard = 1. 
#Classify the customer using the best k.

#5.Repartition the data, this time into training, validation, and test sets (50% : 30% : 20%). 
#Apply the k-NN method with the k chosen above. Compare the confusion matrix of the test set with that of the training and validation sets.
#Comment on the differences and their reason.


install.packages("caret")
install.packages("ISLR")
install.packages("class")
library(class)
library(caret)

Universal_data<- read.csv("UniversalBank.csv")
View(Universal_data)
str(Universal_data)
Universal_data$ID
#Dropping the ID and zipcode variables
subsetdata<- Universal_data[c(-1,-5)]
str(subsetdata)

# Dummy variables( education, family)

dummy_model_family<-dummyVars(~Family,data = subsetdata)
head(predict(dummy_model_family,subsetdata))
dummy_model_Edu<- dummyVars(~Education,data = subsetdata)
head(predict(dummy_model_Edu,subsetdata))

## Data Splitting
set.seed(123)
train_index <- createDataPartition(subsetdata$Personal.Loan,p=0.6,list = FALSE)
train_data <- subsetdata[train_index,]
validation_data <- subsetdata[-train_index,]

View(validation_data)

# Normalisation
set.seed(123)

model_range_normalized<-preProcess(train_data,method = c("range"))
head(model_range_normalized)
summary(model_range_normalized)
Universal_data_normalized<-predict(model_range_normalized,train_data)

## Prediction

train_predicters <-train_data[,c(1:7,9:12)] # predictors other than personal loan column from the training data
validation_predicters <- validation_data[,c(1:7,9:12)] ## predictors other than personal loan column from the validation data

train_labels <-as.factor(train_data[,8])
validation_labels <- validation_data[,8]

Predicted_test_labels <- knn(train_predicters,validation_predicters,cl=train_data[,8],k=1) #KNN Implementation for k=1
head(Predicted_test_labels)

full_data <- subsetdata # this is the whole data with traning and validation
test_data<-data.frame(Age = 40, Experience = 10, Income = 84, Family = 2, CCAvg = 2, Education = 2, Mortgage = 0, Securities.Account = 0, CD.Account = 0, Online = 1, CreditCard = 1) 
View(test_data)

Full_predicters <- full_data[,c(1:7,9:12)]
test_predicters <- test_data[,]

full_labels <- full_data[,8]

predict_loan <- knn(Full_predicters,test_predicters,cl=full_labels,k=1)
head(predict_loan)
?trainControl() 
search_grid<-expand.grid(k=1)
accuracy_check<-train(Personal.Loan~Age+Experience+Income+Family+CCAvg+Education+Mortgage+Securities.Account+CD.Account+Online+CreditCard, data=full_data, method="knn",tunegrid=search_grid )
accuracy_check
