## Reader
---
基于`Core Text`实现的iOS客户端的`电子书阅读器`。</br>
**支持ePub与text格式**

---

### 2016.11.22 更新
- **添加对ePub格式电子书的阅读排版支持**
- **添加对ePub格式电子书的图片显示支持**

---
**部分功能实现效果**</br>
![](https://github.com/GGGHub/Reader/blob/master/LSYReader/demo.gif "部分功能")<br>
---

**关于Reader**</br>

1. 可以自动提取章节并生成目录
2. 选取一段文字可进行复制，做笔记等功能
3. 保存阅读进度，即使退出应用也可以继续之前的阅读
4. 更改字体大小，进度跳转，主题更换等功能
5. 支持`txt`与`ePub`格式的电子书文件

---
## 安装与使用
### 安装
1. 将`Reader`目录下的所有文件都添加到工程中</br>
2. 由于解压`ePub`文件，需要用到开源的`.c文件`用于解压缩。所以使用时如果项目中有`.pch文件`参考本项目中`.pch`文件写法</br>
```c
#ifdef __OBJC__
//在.pch中这里写引用的.h文件与宏
#endif
```
3.需要导入`libz.tbd`库

### 使用
text文件</br>
```objective-c
   LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
    pageView.resourceURL = fileURL;    //文件位置
    pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];  //阅读模型
    [self presentViewController:pageView animated:YES completion:nil];
```
ePub文件</br>
```objective-c
   LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"细说明朝"withExtension:@"epub"];
    pageView.resourceURL = fileURL;    //文件位置
    pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];  //阅读模型
    [self presentViewController:pageView animated:YES completion:nil];
```

### 提示
**之前安装过的下载最新版，应把之前安装的卸载后再安装**

### 说明
对于有图片和定制样式的epub文件只显示纯文本信息，因为对epub每个章节的html文件直接转成字符串来处理，css样式与epub自带的本地图片没有做处理。
