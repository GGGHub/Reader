##Reader
---
基于`Core Text`实现的iOS客户端的`txt电子书阅读器`。</br>
**注:即将添加对epub格式的支持**

---
**部分功能实现效果**</br>
![](https://github.com/GGGHub/Reader/blob/master/LSYReader/demo.gif "部分功能")<br>
---

**关于Reader**</br>

1. 可以自动提取`txt文件`章节并生成目录
2. 选取一段文字可进行复制，做笔记等功能
3. 保存阅读进度，即使退出应用也可以继续之前的阅读
4. 更改字体大小，进度跳转，主题更换等功能

---

##安装与使用
###安装
1. 将`Reader`目录下的所有文件都添加到工程中即可

###使用
```objective-c
   LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
    pageView.resourceURL = fileURL;    //文件位置
    pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];  //阅读模型
    [self presentViewController:pageView animated:YES completion:nil];
```
###提示
**之前安装过的下载最新版，应把之前安装的卸载后再安装**
