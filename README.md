# GARNO
GNSS-A Ranging Network Optimizer

程序中主要包含

1.深度半径比设置

2.海面控制网载体航迹设置

3.海底控制网设置

4.观测时间设置

5.背景声速场设置

6.声速梯度设置

7.偶然误差和系统误差设置

## 版本
GARNO v0.0.1 (2024.1.20)

## 使用
测试使用版本：Matlab R2022a

### 文件路径设置
将整个工具箱路径设置为包含路径，程序调用数据通常为相对路径

### 程序运行
直接运行Main.m文件

#### 深度半径比设置
Main.m文件Line 1的q表示深度半径比，可以自由设置，Line 3的i0表示循环次数

#### 海面控制网载体航迹设置
SimulationRose.m文件Line 8设置海面控制网载体航迹，这里选择‘Roses’；Line 9的petal设置花瓣个数，奇数为花瓣个数，偶数为花瓣个数的一半，文中实验以四花瓣为例，因此petal=2

1.Cirlce:圆形轨迹

2.Roses:玫瑰曲线轨迹

3.Spirl:螺旋曲线轨迹

4.Segment:线段轨迹

#### 海底控制网设置
SimulationRose.m文件Line 45这里选择Customize，设置为海底中心点位置

1.Customize:自定义设置

2.Polygon:正多边形参数设置（中心坐标X、Y、边数、外接圆半径、旋转角度）

#### 观测时间设置
SimulationRose.m文件Line 17的TimeNum为观测总时长，Line 18的TNum表示海面控制点间隔，文中实验总时长2 hour，海面控制点间隔80 second

#### 背景声速场设置
SimulationRose.m文件Line 66的INIData.SVPFilePath设置初始声速剖面，文中实验选择SSP-based；Line 72设置分层策略（1.不等间隔分层；2.等间隔分层） 

1.SSP-based：基于声速剖面构建

2.EOF-based：EOF构建

#### 声速梯度设置
GenerateSVPGrid的Line 122的C=v+n*y(j)表示在N方向设置n大小的水平梯度，通过更改n的大小改变水平梯度大小


#### 偶然误差和系统误差设置
SimulationRose.m文件Line 116进行误差设置：

1.GNSS天线误差INIData.CoordianteError=[0;0;0];

2.传播时间误差INIData.TimeError=[1*10^-4,0];

3.授时误差INIData.TimeSerivceError=[0,0];

4.姿态角误差INIData.AttitudeError=[0;0;0];

5.臂长参数误差INIData.ATDError=[0;0;0];

6.海底坐标点误差INIData.SolidTideError=[0;0;0];








