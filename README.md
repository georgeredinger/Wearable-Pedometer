Wearable-Pedometer
==================

open source Wearable Pedometer base on nRF51822-AK

# 计步器 pedometer
## 目的
实现一个开源的计步器，尽量采用已有的硬件和软件，最大限度的提高简便性。让这个项目不再成为少数高手的玩具。

研究原理是目的，商业目的和外观、材料等问题不在该项目讨论范围内。

现阶段将原型搭建完毕即可，后续需要全世界感兴趣的朋友来不断完善。

## 准备工作

### 了解硬件
了解主芯片nRF51822（集成蓝牙4.0的Cortex-M0）：
http://pan.baidu.com/share/link?shareid=1902628038&uk=4228226257

了解运动检测芯片MPU6050（带加速度计和陀螺仪）：
http://pan.baidu.com/share/link?shareid=1896779578&uk=4228226257

了解硬件平台nRF51822-AK（官方EK或者Pro均可，但是需要外接MPU6050模块）
http://pan.baidu.com/share/link?shareid=1904393090&uk=4228226257

### 安装编译软件
KEIL 4.7.2：
http://pan.baidu.com/share/link?shareid=1885488220&uk=4228226257

#### 安装TortoisGit：
https://code.google.com/p/tortoisegit/
*Git是版本管理软件，我们的开源项目将会放到github（还有其他git托管服务器）上，方便全世界的朋友一起完善。*

### 学习计步器原理：
http://www.analog.com/library/analogDialogue/china/archives/44-06/pedometer.html


## 实现原型

### 硬件部分
使用nRF51822-AK（官方EK或者Pro均可，但是需要外接MPU6050模块）为硬件平台

### 手机APP
使用NORDIC官方提供的nRF HRM（心率计）app为基础。注意这个软件可能单独提供，也可能包含在nRF Utility中。

官方提供如下app和支持如下设备：
http://www.nordicsemi.com/Products/nRFready-Demo-APPS


