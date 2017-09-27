#Author:Gaobin Wang
#Email:gaobin513@qq.com
#Update time:2017-09-27
#Description:实现AdaBoost算法

###清除环境变量
rm(list = ls())

###加载必要的R包
library(rpart)
library(rpart.plot) #rpart.plot
library(rattle) #fancyRpartPlot

###读入数据，并将数据分为测试集和训练集
data("kyphosis")
# str(kyphosis)
# summary(kyphosis)
set.seed(100)
n = nrow(kyphosis)
train_index = sample(1:n,floor(0.6 * n))
train_data = kyphosis[train_index,]
test_data = kyphosis[-train_index,]

###训练模型
ky_rpart = rpart(Kyphosis ~ .,data = train_data)
print(ky_rpart)
summary(ky_rpart)

###测试数据集上进行预测
pred = predict(object = ky_rpart,newdata = test_data,
               type = "class")
predict(ky_rpart, type = "prob")   # class probabilities (default)

###模型评价
real = test_data[,1]
table(pred,real) #混淆矩阵

###决策树的可视化
fancyRpartPlot(ky_rpart) #画出决策树的结构图
plot(ky_rpart)
text(ky_rpart,use.n=T,all=T,cex=1)

###决策树的进一步学习
#对决策树进行设置
ct = rpart.control(xval=10, minsplit=20, cp=0.1) 
#训练决策树
fit = rpart(Kyphosis ~ Age + Number + Start, 
             data=kyphosis,method="class",control=ct,
             parms = list(prior = c(0.65,0.35), split = "information"))
#画图1
plot(fit)
text(fit,use.n=T,all=T,cex=1)
#画图2
rpart.plot(fit, branch=1, branch.type=2, type=1, extra=102,
           shadow.col="gray", box.col="green",
           border.col="blue", split.col="red",
           split.cex=1.2, main="Kyphosis决策树")
#显示模型复杂度的表格(用于确定如何对树进行剪枝)
printcp(fit)
#对决策树进行剪枝
fit2 = prune(fit, cp=0.01)

## rpart.control的参数设置:
## xval是10折交叉验证
## minsplit是最小分支节点数，这里指大于等于20，那么该节点会继续分划下去，否则停止
## minbucket：叶子节点最小样本数
## maxdepth：树的深度
## cp全称为complexity parameter，指某个点的复杂度，对每一步拆分,模型的拟合优度必须提高的程度，用来节省剪枝浪费的不必要的时间

## rpart的参数设置:
## na.action：缺失数据的处理办法，默认为删除因变量缺失的观测而保留自变量缺失的观测。         
## method：树的末端数据类型选择相应的变量分割方法:连续性method=“anova”,离散型method=“class”,计数型method=“poisson”,生存分析型method=“exp”
## parms用来设置三个参数:先验概率、损失矩阵、分类纯度的度量方法（gini和information）

## printcp会告诉分裂到每一层，cp是多少，平均相对误差是多少
## 交叉验证的估计误差（“xerror”列），以及标准误差(“xstd”列)，平均相对误差=xerror±xstd
## 通过上面的分析来确定cp的值
## 我们可以用下面的办法选择具有最小xerror的cp的办法：
## prune(fit, cp= fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])