# Homework 1 - Question 1 - part a
options(warn=-1) #in order to hide warnings
library(data.table)

# number of samples and dimension(s)
nof_samples=1000
set.seed(1)

#creating required variables
estimated_pi<-c(1:10) # for 2-d assumption
estimated_pi_2d<-c(1:10) # for 2-d approximation

#calculatin for each dimensions
for (D in 1:10){
    # data matrix creation
    data_points=runif(nof_samples*2,-1,1)
    data_points=matrix(data_points,ncol=D)

    #calculating euclidean distance
    sum<-0
    for (i in 1:D){
        sum=(data_points[,i])^2
    }
    euclidean_distance=sqrt(sum)

    # number of points in the sphere
    is_in_sphere=euclidean_distance<=1
    nof_sphere=sum(is_in_sphere)

    #proportion esstimations
    estimated_pi[i]=6*nof_sphere/nof_samples #with volume approximation
    estimated_pi_2d[i]=4*nof_sphere/nof_samples #with area approximation (for part c)
}

#plotting dimension vs proportions
plot(estimated_pi,main="Proportion vs Dimension",ylab="Proportion",xlab="Dimension")
grid()

# Homework 1 - Question 1 - part b

print(paste("Esitmation for 2D is",estimated_pi_2d[2])) # second index used to get values for 2-D
print(paste("Esitmation for 3D is",estimated_pi[3]))    # third index used to get values for 3-D
print(paste("Actual Pi is",pi))

# Homework 1 - Question 1 - part c

# number of samples and dimension(s)
nof_samples=1000
nof_new_samples=100
set.seed(1)
min_distance<-c(1:10)

for (D in 1:10){
    data_points=runif(nof_samples*2,-1,1)
    data_points=matrix(data_points,ncol=D)

    #calculating euclidean distance
    sum<-0
    for (i in 1:D){
        sum=(data_points[,i])^2
    }
    euclidean_distance_1000=sqrt(sum)
    for(j in 1:length(nof_new_samples)){
        new_data_points=runif(nof_new_samples*2,-1,1)
        new_data_points=matrix(new_data_points,ncol=D)
    }   
    
    min_distance[D]=min(dist_mat=proxy::dist(data_points,new_data_points))
}

plot(min_distance,main="Minimum Distance vs Dimension",ylab="Proportion",xlab="Dimension")
grid()
