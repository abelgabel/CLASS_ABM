# #####################################################
#
#
#
# #####################################################





# Call packages
library(igraph)
# Call functions


folder_dir<-getwd()

source(paste0(folder_dir,"/Actors/actor_function.R"))
source(paste0(folder_dir,"/Updating_process/alliance_f.R"))
source(paste0(folder_dir,"/Updating_process/target_actor.R"))
source(paste0(folder_dir,"/Updating_process/updating_f.R"))
source(paste0(folder_dir,"/plot_trends.R"))
source(paste0(folder_dir,"/plot_alliance_net.R"))


setting_simulate<-function(N, T_periods, cost){
#####################################
# Create Actors
#####################################
Wealth<-runif(N,min=300, max=500)

actors<-list()
for(i in 1:N){
	actors[[i]]<-actor(position=i,Wealth[i],rep(0,N))
}


growth<-runif(N,min=200,max=600)

# #####################################################	 
#
# #####################################################	 

history_track<-list()
history_track$wealth<-matrix(0,nrow=T_periods,ncol=N)
history_track$active<-list()
history_track$active$active<-matrix(0,nrow=T_periods, ncol=6)
history_track$actors<-list()

# #####################################################	 
# Start Simulations
# #####################################################	 
withProgress(message = 'Simulation running', value = 0, min=0, 
max=1, {
for(time_s in 1:T_periods){

if(time_s!=1){
# Star of new Year
for(i in 1:N){
	actors[[i]]$wealth<-actors[[i]]$wealth+ growth[i] 
#Track Wealth
history_track$wealth[time_s,i]<-actors[[i]]$wealth
}
}


history_track$actors[[time_s]]<-actors


# #####################################################	 
# Choose active actors
# #####################################################	 
active<-sample(1:N,3, replace=F)

# #####################################################	 
# Choose target actors 
# #####################################################	 
target<-rep(0,3)
for(i in 1:3){
	target[i]<-target_actor(active[i],actors) 
}
 	history_track$active$active[time_s,1:3]<-active 
	history_track$active$active[time_s,4:6]<-target 
 

for(k in 1:3){
# Update actors
if(!is.na(target[k])){
 	actors<-update_process(active[k], target[k],actors, cost)
}
}

percentage<-round(time_s/T_periods,1)
incProgress(amount=percentage, detail = paste("Progress", percentage))
 

}


})
# Output
return(history_track)
}








