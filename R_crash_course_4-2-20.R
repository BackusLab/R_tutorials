#R basics 4-2-2020

########Shortcuts##################
#cntrol enter/ cmd enter to run code
#up arrow to get prevously run lines
#tab-complete
#help(function name) or ?function name to read the help section
###################################

#Assigning variables
w<-c(2,3,4)
w
y<-w*2 #2 is technically a vector of length 1
y
z<-c(1,w,5,6)
z
w*z
c(1, 2, 3, 4) + c(0, 10, 100)

1:20 # make  vecotor 1-20
rep(5,10)
dim(z)<-c(2,3) #get dimensions

#matrix is a vector with more than 1 dimension
z
class(z) #class function to see data type


#COVID states data
#from covidtracking.com/api- states current values csv

getwd()    #get working directory, make sure file is in this directory. Alternatively, you can setwd() to where the file is

states<- read.csv("~/states.csv")

head(states) #gives you the first 6 lines

#states reads in as a data frame
class(states)
plot<-states[,c(1,11,12)]  #'coordinates' of dataframe you want

#lets plot hospitalized values against deaths values as scatterplot
help("ggplot")
hospitalized<-plot$hospitalized
deaths<-plot$death 

ggplot(plot, aes(hospitalized,deaths))+   #aes to specify which variables in each layer of you plot you want to change
  geom_point(color="red")+
  geom_text_repel(label= plot$state)+   ####install ggrepel library: instal.packagages(ggrepel)
  scale_x_continuous(trans='log10')+
  scale_y_continuous(trans='log10')+
  geom_smooth(method=lm)+
  theme_bw()
 

######There are several ways to calculate the ratio deaths/hospitalized for each state#######

#1 For Loop method:
ratio_2<-NULL
for (i in 1:length(plot$state)){
  print(i)
  temp=plot[i,3]/plot[i,2]
  print(temp)
  ratio_2<-c(ratio_2,temp)
}

#2 Apply method:
#built in apply family functions
matrix<- data.matrix(plot) #convert to matrix for apply
plot[,4]<-apply(matrix,1,function(x) x[3]/x[2])  #can call functions from elsewhere here

colnames(plot)<-c("state","H","D","D/H") #rename the columns
class(colnames(plot))
head(plot)

#3 Divide vectors
ratio<-states$death/states$hospitalized

identical(ratio,ratio_2)

#A barplot of total test results 
help(barplot)
high_positives<-states[which(states$positive > 1000),]   #subsetting data frames with which statement
totals<-states[order(states$totalTestResults, decreasing = T),]
barplot(totals$totalTestResults, names.arg = totals$state, col = "blue", main = "Total Test Results",ylim = c(0,220000) )


#another ggplot
positive<-states$positive
negative<-states$negative
total_tests<-states$totalTestResults 

ggplot(states, aes(total_tests,negative))+   #aes to specify which variables in each layer of you plot you want to change
  geom_point(color="green")+
  geom_text_repel(label= states$state)+   #install ggrepel library
  scale_x_continuous(trans='log10')+
  scale_y_continuous(trans='log10')+
  geom_smooth(method=lm)+
  theme_bw()



