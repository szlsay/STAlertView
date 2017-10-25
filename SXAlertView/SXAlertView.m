//
//  SXAlertView.m
//  SXAlertView
//
//  Created by 沈兆良 on 2017/10/10.
//  Copyright © 2017年 沈兆良. All rights reserved.
//

#import "SXAlertView.h"

typedef void (^SXAlertViewClickButtonBlock) (SXAlertView *alertView, NSInteger buttonIndex);
typedef void (^SXAlertViewClickTextFieldBlock) (SXAlertView *alertView, NSInteger buttonIndex, NSString *text);

CGFloat const marginX = 16;
CGFloat const marginY = 20;
@interface SXAlertView()<UITextViewDelegate>

/** 1.视图的宽高 */
@property(nonatomic, assign, readonly)CGFloat screenWidth;
@property(nonatomic, assign, readonly)CGFloat screenHeight;
@property(nonatomic, assign, readonly)CGFloat contentWidth;
@property(nonatomic, assign, readonly)CGFloat contentHeight;

/** 2.视图容器 */
@property(nonatomic, strong)UIView *contentView;
/** 3.标题视图 */
@property(nonatomic, strong)UITextView *labelTitle;
/** 4.内容视图 */
@property(nonatomic, strong)UITextView *labelMessage;
/** 5.图片视图 */
@property(nonatomic, strong)UIImageView *imageIcon;
/** 5.处理delegate传值 */
@property(nonatomic, strong)NSMutableArray<UIButton *> *arrayButton;
/** 6.虚化视图 */
@property(nonatomic, strong)UIVisualEffectView *effectView;

@property(nonatomic, strong)UITextView *textView;
@property(nonatomic, strong)UITextField *textFieldContent;

/** 7.显示的数据 */
@property(nonatomic, strong, nullable)NSString *title;
@property(nonatomic, strong, nullable)NSString *message;
@property(nonatomic, strong, nullable)UIImage *image;
@property(nonatomic, strong, nullable)NSString *placeholder;
@property(nonatomic, strong, nullable)NSString *cancelButtonTitle;
@property(nonatomic, strong, nullable)NSMutableArray<NSString *> *otherButtonTitles;

@property(nonatomic, copy)SXAlertViewClickButtonBlock clickButtonBlock;
@property(nonatomic, copy)SXAlertViewClickTextFieldBlock clickTextFieldBlock;
@end

@implementation SXAlertView

#pragma mark - --- 1.lift cycle 生命周期 ---

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id <SXAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    if (self = [super init]) {
        
        // 1.设置数据
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        
        _cancelButtonTitle = cancelButtonTitle;
        NSString * eachObject;
        va_list argumentList;
        if (otherButtonTitles)
        {
            [self.otherButtonTitles addObject:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, NSString *)))
                [self.otherButtonTitles addObject:eachObject];
            va_end(argumentList);
        }
        
        // 2.初始化UI
        [self setupDefault];
        
        // 3.添加子视图
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelMessage];
        
        // 4.初始化Button
        [self setupButton];
    }
    return self;
}

+ (void)showWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView * _Nonnull, NSInteger))block{
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    alertView.clickButtonBlock = block;
    [alertView show];
}

- (instancetype)initWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block{
    if (self = [super init]) {
        // 1.设置数据
        self.title = title;
        self.placeholder = placeholder;
        self.clickTextFieldBlock = block;
        // 2.初始化UI
        [self setupDefault];
        // 3.添加子视图
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.textField];
        // 4.初始化Button
        CGFloat buttonY = CGRectGetMaxY(self.textField.frame) + 20;
        [self setupButtonWithbuttonY:buttonY cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
        // 5.添加通知
        [self addObserverKeyboardNotification];
    }
    return self;
}

+ (void)showWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block{
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:title placeholder:placeholder  cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle clickButtonBlock:block];
    [alertView show];
}

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex))block{
    if (self = [super init]) {
        // 1.设置数据
        self.widthImage = 88;
        self.title = title;
        _cancelButtonTitle = cancelButtonTitle;
        [self.otherButtonTitles addObject:otherButtonTitle];
        self.image = image;
        self.clickButtonBlock = block;
        // 2.初始化UI
        [self setupDefault];
        // 3.添加子视图
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.self.imageIcon];
        // 4.初始化Button
        CGFloat buttonY = CGRectGetMaxY(self.imageIcon.frame) + 20;
        [self setupButtonWithbuttonY:buttonY cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
        
    }
    return self;
}

