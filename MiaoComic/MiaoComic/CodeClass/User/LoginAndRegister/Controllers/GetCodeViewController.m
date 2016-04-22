//
//  GetCodeViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "GetCodeViewController.h"
#import "SetViewController.h"

@interface GetCodeViewController ()

/**注册输入手机号*/
@property (nonatomic, strong) UITextField *textField;

@end

@implementation GetCodeViewController

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
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 210, 30)];
    _textField.placeholder = @"输入验证码";
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:_textField];
    
    UIButton *yButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yButton.layer.cornerRadius = 10;
    yButton.frame = CGRectMake(ScreenWidth / 2 - 110, 260, 220, 40);
    [yButton setTitle:@"下一步" forState:UIControlStateNormal];
    [yButton addTarget:self action:@selector(nextclick) forControlEvents:UIControlEventTouchUpInside];
    yButton.backgroundColor = [UIColor colorWithHue:228/255.0 saturation:176/255.0 brightness:183/255.0 alpha:255/255.0];
    [self.view addSubview:yButton];
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)nextclick{
    [NetWorkRequestManager requestWithType:POST urlString:SENDURL dic:@{@"code":_textField.text,@"phone":_phone} successful:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
//        NSLog(@"%@",dic);
        SetViewController *setVC = [[SetViewController alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"message"] isEqualToString:@"OK"]){
                [self.navigationController pushViewController:setVC animated:YES];
            }else{
                NSLog(@"%@",dic[@"errors"]);
            }
            
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
