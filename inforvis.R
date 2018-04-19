device = read.csv("~/classProject/inforvis/SecurityData/device_info.csv",header=T)

newdevice = device[order(device$pc),]

levelh =0
pc = ""
col = "red";
plot(c(0,267400),c(0,212),type="n");
for(i in 1:nrow(newdevice)){
  if(newdevice$pc[i] != pc){
    levelh = levelh+1
    pc = newdevice$pc[i]
  }
  if(newdevice$activity[i] == "Connect"){
    col = "green"
  } else {
    col = "red"
  }
  if(newdevice$activity[i] == "Disconnect"){
    points(newdevice$relativeTime[i],levelh,pch=19,col=col,cex=.2)
  } else {
    points(newdevice$relativeTime[i],levelh+0.5,pch=19,col=col,cex=.2)
  }
}

unique(newdevice$pc)[order(t(table(newdevice$pc)))]
barplot(sort(table(newdevice[newdevice$activity=="Disconnect",]$pc),decreasing = T))


activity = cbind(table(newdevice[newdevice$activity=="Disconnect",]$pc),table(newdevice[newdevice$activity=="Connect",]$pc))
colnames(activity) = c("Disconnect","Connect")
newact = cbind(activity[,2],activity[,2]-activity[,1],activity[,1])
barplot(t(newact[unique(newdevice$pc)[order(t(table(newdevice$pc)))],]),horiz = T,col=c("gray10","red","gray90"))




linMap <- function(x, from, to){
  (x - min(x)) / max(x - min(x)) * (to - from) + from
}

user = read.table("~/classProject/inforvis/SecurityData/userInforAll_new.csv",sep=",")

a3 = linMap(user[,3],1,1000);
a4 = linMap(user[,4],1,1000);
a5 = linMap(user[,5],1,1000);
a6 = linMap(user[,6],1,1000);
a7 = linMap(user[,7],1,1000);
a8 = linMap(user[,8],1,1000);
a9 = linMap(user[,9],1,1000);
a10 = linMap(user[,10],1,1000);
a11 = linMap(user[,11],1,1000);
normUser = cbind(a3,a4,a5,a6,a7,a8,a9,a10,a11)

b1 = (a4+1)/(a5+1)
b2 = (a6+1)/(a7+1)
b3 = (a8+1)/(a9+1)

b = log2(b1) + log2(b2) + log2(b3)
rbPal <- colorRampPalette(c('blue','red'))
datcol <- rbPal(100)[as.numeric(cut(b,breaks = 100))]
plot(fit,type="n")
for(i in 1:nrow(fit)){
  points(fit[i,1],fit[i,2],col=datcol[i],pch=19)
}

pcact = read.table("~/classProject/inforvis/SecurityData/device_timeGap.txt",header=F)
prop.tab = t(prop.table(t(pcact[,2:3]),margin = 2))
barplot(t(prop.tab[order(prop.tab[,1]),]),col=c('gray','black'))




df <- data.frame(group=c("root", "root", "a","a","b","b","b"),    
                 subitem=c("a", "b", "x","y","z","u","v"), 
                 size=c(0, 0, 6,2,3,2,5))
vertices <- df %>%distinct(subitem, size) %>% add_row(subitem = "root", size = 0)

##################email dayli MDS plot & k-means cluster
library(RColorBrewer)
colss = brewer.pal(3,"Set1")
emaildayli = read.table("~/classProject/inforvis/SecurityData/email_daylisize.txt",sep=",")

# the choose of k was optimlized from 3 to 10, which gives best result
km = kmeans(mydata,3,nstart = 10,iter.max = 500)
dd = dist(emaildayli[,3:183])
fit <- cmdscale(dd,eig=TRUE, k=2)

#plot the MDS distribution
plot(fit$points[,1], fit$points[,2],type="n")
for(i in 1:nrow(emaildayli)){
    text(fit$points[i,1], fit$points[i,2],labels = "+",col=colss[km$cluster[i]])
}

#plot the mean distribution of all the data from K-cluster
plot(c(1,181),c(0,40000),pch=19,type="n")

cluster1 <- smooth.spline(1:181, apply(emaildayli[km$cluster==1,3:183],2,mean), df = 60)
lines(cluster1,col=colss[1],lwd=2)

