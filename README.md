# STAlertView

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

400行代码实现的简易UIAlertView，添加动画，虚化效果。接口文件中没有对视图的更多的视图属性开放接口，使用过程中可以根据自己的需求进行自定义接口。

## 显示效果
### 从上开始显示的效果和多个按钮
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STAlertView/stalert3.gif)
### 在中间晃动和两个按钮
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STAlertView/stalert4.gif)

## 使用方式
与系统UIAlertView的初始化、显示、委托方法相同，多添加动画接口animationOption

```
@interface STAlertView : UIView
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id <STAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(void (^)(STAlertView *alertView, NSUInteger buttonIndex))block;

// shows popup alert animated.
- (void)show;
@property(nullable,nonatomic,weak)id <STAlertViewDelegate> delegate;
@property(nonatomic)STAlertAnimationOptions animationOption;
// background visual
@property(nonatomic, assign)BOOL visual;

@end

```

## 版本控制
### 1.1
1. 添加visual接口，不想使用虚化可以设置为NO
2. 添加一行代码处理

```
 + (void)showWithTitle:(nullable NSString *)title 
               message:(nullable NSString *)message 
     cancelButtonTitle:(nullable NSString *)cancelButtonTitle   
      otherButtonTitle:(nullable NSString *)otherButtonTitle 
      clickButtonBlock:(void (^)(STAlertView *alertView, NSUInteger buttonIndex))block;

```

### 1.0
1. 支持iOS8以上
2. 添加动画，Zoom和TopToCenter动画
3. 支持虚化背景