+ (void)showWithTitle:(nullable NSString *)title image:(nullable UIImage *)image cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex))block{
    SXAlertView *alertView = [[SXAlertView alloc]initWithTitle:title image:image  cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle clickButtonBlock:block];
    [alertView show];
}

- (instancetype)initTextViewWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block{
    if (self = [super init]) {
        // 1.设置数据
        self.title = title;
        self.textFieldContent.placeholder = placeholder;
        self.clickTextFieldBlock = block;
        // 2.初始化UI
        [self setupDefault];
        // 3.添加子视图
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.textView];
        // 4.初始化Button
        CGFloat buttonY = CGRectGetMaxY(self.textView.frame) + 20;
        [self setupButtonWithbuttonY:buttonY cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
        // 5.添加通知
        [self addObserverKeyboardNotification];
    }
    return self;
}

+ (void)showTextViewWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(nullable void (^)(SXAlertView *alertView, NSInteger buttonIndex, NSString *text))block{
    SXAlertView *alertView = [[SXAlertView alloc]initTextViewWithTitle:title placeholder:placeholder  cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle clickButtonBlock:block];
    [alertView show];
}

- (void)dealloc{
    [self removeObserverKeyboardNotification];
}

- (void)setupDefault{
    self.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.visual = NO;
    self.animationOption = SXAlertAnimationOptionZoom;
    [self addSubview:self.effectView];
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setupButton{
    CGFloat buttonY = CGRectGetMaxY(self.labelMessage.frame) + 20;
    
    NSInteger countRow = 0;
    if (self.cancelButtonTitle) {
        countRow = 1;
    }
    countRow += self.otherButtonTitles.count;
    
    switch (countRow) {
        case 0:{
            [self.contentView addSubview:[self buttonWithFrame:CGRectMake(0,buttonY, self.contentWidth, self.contentHeight/2) title:@"" target:self action:@selector(clickCancel:)]];
            
            CGFloat height = self.contentHeight/2 + buttonY;
            self.contentView.frame = CGRectMake(0, 0, self.contentWidth, height);
            self.contentView.center = self.center;
        }
            break;
        case 2:{
            NSString *titleCancel, *titleOther;
            if (self.cancelButtonTitle) {
                titleCancel = self.cancelButtonTitle;
                titleOther = self.otherButtonTitles.firstObject;
            }else {
                titleCancel = self.otherButtonTitles.firstObject;
                titleOther = self.otherButtonTitles.lastObject;
            }
            
            UIButton *buttonCancel = [self buttonWithFrame:CGRectMake(0,buttonY, self.contentWidth/2, self.contentHeight/2) title:titleCancel target:self action:@selector(clickCancel:)];
            UIButton *buttonOther = [self buttonWithFrame:CGRectMake(self.contentWidth/2, buttonY, self.contentWidth/2, self.contentHeight/2) title:titleOther target:self action:@selector(clickOther:)];
            [self.contentView addSubview:buttonOther];
            [self.contentView addSubview:buttonCancel];
            
            CGFloat height = self.contentHeight/2 + buttonY;
            self.contentView.frame = CGRectMake(0, 0, self.contentWidth, height);
            self.contentView.center = self.center;
            
        }
            break;
        default:{
            for ( NSInteger number = 0; number < countRow ; number++) {
                NSString *title = @"";
                SEL selector;
                if (self.otherButtonTitles.count > number) {
                    title = self.otherButtonTitles[number];
                    selector = @selector(clickOther:);
                }else {
                    title = self.cancelButtonTitle;
                    selector = @selector(clickCancel:);
                }
                
                UIButton *button = [self buttonWithFrame:CGRectMake(0, number * self.contentHeight/2 + buttonY, self.contentWidth, self.contentHeight/2) title:title target:self action:selector];
                [self.arrayButton addObject:button];
                [self.contentView addSubview:button];
            }
            
            CGFloat height = self.contentHeight/2 + buttonY;
            if (countRow > 2) {
                height = countRow * self.contentHeight/2 + buttonY;
            }
            self.contentView.frame = CGRectMake(0, 0, self.contentWidth, height);
            self.contentView.center = self.center;
        }
            break;
    }
}

- (void)setupButtonWithbuttonY:(CGFloat)buttonY cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle{
    UIButton *buttonCancel = [self buttonWithFrame:CGRectMake(0,buttonY, self.contentWidth/2, self.contentHeight/2) title:cancelButtonTitle target:self action:@selector(clickCancel:)];
    UIButton *buttonOther = [self buttonWithFrame:CGRectMake(self.contentWidth/2, buttonY, self.contentWidth/2, self.contentHeight/2) title:otherButtonTitle target:self action:@selector(clickOther:)];
    [self.contentView addSubview:buttonOther];
    [self.contentView addSubview:buttonCancel];
    
    CGFloat height = self.contentHeight/2 + buttonY;
    self.contentView.frame = CGRectMake(0, 0, self.contentWidth, height);
    self.contentView.center = self.center;
}

#pragma mark - --- 2.delegate 视图委托 ---
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%s %@", __FUNCTION__, textView);
    if (textView.text.length > 0) {
        self.textFieldContent.hidden = YES;
    }else {
        self.textFieldContent.hidden = NO;
    }
    
    if (self.clickTextFieldBlock) {
        self.clickTextFieldBlock(self, -1, textView.text);
    }
}
#pragma mark - --- 3.event response 事件相应 ---
#pragma mark - --- 3.1.1 点击 - 取消按钮事件 ---
- (void)clickCancel:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:0];
    }
    
    if (self.clickButtonBlock) {
        self.clickButtonBlock(self, 0);
    }
    
    if (self.textField.text.length > 0) {
        if (self.clickTextFieldBlock) {
            self.clickTextFieldBlock(self, 0, self.textField.text);
        }
    }else if (self.textView.text.length > 0){
        if (self.clickTextFieldBlock) {
            self.clickTextFieldBlock(self,0, self.textView.text);
        }
    }else {
        if (self.clickTextFieldBlock) {
            self.clickTextFieldBlock(self,0, @"");
        }
    }
    [self remove];
}

