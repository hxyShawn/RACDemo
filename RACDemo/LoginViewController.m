//
//  LoginViewController.m
//  RACDemo
//
//  Created by choice on 2020/4/14.
//  Copyright © 2020 choice. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self confUI];
}

- (void)confUI
{
    UITextField *phoneTextField = [[UITextField alloc]init];
    [self.view addSubview:phoneTextField];
    phoneTextField.placeholder = @"手机号";
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    RACSignal *phoneSignal = [phoneTextField rac_textSignal];
    
    UITextField *pwdTextField = [[UITextField alloc]init];
    [self.view addSubview:pwdTextField];
    pwdTextField.placeholder = @"密码";
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    RACSignal *pwdSignal = [pwdTextField rac_textSignal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColor]];

    [[phoneSignal filter:^BOOL(id  _Nullable value) {
        NSLog(@"%@",value);
        BOOL notNumber = ![self validateNumber:[value stringValue]];
        BOOL lengthTooLong = [value stringValue].length > 11;
        return notNumber || lengthTooLong;
    }] subscribeNext:^(id  _Nullable x) {
        phoneTextField.text = [phoneTextField.text substringToIndex:phoneTextField.text.length - 1];
    }];
    
    [[pwdSignal filter:^BOOL(id  _Nullable value) {
        NSLog(@"value");
        return YES;
    }]subscribeNext:^(id  _Nullable x) {
        
    }];
    
    [[[pwdSignal ignore:@""] filter:^BOOL(id  _Nullable value) {
        NSLog(@"%@",value);
        BOOL notNumber = ![self validateNumberOrCharacter:[value stringValue]];
        BOOL lengthTooLong = [value stringValue].length > 18;
        return notNumber || lengthTooLong;
    }] subscribeNext:^(id  _Nullable x) {
        pwdTextField.text = [pwdTextField.text substringToIndex:pwdTextField.text.length - 1];
    }];
    
    [[[[button rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        button.enabled = NO;
    }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        //flattenMap跟map不同的是返回的是一个信号
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        button.enabled = YES;
        BOOL success = [x boolValue];
        NSLog(@"下一步 %d",success);
    }];
       
    RAC(button,enabled) = [RACSignal combineLatest:@[phoneSignal,pwdSignal]  reduce:^id _Nullable{
        return @(phoneTextField.text.length == 11 && pwdTextField.text.length >= 8);
    }];
    
    [RACObserve(button, enabled) subscribeNext:^(id  _Nullable x) {
        button.backgroundColor = [x boolValue] ? [UIColor yellowColor] :[UIColor grayColor];
    }];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@80);
    }];
    
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@80);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTextField.mas_bottom).offset(20);
        make.left.right.equalTo(phoneTextField);
        make.height.equalTo(@40);
    }];
}

- (BOOL)validateNumberOrCharacter:(NSString*)string
{
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;
        
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)string
{
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57) return NO; //
    }
    return YES;
}

@end
