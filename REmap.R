#安装REmap
library(devtools)
install_github('lchiffon/REmap')

#加载REmap
library(REmap)


# ###获取城市经纬度
# get_city_coord 获取一个城市的经纬度
# get_geo_position 获取一个城市向量的经纬度
city_vec = c("北京","Shanghai","广州")
get_city_coord("Shanghai")
get_geo_position (city_vec)

# ###绘制百度迁徙地图
# remap(mapdata, title = "", subtitle = "", 
#       theme =get_theme("Dark"))
# mapdata 一个数据框对象，第一列为出发地点，第二列为到达地点
# title 标题
# subtitle 副标题
# theme 控制生成地图的颜色，具体将会在get_theme部分说明
setwd("E:\\Github\\AdvancedR")
set.seed(125)
origin = rep("北京",10)
destination = c('上海','广州','大连','南宁','南昌',
                '拉萨','长春','包头','重庆','常州')
dat = data.frame(origin,destination)
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Dark")
plot(out)

#看到地图的几种方式
## Method 1
remap(dat,title = "REmap实例数据",subtitle = "theme:Dark")
## Method 2 
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Dark")
out
## Method 3
plot(out)


