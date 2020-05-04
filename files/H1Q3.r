#HW1 - Question 3
options(warn=-1) #in order to hide warnings
library("data.table")
require(readxl) # to read excel input
require(data.table) # to use data.table functionalities

#reading titles of the movies
data_path='C:/Users/ceren.orhan/Desktop/ETM 58D/ETM58D_Spring20_HW1_q3_movie_titles.csv'
titles=read.csv(data_path, header = FALSE, sep = ",")
new_name=c("Year","Title")
setnames(titles,names(titles),new_name)
head(titles)

#reading rates of the movies
data_path='C:/Users/ceren.orhan/Desktop/ETM 58D/ETM58D_Spring20_HW1_q3_Netflix_data.txt'
rates_with_zero_rating=read.table(data_path, header = FALSE)
#setnames(rates,names(rates),titles[2])

head(rates_with_zero_rating)

#Replacing 0 rates with median of rating for that movie
m<-c(1:length(rates_with_zero_rating))
rates<-rates_with_zero_rating
for(i in 1:length(rates_with_zero_rating)){
    a=rates_with_zero_rating[,i]
    m[i]=median(a[a!=0])
}

for(i in 1:length(rates_with_zero_rating)){
    #print(i)
    for(ii in 1:length(rates_with_zero_rating[,i])){
        if(rates_with_zero_rating[ii,i]==0){
            rates[ii,i]=m[i]
        }else{rates[ii,i]=rates_with_zero_rating[ii,i]}
    }
}
head(rates)

dist_rates=dist(rates,method = "euclidean")
mat_rates=as.matrix(dist_rates)
mds_coord=cmdscale(mat_rates,2)

plot(mds_coord)

dist_rates=dist(t(rates),method = "euclidean")
mat_rates=as.matrix(dist_rates)
mds_coord=cmdscale(mat_rates,2)


plot(mds_coord)