cluster2 <- smooth.spline(1:181, apply(emaildayli[km$cluster==2,3:183],2,mean), df = 60)
lines(cluster2,col=colss[2],lwd=2)

cluster3 <- smooth.spline(1:181, apply(emaildayli[km$cluster==3,3:183],2,mean), df = 60)
lines(cluster3,col=colss[3],lwd=2)

points(1:181,apply(emaildayli[km$cluster==1,3:183],2,mean),col=colss[1],pch=19)
points(1:181,apply(emaildayli[km$cluster==2,3:183],2,mean),col=colss[2],pch=19)
points(1:181,apply(emaildayli[km$cluster==3,3:183],2,mean),col=colss[3],pch=19)


#PC-log activity
logon = read.table("~/classProject/inforvis/SecurityData/logon_info.csv",sep=",",header=T)
uniqPC_user = unique(logon[,3:4])
barplot(table(uniqPC_user$pc),col=colorRampPalette(brewer.pal(n = 7, name ="Blues"))(1000),
        border=colorRampPalette(brewer.pal(n = 7, name ="Blues"))(1000)
        ,las=1,ylim=c(0,250))

library(treemap)
role = user[user$V1 %in% abc[abc$pc=="PC-7165",]$user,]
role = as.data.frame(role)
freqrole = as.data.frame(table(role$V2))
treemap(freqrole,index="Var1",vSize="Freq")

role = user[user$V1 %in% abc[abc$pc=="PC-3348",]$user,]
role = as.data.frame(role)
freqrole = as.data.frame(table(role$V2))
treemap(freqrole,index="Var1",vSize="Freq")

##combine all the information by users
user = read.table("~/classProject/inforvis/SecurityData/userInforAll_new.csv",sep=",")
a3 = linMap(user[,3],0,1000);
a4 = linMap(user[,4],0,1000);
a5 = linMap(user[,5],0,1000);
a6 = linMap(user[,6],0,1000);
a7 = linMap(user[,7],0,1000);
a8 = linMap(user[,8],0,1000);
a9 = linMap(user[,9],0,1000);
a10 = linMap(user[,10],0,1000);
a11 = linMap(user[,11],0,1000);
normUser = cbind(a3,a4,a5,a6,a7,a8,a9,a10,a11)
dd = dist(normUser)
fit <- cmdscale(dd,eig=TRUE, k=2)
plot(fit$points[,1], fit$points[,2],type="n")
for(i in 1:nrow(user)){
  points(fit$points[i,1], fit$points[i,2],pch=19,cex=.6,col="gray")
}

for(i in 1:nrow(user)){
  if(user$V1[i] %in% role$V1 ){
      points(fit$points[i,1], fit$points[i,2],cex=.7,col="red")
  }
}

text(fit$points[970,1], fit$points[970,2],labels = user$V1[970],cex=.7,col=1)
text(fit$points[96,1], fit$points[96,2],labels = user$V1[96],cex=.7,col=1)
text(fit$points[532,1], fit$points[532,2],labels = user$V1[532],cex=.7,col=1)
text(fit$points[583,1], fit$points[583,2],labels = user$V1[583],cex=.7,col=1)




for(i in 1:nrow(emaildayli)){
  if(sum(employstatus[i,2:8])<7){
    text(fit$points[i,1], fit$points[i,2],labels=employstatus[i,1],col="blue",pch=.6)
  }
}

plot(c(1,181),c(0,50000),pch=19,type="n")
for(i in 1:length(check)){
  plot(1:181,emaildayli[164,3:183],pch=19,col="blue")
}

text(fit$points[627,1], fit$points[627,2],labels=627,col="blue")

#leave
employstatus = read.table("~/classProject/inforvis/SecurityData/employee_status_time.txt",sep=",")
leave = employstatus[apply(employstatus[,2:8],1,sum)<7,]

for(i in 1:nrow(leave)){
  points(1:181,emaildayli[leave$V1[i],3:183],pch=19,col=2)
}



plot(1:181,emaildayli[970,3:183],pch=19,col="blue")



logon = read.table("~/classProject/inforvis/SecurityData/logon_info.csv",sep=",",header=T)
abc = unique(logon[,3:4])
