//
//  ViewController.m
//  SXAlertViewDemo
//
//  Created by 沈兆良 on 2017/10/10.
//  Copyright © 2017年 沈兆良. All rights reserved.
//

#import "ViewController.h"
#import "SXAlertView.h"

@interface ViewController ()<SXAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textResult;

@end

@implementation ViewController

- (IBAction)clickNone:(UIButton *)sender {
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:@"用户调研" message:@"当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.animationOption = SXAlertAnimationOptionNone;
    [alertView show];
}

- (IBAction)clickZoom:(UIButton *)sender {
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:@"用户调研" message:@"当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.animationOption = SXAlertAnimationOptionZoom;
    [alertView show];
}

- (IBAction)clickTop:(UIButton *)sender {
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:@"用户调研" message:@"当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.animationOption = SXAlertAnimationOptionTopToCenter;
    [alertView show];
}

- (IBAction)clickButton:(UIButton *)sender {
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:@"用户调研" message:@"当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"button1", @"button2", @"button3", @"button4", @"button5", nil];
    alertView.animationOption = SXAlertAnimationOptionTopToCenter;
    [alertView show];
}
- (IBAction)clickText:(UIButton *)sender {
    [SXAlertView showWithTitle:@"用户调研" message:@"当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。\n当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。\n当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        NSLog(@"%s %zd", __FUNCTION__, buttonIndex);
    }];

}
- (IBAction)clickTextField:(UIButton *)sender {
    [SXAlertView showWithTitle:@"用户调研" placeholder:@"请输入内容" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex, NSString * _Nonnull text) {
        NSLog(@"%s %zd %@", __FUNCTION__, buttonIndex, text);
        self.textResult.text = text;
    }];
}

- (IBAction)clickTextView:(UIButton *)sender {
    [SXAlertView showTextViewWithTitle:@"用户调研" placeholder:@"请输入内容" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex, NSString * _Nonnull text) {
        NSLog(@"%s %zd %@", __FUNCTION__, buttonIndex, text);
        self.textResult.text = text;
    }];
}
- (IBAction)clickVisual:(UIButton *)sender {
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:@"用户调研" message:@"当客户拜访及业务轮岗形成良好的机制，同时产品发展到一定规模后，用户调研问卷就成为更加高效的获取用户声音的重要手段了。不同于C端产品，B端产品的调研问卷内容应该更加详细，更加坦诚的询问产品功能与用户的使用体验。定期的进行客户问卷调研，能够建立良好、有效的客户沟通机制，加深产品与客户之间的相互理解。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.animationOption = SXAlertAnimationOptionTopToCenter;
    alertView.visual = YES;
    [alertView show];
}

- (IBAction)clickWLessH:(UIButton *)sender {
    [SXAlertView showWithTitle:@"发送图片给：哈哈哈" image:[UIImage imageNamed:@"pic1"] cancelButtonTitle:@"取消" otherButtonTitle:@"确定" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex) {
         NSLog(@"%s %zd", __FUNCTION__, buttonIndex);
    }];
    
}
- (IBAction)clickWEqualH:(UIButton *)sender {
    [SXAlertView showWithTitle:@"发送图片给：哈哈哈" image:[UIImage imageNamed:@"pic3"] cancelButtonTitle:@"取消" otherButtonTitle:@"确定" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex) {
         NSLog(@"%s %zd", __FUNCTION__, buttonIndex);
    }];
    
}
- (IBAction)clickWGreaterH:(UIButton *)sender {
    [SXAlertView showWithTitle:@"发送图片给：哈哈哈" image:[UIImage imageNamed:@"pic2"] cancelButtonTitle:@"取消" otherButtonTitle:@"确定" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        NSLog(@"%s %zd", __FUNCTION__, buttonIndex);
    }];
    
}


- (void)alertView:(SXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%s %zd", __FUNCTION__, buttonIndex);
}
@end
