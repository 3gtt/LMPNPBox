# LMPNPBox

[![CI Status](https://img.shields.io/travis/Liam Lincoln/LMPNPBox.svg?style=flat)](https://travis-ci.org/Liam Lincoln/LMPNPBox)
[![Version](https://img.shields.io/cocoapods/v/LMPNPBox.svg?style=flat)](https://cocoapods.org/pods/LMPNPBox)
[![License](https://img.shields.io/cocoapods/l/LMPNPBox.svg?style=flat)](https://cocoapods.org/pods/LMPNPBox)
[![Platform](https://img.shields.io/cocoapods/p/LMPNPBox.svg?style=flat)](https://cocoapods.org/pods/LMPNPBox)

A fast integration of multiple IM communication plug-in.

## 示例项目

要运行事例项目，请下载该项目到本地进入`Example`目录下运行 `pod install`，打开工程项目。

##要求

| LMPNPBox 版本 | iOS最低版本   | 
|:--------------------:|:--------------------:|
| 0.1.0 | iOS 9 | 

## 安装

使用Cocoapods安装，podfile文件中添加以下内容：

```ruby
pod 'LMPNPBox'
/// ALiyun
pod 'LMPNPBox', '~> 0.1.0' :subspecs => ['AliyunMQTT']
/// NIM
pod 'LMPNPBox', '~> 0.1.0' :subspecs => ['NIM']
/// TIM
pod 'LMPNPBox', '~> 0.1.0' :subspecs => ['TIM']
/// multiple
pod 'LMPNPBox', '~> 0.1.0' :subspecs => ['TIM', 'NIM', 'AliyunMQTT']
```
## 使用
请下载demo并查看。并不复杂。

## License

LMPNPBox在MIT许可下可用。更多信息请参见LICENSE文件。

## Notice

本项目仅供技术交流，请告知侵权行为。