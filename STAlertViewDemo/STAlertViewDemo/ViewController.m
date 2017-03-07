//
//  ViewController.m
//  UIVisualEffectDemo
//
//  Created by ST on 17/3/2.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "ViewController.h"

#import "STAlertView.h"

@interface ViewController ()<STAlertViewDelegate>

@end

@implementation ViewController

#pragma mark - --- 1.lift cycle 生命周期 ---

#pragma mark - --- 2.delegate 视图委托 ---
- (void)alertView:(STAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     NSLog(@"%s %ld", __FUNCTION__, (long)buttonIndex);
}

#pragma mark - --- 3.event response 事件相应 ---
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *title = @"你真的会使用模糊效果吗？";
    NSString *message = @"现在市场上交互设计做的比较成功的产品无一不是在功能性设计上给用户良好的体验。但是我们要知道在产品“同质化”的时代，同类产品的功能和价格趋于相同，产品的用户体验和美学价值在用户的选择中起了关键作用。我们如何在保证实现功能性需求的同时又可以让产品更好用好看呢？惊喜往往存在于被忽视的点上，这篇文章我就来给大家谈谈经常被我们忽视的模糊效果（Blur Effects）";
    NSString *cancelButtonTitle = @"取消";
    
    STAlertView *alertViewST = [[STAlertView alloc]initWithTitle:title
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:cancelButtonTitle
                                                otherButtonTitles:@"确定",nil];
    alertViewST.animationOption = STAlertAnimationOptionZoom;
    [alertViewST show];
}


#pragma mark - --- 4.private methods 私有方法 ---

#pragma mark - --- 5.setters 属性 ---

#pragma mark - --- 6.getters 属性 —--

@end
