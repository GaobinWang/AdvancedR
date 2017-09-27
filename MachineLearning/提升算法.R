#Author:Gaobin Wang
#Email:gaobin513@qq.com
#Update time:2017-09-27
#Description:实现AdaBoost算法

###清除环境变量
rm(list = ls())

###加载必要的R包
# install.packages("ada")
library(ada)

###读入数据，并将数据分为测试集和训练集
data("kyphosis")
# str(kyphosis)
# summary(kyphosis)
n = nrow(kyphosis)
train_index = sample(1:n,floor(0.6*n))
train_data = kyphosis[train_index,]
test_data = kyphosis[-train_index,]

###训练模型
ada_train = ada(Kyphosis ~ .,train_data)

###测试数据集上进行预测
ada_test = addtest(ada_train,test_data[,-1],test_data[,1])

###其他
print(ada_test) #Model Information for Ada
summary(ada_test) #Summary of model fit for arbitrary data (test, validation, or training)
predict(ada_train, test_data) #Predict a data set using Ada
plot(ada_test,TRUE,TRUE) #错误率Plots for Ada
varplot(ada_test) #变量的重要性
