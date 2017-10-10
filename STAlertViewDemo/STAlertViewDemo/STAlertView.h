//
//  STAlertView.h
//  UIVisualEffectDemo
//
//  Created by ST on 17/3/3.
//  Copyright © 2017年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>


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

+ (void)showWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(STAlertView *alertView, NSUInteger buttonIndex))block;

// shows popup alert animated.
- (void)show;
@property(nullable,nonatomic,weak)id <STAlertViewDelegate> delegate;
@property(nonatomic)STAlertAnimationOptions animationOption;
// default is NSTextAlignmentCenter
@property(nonatomic)NSTextAlignment textAlignment;
// background visual
@property(nonatomic, assign)BOOL visual;

@end

@protocol STAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(STAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END

