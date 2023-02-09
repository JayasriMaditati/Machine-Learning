install.packages("class")
install.packages("caret")
install.packages("ISLR")
require(e1071)
library(caret)
library(class)
Universal_data<- read.csv("UniversalBank.csv")
Universal_data$Personal.Loan<-factor(Universal_data$Personal.Loan)
Universal_data$Online <- as.factor(Universal_data$Online)
Universal_data$CreditCard <- factor(Universal_data$CreditCard)

str(Universal_data)

#1. Divide the data into 60% training and 40% validation

select_vars<- c(10,13,14)
#set.seed(123)

Personal_Loan.tr.in = createDataPartition(Universal_data$Personal.Loan,p=0.6, list=FALSE) # 60% reserved for Training
Personal_Loan.tr = Universal_data[Personal_Loan.tr.in,select_vars]
Personal_Loan.va <- Universal_data[-Personal_Loan.tr.in, select_vars] # Validation  data is rest
Personal_Loan.tr
summary(Personal_Loan.tr)
summary(Personal_Loan.va)
head(Personal_Loan.tr)
Personal_Loan.tr
#Create a pivot table for the training data with Online as a column variable, CC as a row variable, and Loan as a secondary row variable. 

ftable(Personal_Loan.tr,row.vars = c(3,1),col.vars = "Online")

#Looking at the pivot table, what is the probability that this customer will accept the loan offer? 
#[This is the probability of loan acceptance (Loan = 1) conditional on having a bank credit card (CC = 1) 
#and being an active user of online banking services (Online = 1)].

#Actual Probability p(Loan=1|CC=1,Online=1) = 51/(467+51) = 0.098456 

#p(CC=1,Online=1|Loan=1).p(loan=1)/(p(cc=1,online=1|loan=1).p(loan=1))+(p(cc=1,online=1|loan=0).p(loan=0))  
#=(51/288)*(288/3000)/((51/3000)+((467/2712)*(2712/3000))) = 0.098456

p<-((51/288)*(288/3000))/((51/3000)+((467/2712)*(2712/3000))) 
print(paste("The actual Probability of P(Loan=1| CC=1, Online=1) from pivot table: ", p))

# C.Create two separate pivot tables for the training data.
#Onewill have Loan (rows) as a function of Online (columns) and the other will have Loan (rows) as a function of CC.

ftable(Personal_Loan.tr,row.vars ="Personal.Loan",col.vars = "Online")
ftable(Personal_Loan.tr,row.vars ="Personal.Loan",col.vars = "CreditCard")

#D.Compute the following quantities [P(A | B) means “the probability ofA given B”]: 

Loan_Online_Table <- prop.table(ftable(Personal_Loan.tr,row.vars ="Personal.Loan",col.vars = "Online"),margin = 1)
Loan_CreditCard_Table <- prop.table(ftable(Personal_Loan.tr,row.vars ="Personal.Loan",col.vars = "CreditCard"),margin = 1)
Loan_Table <- prop.table(table(Personal_Loan.tr$Personal.Loan),margin = NULL)

#i.P(CC = 1 | Loan = 1) (the proportion of credit card holders among the loan acceptors)
a<-Loan_CreditCard_Table[2,2]
print(paste("The proportion of credit card holders among the loan acceptors P(CC = 1 | Loan = 1) is :",a))
#ii.P(Online = 1 | Loan = 1) 
b<-Loan_Online_Table[2,2]
print(paste("The proportion of active online users among the loan acceptors P(Online = 1 | Loan = 1) is :",b))
#iii.P(Loan = 1) (the proportion of loan acceptors) 
c<-Loan_Table[2]
print(paste("The proportion of loan acceptorsP(Loan = 1) is :",c))
#iv.P(CC = 1 | Loan = 0) 
d<-Loan_CreditCard_Table[1,2]
print(paste("(the proportion of credit card holders among the loan rejectors P(CC = 1 | Loan = 0) is :",d))
#v.P(Online = 1 | Loan = 0)
e<-Loan_Online_Table[1,2]
print(paste("The proportion of active online users among the loan rejectors (Online = 1 | Loan = 0) is :",e))
#vi.P(Loan = 0)
f<-Loan_Table[1]
print(paste("The proportion of loan rejectors P(Loan = 0) is :",f))

#E.Use the quantities computed above to compute the naive Bayes probability P(Loan = 1 | CC = 1, Online = 1).

#Naive_Bayes_Prob <-( p(cc=1|Loan=1).p(Online=1|Loan=1).p(Loan=1))/(p(cc=1|Loan=1).p(Online=1|Loan=1).p(Loan=1))+(p(cc=1|Loan=0).p(Online=1|Loan=0).p(Loan=0))

Naive_Bayes_Prob <- (Loan_CreditCard_Table[2,2]*Loan_Online_Table[2,2]*Loan_Table[2])/((Loan_CreditCard_Table[2,2]*Loan_Online_Table[2,2]*Loan_Table[2])+(Loan_CreditCard_Table[1,2]*Loan_Online_Table[1,2]*Loan_Table[1]))
Naive_Bayes_Prob

## F.Compare this value with the one obtained from the pivot table in (B). Which is a more accurate estimate?
#Looking at the pivot table, The probability of that the customer will accept the loan offer from (B)
#P(Loan=1|CC=1,Online=1) = 0.098455598
# The probability from naive bayes (E) :P(Loan=1|CC=1,Online=1) = 0.1000861 
# There is a minimal difference between (B) and (E) which is 0.001630502 
# When it comes to comparison, (0.098 is similar to 0.100) 
# Pivot table(Actual) probability(B) is more accurate than Naive Bayes probability(E).
#Since pivot table does not make the assumption of the probabilities (taking a loan if you are a cc holder and if you are an online customer) being independent.
#And also, there are few variables and categories to consider. So the Pivot table probability is feasible in this case.

print(paste("Looking at the pivot table, the Probability of P(Loan=1| CC=1, Online=1): ", p))
print(paste("The Naive Probability of P(Loan=1| CC=1, Online=1): ", Naive_Bayes_Prob))
print(paste("The Minimal Difference of the both probabilities from (B) and (E): ", Naive_Bayes_Prob-p))


# G.Which of the entries in this table are needed for computing P(Loan = 1 | CC = 1, Online = 1)? 
#Run naive Bayes on the data. Examine the model output on training data, and find the entry that corresponds to P(Loan = 1 | CC = 1, Online = 1). 
#Compare this to the number you obtained in (E).
set.seed(123)




loan.nb<-naiveBayes(Personal.Loan ~ CreditCard+Online, data = Personal_Loan.tr)

loan.nb

#Confusion Matrix

#Training set
set.seed(123)

pred.prob_train <- predict(loan.nb,newdata = Personal_Loan.tr,type="raw")
head(pred.prob_train)
pred.train <- predict(loan.nb,newdata = Personal_Loan.tr)
summary(pred.train)
confusionMatrix(pred.train,Personal_Loan.tr$Personal.Loan)
head(pred.train)

set.seed(123)

pred.prob <- predict(loan.nb,newdata = Personal_Loan.va,type="raw")
pred.valid <- predict(loan.nb,newdata = Personal_Loan.va)
summary(pred.valid)
confusionMatrix(pred.valid,Personal_Loan.va$Personal.Loan)

require(pROC)
# Note the delayed probabilities are in column 1
roc(Personal_Loan.va$Personal.Loan,pred.prob[,1])
plot.roc(Personal_Loan.va$Personal.Loan,pred.prob[,1])


plot.roc(Personal_Loan.va$Personal.Loan,pred.prob[,1],print.thres="best")
