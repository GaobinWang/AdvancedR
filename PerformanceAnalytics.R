library(PerformanceAnalytics)
managers
attach(managers)
data(managers)

##问题一：学习xts格式的数据类型
#可参考这篇文档：http://blog.fens.me/r-xts/

data(prices)


##计算每日的收益率
XXX = CalculateReturns(prices, method = "discrete")
plot(XXX)


R.IBM = Return.calculate(xts(prices), method="discrete")
colnames(R.IBM)="IBM"
chart.CumReturns(R.IBM,legend.loc="topleft", main="Cumulative Daily Returns for IBM")
round(R.IBM,2)

###计算各项指标
ActivePremium(managers[, "HAM1", drop=FALSE], managers[, "SP500 TR", drop=FALSE])
apply.rolling( managers[,1,drop=FALSE], FUN="mean", width=3)

AverageDrawdown(managers[,1,drop=FALSE]) 
#算深度

CAPM.alpha(managers[,1,drop=FALSE], managers[,8,drop=FALSE], Rf=.035/12)
BernardoLedoitRatio(a)

a=managers[,1,drop=FALSE]


CAPM.beta(managers[, "HAM2", drop=FALSE],managers[, "SP500 TR", drop=FALSE],
          Rf = managers[, "US 3m TR", drop=FALSE])

CAPM.beta.bull(managers[, "HAM2", drop=FALSE],managers[, "SP500 TR", drop=FALSE],
               Rf = managers[, "US 3m TR", drop=FALSE])

#CAPM.beta.bull只算正的return，知道CAPM.beta是 0.3383；CAPM.beta.bull是 0.5226.
CAPM.beta.bear(managers[, "HAM2", drop=FALSE],managers[, "SP500 TR", drop=FALSE],
               Rf = managers[, "US 3m TR", drop=FALSE])

TimingRatio(managers[, "HAM2", drop=FALSE],managers[, "SP500 TR", drop=FALSE],
            Rf = managers[, "US 3m TR", drop=FALSE])
#TimingRation 是bull/bear #7.5; 所以这个值在牛市越大越好，熊市越小越好。

KellyRatio(managers[,1:6], Rf=managers[,10,drop=FALSE])


##计算标准差
sd.multiperiod(managers[,1],scale=4)
# (daily scale = 252, monthly scale = 12, quarterly scale = 4)


#算系统风险；
SystematicRisk(Ra, Rb, Rf = 0, scale = NA, ...)
#系统风险= regression beta * Rb； 参考的市场风险


#画图
chart.Bar (managers[, "HAM2", drop=FALSE])
chart.CaptureRatios(managers[,1:6], managers[,7,drop=FALSE]) # 多策略时有用
chart.RelativePerformance(managers[, 1:6, drop=FALSE],
                          managers[, 8, drop=FALSE],
                          colorset=rich8equal, legend.loc="topleft",
                          main="Relative Performance to S&P")

###
#数据查询
data = managers
data['1999']
data['2005-05/','HAM1']
data['2006-05-01/2006-07-31','HAM1']
data['2006-07-31','HAM1']

#操作作图
plot(tempdata, type='candles')


#按时间分割数据
xts.ts <- xts(rnorm(231),as.Date(13514:13744,origin="1970-01-01"))
apply.monthly(xts.ts,mean)
apply.monthly(xts.ts,function(x) var(x))
apply.quarterly(xts.ts,mean)

data(sample_matrix)
> to.period(sample_matrix)
sample_matrix.Open sample_matrix.High sample_matrix.Low sample_matrix.Close
2007-01-31           50.03978           50.77336          49.76308            50.22578
2007-02-28           50.22448           51.32342          50.19101            50.77091
2007-03-31           50.81620           50.81620          48.23648            48.97490
2007-04-30           48.94407           50.33781          48.80962            49.33974
2007-05-31           49.34572           49.69097          47.51796            47.73780
2007-06-30           47.74432           47.94127          47.09144            47.76719
> class(to.period(sample_matrix))
[1] "matrix"

> samplexts <- as.xts(sample_matrix)
> to.period(samplexts)
samplexts.Open samplexts.High samplexts.Low samplexts.Close
2007-01-31       50.03978       50.77336      49.76308        50.22578
2007-02-28       50.22448       51.32342      50.19101        50.77091
2007-03-31       50.81620       50.81620      48.23648        48.97490
2007-04-30       48.94407       50.33781      48.80962        49.33974
2007-05-31       49.34572       49.69097      47.51796        47.73780
2007-06-30       47.74432       47.94127      47.09144        47.76719
> class(to.period(samplexts))
[1] "xts" "zoo"
apply.yearly(xts.ts,mean)


#数据合并

(x <- xts(4:10, Sys.Date()+4:10))
(y <- xts(1:6, Sys.Date()+1:6))
merge(x,y)

#取索引将领合并
merge(x,y, join='inner')

#以左侧为基础合并
merge(x,y, join='left')


#按行切片
tempdata = tempdata[,"Nav"]
split(tempdata)
split(tempdata)[2]

split(tempdata)[3]

split(tempdata, f = "weeks")[[1]]


#NA值得处理
x <- xts(1:10, Sys.Date()+1:10)
x[c(1,2,5,9,10)] <- NA

#取前一个
na.locf(x)

#取后一个
na.locf(x, fromLast=TRUE)


#xts数据统计计算
xts.ts <- xts(rnorm(231),as.Date(13514:13744,origin="1970-01-01"))
start(xts.ts)
end(xts.ts)
periodicity(xts.ts)


###
library(RODBC)
options(scipen = 200)
ch = odbcConnect("华夏基金AMC-客户聚类", "root", "user" )
data = sqlQuery(ch, "select * from 回访客户样本5000",  as.is = 1)
data = sqlQuery(ch, "select * from 回访客户样本5000",  as.is = "CUSTID1")
###

#计算时间段
data(sample_matrix)
ndays(sample_matrix)
nweeks(sample_matrix)
nmonths(sample_matrix)
nquarters(sample_matrix)
nyears(sample_matrix)

class(sample_matrix)

sample_matrix = as.xts(sample_matrix)

##计算