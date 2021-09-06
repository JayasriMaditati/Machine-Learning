
# This is the sample test

################  DATA TYPES ##################################

#NUMERIC

n1<-15  #double precison by default
n1
typeof(n1)


n2<-1.5
n2
typeof(n2)

c1<-"c"
c1
typeof(c1)

c2<-"string of character"
c2
typeof(c2)

l1<-TRUE
l1
typeof(l1)

################## DATA STRUCTURES ################################

# VECTOR ################################
V1<- c(1,2,3,4)
V1
is.vector(V1)


# MATRIX #################################

m1<- matrix( c(T,T,F,F,T,F),nrow = 2)
m1

m2<-matrix(c("a","b",
             "c","d"),
           nrow=2,
           byrow=T)
m2
mat  <- matrix(c(1:24),nrow=3,byrow=T)
mat

# ARRAY ####################################

#Give data, then dimensions(rows,cols,tables)

a1<- array(c(1:24),c(4,3,2))
a1

# DATAFRAMES ################################

# can combine vectors of same length
vNumeric <- c(1,2,3)
vCharacter <- c("a","b","c")
vLogical <- c(T,F,T)

dfa<- cbind(vNumeric,vCharacter,vLogical)
dfa # matrix of one data type

df<- as.data.frame(dfa)
df  # makes a dataframe with three different data types

# LIST ######################################

vNumeric <- c(1,2,3)
vCharacter <- c("a","b","c","d")
vLogical <- c(T,F,T,T,F) 

list1<- list(vNumeric,vCharacter,vLogical)
list1

list2<- list(vNumeric,vCharacter,vLogical,list1)#Lists with in lists
list2

############################### COERCING TYPES ######################################

#coercion of datatypes  - Refer vectors file

# COERCE MATRIX TO DATAFRAME

coerce1<- matrix(1:9,nrow=3)
coerce1
is.matrix(coerce1)

coerce2<- as.data.frame(coerce1)
is.data.frame(coerce2)
coerce2


## CLEAN THE ENVIRONMENT #################################
rm(list=ls())
