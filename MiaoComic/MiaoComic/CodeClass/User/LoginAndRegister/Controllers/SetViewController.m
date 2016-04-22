//
//  SetViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SetViewController.h"
#import "UserInfoManager.h"
#import "UserViewController.h"

@interface SetViewController ()

/**注册输入手机号*/
@property (nonatomic, strong) UITextField *nameTf;

/**注册输入手机号*/
@property (nonatomic, strong) UITextField *pwdTf;

@end

@implementation SetViewController

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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 110, 210, 220, 80)];
    view.layer.cornerRadius = 10;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[UIColor colorWithHue:228/255.0 saturation:176/255.0 brightness:183/255.0 alpha:255/255.0] CGColor];
    [self.view addSubview:view];
    
    UIImageView *pImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    pImage.image = [UIImage imageNamed:@"nickname_1"];
    [view addSubview:pImage];
    _nameTf = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, 170, 30)];
    _nameTf.placeholder = @"输入您的昵称";
    [view addSubview:_nameTf];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 220, 1)];
    line.backgroundColor = [UIColor colorWithHue:228/255.0 saturation:176/255.0 brightness:183/255.0 alpha:255/255.0];
    [view addSubview:line];
    
    UIImageView *qImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 20, 20)];
    qImage.image = [UIImage imageNamed:@"Login_Pwd_1"];
    [view addSubview:qImage];
    _pwdTf = [[UITextField alloc] initWithFrame:CGRectMake(45, 45, 170, 30)];
    _pwdTf.placeholder = @"输入您的密码";
    _pwdTf.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:_pwdTf];
    
    UIButton *yButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yButton.layer.cornerRadius = 10;
    yButton.frame = CGRectMake(ScreenWidth / 2 - 110, 300, 220, 40);
    [yButton setTitle:@"提交" forState:UIControlStateNormal];
    [yButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    yButton.backgroundColor = [UIColor colorWithHue:228/255.0 saturation:176/255.0 brightness:183/255.0 alpha:255/255.0];
    [self.view addSubview:yButton];
}

// 返回
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 注册完成
-(void)finish{
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api.kuaikanmanhua.com/v1/phone/signup" dic:@{@"nickname":_nameTf.text,@"password":_pwdTf.text} successful:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"message"] isEqualToString:@"OK"]){
                [UserInfoManager conserVeUserIcon:dic[@"data"][@"avatar_url"]];
                [UserInfoManager conserveUserID:dic[@"data"][@"id"]];
                [UserInfoManager conserveUserName:dic[@"data"][@"nickname"]];
                NSLog(@"成功");
                UserViewController *userVC = [[UserViewController alloc] init];
                [self presentViewController:userVC animated:YES completion:nil];
            }else{
                NSLog(@"%@",dic[@"errors"]);
            }
            
        });
        NSLog(@"%@",dic);
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
