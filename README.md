##Reader
---
基于`Core Text`实现的iOS客户端的`txt电子书阅读器`。

---
**实现效果**

---

**关于Reader**
1. 可以自动提取`txt文件`章节并生成目录
2. 选取一段文字可进行复制，做笔记等功能
3. 保存阅读进度，即使退出应用也可以继续之前的阅读
4. 更改字体大小，进度条转，主题更换等功能

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