#pragma mark - --- 3.1.2 点击 - 其他按钮事件 ---
- (void)clickOther:(UIButton *)button{
    NSInteger buttonIndex = 0;
    if (self.cancelButtonTitle) {
        buttonIndex = 1;
    }
    if (self.arrayButton.count) {
        buttonIndex += [self.arrayButton indexOfObject:button];
    }
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
    
    if (self.clickButtonBlock) {
        self.clickButtonBlock(self, buttonIndex);
    }
    
    if (self.textField.text.length > 0) {
        if (self.clickTextFieldBlock) {
            self.clickTextFieldBlock(self, 1, self.textField.text);
        }
    }else if (self.textView.text.length > 0){
        if (self.clickTextFieldBlock) {
            self.clickTextFieldBlock(self, 1, self.textView.text);
        }
    }else {
        if (self.clickTextFieldBlock) {
            self.clickTextFieldBlock(self, 1, @"");
        }
    }
    
    [self remove];
}

#pragma mark - --- 3.2 UITextField - 编辑事件 ---
- (void)clickTextChanged:(UITextField *)textField{
    if (self.clickTextFieldBlock) {
        self.clickTextFieldBlock(self, -1, textField.text);
    }
}

#pragma mark - --- 3.3 视图展示与隐藏 ---
- (void)show {
    // 用于隐藏已显示的键盘
    [[[UIInputViewController alloc] init] dismissKeyboard];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];

    switch (self.animationOption) {
        case SXAlertAnimationOptionNone:{
            self.contentView.alpha = 0.0;
            [UIView animateWithDuration:0.34 animations:^{
                if (self.visual) {
                    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                }
                self.contentView.alpha = 1.0;
            }];
        }break;
        case SXAlertAnimationOptionZoom:{
            [self.contentView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 if (self.visual) {
                                     self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                                 }
                                 [self.contentView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                             } completion:nil];
        }break;
        case SXAlertAnimationOptionTopToCenter:{
            CGPoint startPoint = CGPointMake(self.center.x, - CGRectGetHeight(self.contentView.frame));
            self.contentView.layer.position = startPoint;
            [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 if (self.visual) {
                                     self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                                 }
                                 self.contentView.layer.position = self.center;
                             } completion:nil];
        }break;
        default:
            break;
    }
}

