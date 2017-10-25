//
//  SXAlertView.h
//  SXAlertView
//
//  Created by 沈兆良 on 2017/10/10.
//  Copyright © 2017年 沈兆良. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SXAlertAnimationOptions) {
    SXAlertAnimationOptionNone = 0,
    SXAlertAnimationOptionZoom ,       // First zoom in, and then shrink, in the reduction
    SXAlertAnimationOptionTopToCenter, // From top to center
};

@protocol SXAlertViewDelegate;
@class UILabel, UIButton, UIWindow;

@interface SXAlertView : UIView
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id <SXAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex))block;

// Used to enter text information，When the text is monitored in real time， buttonIndex = -1，if click the cancel button，buttonIndex = 0, if click the other button, buttonIndex = 1
- (instancetype)initWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block;

+ (void)showWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block;

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex))block;

+ (void)showWithTitle:(nullable NSString *)title image:(nullable UIImage *)image cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex))block;

- (instancetype)initTextViewWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block;

+ (void)showTextViewWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block;

// shows popup alert animated.
- (void)show;
@property(nullable,nonatomic,weak)id <SXAlertViewDelegate> delegate;
@property(nonatomic)SXAlertAnimationOptions animationOption;
// default is NSTextAlignmentCenter
@property(nonatomic)NSTextAlignment textAlignment;
// background visual
@property(nonatomic, assign)BOOL visual;
// Only Used to enter text information
@property(nonatomic, strong)UITextField *textField;
// default is 88
@property(nonatomic, assign)CGFloat widthImage;
@end

@protocol SXAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(SXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END


