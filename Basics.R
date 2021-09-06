#sample test for git hub repository - test
#<- assignment operator

# this is the new changes

library(datasets)
view(mtcars)
x <-1
print(x)
msg<-'Hello'
print(msg)

y<-5 #nothing printed

y<-10
y

y #auto printing occurs
print(y) # explicit printing
#[1] : means y is a vector and 5 is the first elemnet

#using operator to create integer sequence
# integer sequence of length 20
x<- 10:30
x
num<-3.7
typeof(num)
class(num)

j<-10L
typeof(j)
class(j)

t<- TRUE
typeof(t)
class(t)

ch<-"hello"
typeof(ch)
class(ch)
length(ch)

#mtcars is an inbuilt dataset
x<-mtcars
print(x)

print(paste('hello','world')) # paste fucntion
print(paste('hello','world',sep='-')) #Sep is for chosen sepeartor between the pasted items
paste0('hello','students') #displays without space
paste('hello','hai')

sprintf("%s is %f feet tall","Ashley",6) #prints formatted combination