- (void)remove{
    switch (self.animationOption) {
        case SXAlertAnimationOptionNone:{
            [UIView animateWithDuration:0.3 animations:^{
                if (self.visual) {
                    self.effectView.effect = nil;
                }
                self.contentView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }break;
        case SXAlertAnimationOptionZoom:{
            [UIView animateWithDuration:0.3 animations:^{
                self.contentView.alpha = 0.0;
                if (self.visual) {
                    self.effectView.effect = nil;
                }
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }break;
        case SXAlertAnimationOptionTopToCenter:{
            CGPoint endPoint = CGPointMake(self.center.x, CGRectGetHeight(self.frame) + CGRectGetHeight(self.contentView.frame));
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.visual) {
                    self.effectView.effect = nil;
                }
                self.contentView.layer.position = endPoint;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }break;
        default:
            break;
    }
}

#pragma mark - --- 3.4 键盘通知事件 ---
- (void)addObserverKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserverKeyboardNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = rect.size.height;
    CGPoint center = self.center;
    center.y -= height/2;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = center;
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti{
    CGPoint center = self.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = center;
    }];
}
#pragma mark - --- 4.private methods 私有方法 ---

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(nullable id)target action:(nullable SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitleColor:[UIColor colorWithRed:(70.0/255) green:(130.0/255) blue:(233.0/255) alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:(235.0/255) green:(235.0/255) blue:(235.0/255) alpha:1.0]] forState:UIControlStateHighlighted];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *lineUp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
    lineUp.backgroundColor = [UIColor colorWithRed:(219.0/255) green:(219.0/255) blue:(219.0/255) alpha:1.0];
    
    UIView *lineRight = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width, 0, 0.5, frame.size.height)];
    lineRight.backgroundColor = [UIColor colorWithRed:(219.0/255) green:(219.0/255) blue:(219.0/255) alpha:1.0];
    
    [button addSubview:lineUp];
    [button addSubview:lineRight];
    return button;
}

#pragma mark - --- 5.setters 属性 ---

- (void)setTitle:(NSString *)title{
    _title = title;
    self.labelTitle.text = title;
    
    CGFloat labelX = marginX;
    CGFloat labelY = marginY;
    CGFloat labelW = self.contentWidth - 2*labelX;
    
    [self.labelTitle sizeToFit];
    CGSize sizeTitle = self.labelTitle.frame.size;
    if (sizeTitle.height > self.screenHeight/2) {
        sizeTitle.height = self.screenHeight/2;
    }
    CGFloat labelH = sizeTitle.height;
    if (!title) {
        labelH = 0;
    }
    self.labelTitle.frame = CGRectMake(labelX, labelY, labelW, labelH);
    self.textView.frame = CGRectMake(labelX, labelY+labelH+5, labelW, 75);
}

- (void)setMessage:(NSString *)message{
    
    _message = message;
    
    CGFloat labelX = marginX;
    CGFloat labelY = CGRectGetMaxY(self.labelTitle.frame) + 5;
    CGFloat labelW = self.contentWidth - 2*labelX;
    
    self.labelMessage.text = message;
    [self.labelMessage sizeToFit];
    CGSize sizeMessage = self.labelMessage.frame.size;
    if (sizeMessage.height > self.screenHeight/2) {
        sizeMessage.height = self.screenHeight/2;
    }
    CGFloat labelH = sizeMessage.height;
    if (!message) {
        labelH = 0;
    }
    self.labelMessage.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    CGFloat tfX = marginX;
    CGFloat tfY = CGRectGetMaxY(self.labelTitle.frame) + 5;
    CGFloat tfW = self.contentWidth - 2*tfX;
    
    self.textField.placeholder = placeholder;
    [self.textField sizeToFit];
    CGSize sizeMessage = self.textField.frame.size;
    if (sizeMessage.height > self.screenHeight/2) {
        sizeMessage.height = self.screenHeight/2;
    }
    CGFloat tfH = sizeMessage.height;
    self.textField.frame = CGRectMake(tfX, tfY, tfW, tfH);
}

