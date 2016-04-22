//
//  RegisterViewController.m
//  Comic
//
//  Created by lanou on 16/4/16.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "RegisterViewController.h"
#import "GetCodeViewController.h"

@interface RegisterViewController ()

/**注册输入手机号*/
@property (nonatomic, strong) UITextField *textField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 左按钮（返回按钮）
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBar;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 90, 120, 180, 70)];
    imageView.image = [UIImage imageNamed:@"Log_header"];
    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 110, 210, 220, 40)];
    view.layer.cornerRadius = 10;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[UIColor colorWithHue:228/255.0 saturation:176/255.0 brightness:183/255.0 alpha:255/255.0] CGColor];
    [self.view addSubview:view];
    UIImageView *pImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    pImage.image = [UIImage imageNamed:@"Login_Phone_1"];
    [view addSubview:pImage];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, 170, 30)];
    _textField.placeholder = @"输入您的手机号";
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:_textField];
    
    UIButton *yButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yButton.layer.cornerRadius = 10;
    yButton.frame = CGRectMake(ScreenWidth / 2 - 110, 260, 220, 40);
    [yButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yButton addTarget:self action:@selector(getClick) forControlEvents:UIControlEventTouchUpInside];
    yButton.backgroundColor = [UIColor colorWithHue:228/255.0 saturation:176/255.0 brightness:183/255.0 alpha:255/255.0];
    [self.view addSubview:yButton];
}

// 返回
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 获取验证码
-(void)getClick{
    [NetWorkRequestManager requestWithType:POST urlString:GETCODEURL dic:@{@"phone":_textField.text} successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        GetCodeViewController *getCodeVC = [[GetCodeViewController alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"message"] isEqualToString:@"OK"]) {
                getCodeVC.phone = _textField.text;
                [self.navigationController pushViewController:getCodeVC animated:YES];
            }else{
                NSLog(@"%@",dic[@"errors"]);
            }
            
        });
        
        
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
}


@end
