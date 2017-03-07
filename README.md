# STAlertView

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

简易UIAlertView，添加动画，虚化效果

## 显示效果
### 从上开始显示的效果和多个按钮
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STAlertView/animation1.gif)
### 在中间晃动和两个按钮
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STAlertView/animation2.gif)

## 使用方式
与系统UIAlertView的初始化、显示、委托方法相同，多添加动画接口animationOption

```
NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, STAlertAnimationOptions) {
    STAlertAnimationOptionNone            = 1 <<  0,
    STAlertAnimationOptionZoom            = 1 <<  1, // 先放大，再缩小，在还原
    STAlertAnimationOptionTopToCenter     = 1 <<  2, // 从上到中间
};

@protocol STAlertViewDelegate;
@class UILabel, UIButton, UIWindow;

@interface STAlertView : UIView
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id <STAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

// shows popup alert animated.
- (void)show;
@property(nullable,nonatomic,weak)id <STAlertViewDelegate> delegate;
@property(nonatomic)STAlertAnimationOptions animationOption;
@end

@protocol STAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(STAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END

```

## 版本控制
### 1.0
1. 支持iOS8以上
2. 添加动画，Zoom和TopToCenter动画
3. 支持虚化背景