- (void)setImage:(UIImage *)image{
    _image = image;
    CGFloat labelY = CGRectGetMaxY(self.labelTitle.frame) + 5;
    self.imageIcon.image = image;
    [self.imageIcon sizeToFit];
    CGFloat imageW = self.imageIcon.frame.size.width;
    CGFloat imageH = self.imageIcon.frame.size.height;
    
    if (imageW > imageH) {
        CGFloat h = imageH;
        imageH = self.widthImage;
        imageW = imageW / h * self.widthImage;
        
        if (imageW > self.contentWidth - 2*marginX) {
            imageW = self.contentWidth - 2*marginX;
        }
    }else if (imageW == imageH){
        imageW = self.widthImage;
        imageH = self.widthImage;
    }else {
        CGFloat w = imageW;
        imageW = self.widthImage;
        imageH = imageH / w * self.widthImage;
        
        if (imageH > self.contentWidth - 2*marginX) {
            imageH = self.contentWidth - 2*marginX;
        }
    }
    
    CGFloat labelX = (self.contentWidth - imageW)/2;
    self.imageIcon.frame = CGRectMake(labelX, labelY, imageW, imageH);
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    self.labelMessage.textAlignment = textAlignment;
}

- (void)setVisual:(BOOL)visual{
    _visual = visual;
    if (visual) {
        self.effectView.backgroundColor = [UIColor clearColor];
    }else {
        self.effectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    }
}
#pragma mark - --- 6.getters 属性 —--
- (CGFloat)screenWidth{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

- (CGFloat)screenHeight{
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

- (CGFloat)contentWidth{
    return 270;
}

- (CGFloat)contentHeight{
    return 88;
}

- (NSMutableArray<NSString *> *)otherButtonTitles{
    if (!_otherButtonTitles) {
        _otherButtonTitles = @[].mutableCopy;
    }
    return _otherButtonTitles;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.frame = CGRectMake(0, 0, self.contentWidth, self.contentHeight);
        _contentView.center = CGPointMake(self.screenWidth/2, self.screenHeight/2);
        
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _contentView;
}

- (UITextView *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle = [[UITextView alloc]init];
        _labelTitle.frame = CGRectMake(marginX, marginY, self.contentWidth-2*marginX, 0);
        _labelTitle.textColor = [UIColor blackColor];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont boldSystemFontOfSize:17];
        [_labelTitle setEditable:NO];
        [_labelTitle setSelectable:NO];
    }
    return _labelTitle;
}

- (UITextView *)labelMessage
{
    if (!_labelMessage) {
        _labelMessage = [[UITextView alloc]init];
        _labelMessage.frame = CGRectMake(marginX, marginY, self.contentWidth-2*marginX, 0);
        _labelMessage.textColor = [UIColor blackColor];
        _labelMessage.textAlignment = NSTextAlignmentCenter;
        _labelMessage.font = [UIFont systemFontOfSize:13];
        [_labelMessage setEditable:NO];
        [_labelMessage setSelectable:NO];
    }
    return _labelMessage;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.frame = CGRectMake(marginX, marginY, self.contentWidth-2*marginX, 0);
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        [_textField addTarget:self action:@selector(clickTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIImageView *)imageIcon{
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc]init];
    }
    return _imageIcon;
    
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc]init];
        _effectView.effect = nil;
        _effectView.frame = self.frame;
        _effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _effectView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(marginX, marginY, self.contentWidth-2*marginX, 75);
        _textView.textColor = [UIColor blackColor];
        _textView.font = [UIFont systemFontOfSize:15];
        [_textView.layer setBorderColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1].CGColor];
        [_textView.layer setBorderWidth:0.5];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setCornerRadius:4];
        [_textView addSubview:self.textFieldContent];
        [_textView setDelegate:self];
    }
    return _textView;
}

- (UITextField *)textFieldContent
{
    if (!_textFieldContent) {
        _textFieldContent = [[UITextField alloc]init];
        _textFieldContent.frame = CGRectMake(4, -6, self.contentWidth-2*marginX, 44);
        _textFieldContent.font = [UIFont systemFontOfSize:15];
        _textFieldContent.borderStyle = UITextBorderStyleNone;
        [_textFieldContent setEnabled:NO];
    }
    return _textFieldContent;
}

- (NSMutableArray<UIButton *> *)arrayButton
{
    if (!_arrayButton) {
        _arrayButton = @[].mutableCopy;
    }
    return _arrayButton;
}

@end

