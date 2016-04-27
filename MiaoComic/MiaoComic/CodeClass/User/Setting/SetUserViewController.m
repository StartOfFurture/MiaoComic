//
//  SetUserViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SetUserViewController.h"
#import "SetUserModel.h"


@interface SetUserViewController ()

/**显示用户头像*/
@property (nonatomic, strong) UIImageView *headerView;

/**显示用户昵称*/
@property (nonatomic, strong) UITextField *nameTf;



@end

@implementation SetUserViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[UserInfoManager getUserID] isEqual:@" "]) {
        _nameTf.text = [UserInfoManager getUserName];
        // 获取图片路径的最后一个字符
        NSString *w = [[UserInfoManager getUserIcon] substringFromIndex:[[UserInfoManager getUserIcon] length] - 1];
        // 判断
        if ([w isEqualToString:@"w"]) {
            [_headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",[UserInfoManager getUserIcon]]] placeholderImage:[UIImage imageNamed:@"pheader"]];
        } else {
            [_headerView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager getUserIcon]] placeholderImage:[UIImage imageNamed:@"pheader"]];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHue:170/255.0 saturation:5/255.0 brightness:244/255.0 alpha:255/255.0];
    self.navigationItem.title = @"编辑资料";
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, 20, 20);
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(0, 0, 20, 20);
    [done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [done setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:done];
    
    //头像视图
    _headerView = [[UIImageView alloc] init];
    _headerView.frame = CGRectMake(ScreenWidth / 2 - 50, 100, 100, 100);
    _headerView.layer.cornerRadius= 50;
    _headerView.layer.masksToBounds = YES;//
    _headerView.userInteractionEnabled = YES;// 打开用户交互
    _headerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_headerView];
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(10, 210, ScreenWidth - 20, 40)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameView];
    UILabel *nLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 30)];
//    nLabel.backgroundColor = [UIColor blueColor];
    nLabel.text = @"昵称:";
    [nameView addSubview:nLabel];
    _nameTf = [[UITextField alloc] initWithFrame:CGRectMake(60, 5, nameView.frame.size.width - 70, 30)];
    [_nameTf becomeFirstResponder];
    [nameView addSubview:_nameTf];
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)done{
    [self.view endEditing:YES];
    NSString *str = [NSString stringWithFormat:UPDATEUSERURL];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetWorkRequestManager requestWithType:POST urlString:str dic:@{@"nickname":_nameTf.text} successful:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"data is %@",dataDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel *hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 75, ScreenHeight / 2, 150, 40)];
            hudLabel.text = @"保存修改...";
            hudLabel.font = [UIFont systemFontOfSize:18];
            hudLabel.layer.cornerRadius = 5;
            hudLabel.layer.masksToBounds = YES;
            hudLabel.layer.borderColor = [[UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0] CGColor];
            hudLabel.layer.borderWidth = 2;
            hudLabel.textAlignment = NSTextAlignmentCenter;
            hudLabel.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:hudLabel];
            
            if ([dataDic[@"code"]  isEqual: @200]) {
                
                // 跳出弹框修改完成
                [UIView animateWithDuration:2 animations:^{
                    // 保存用户信息
                    [UserInfoManager conserVeUserIcon:dataDic[@"data"][@"avatar_url"]];
                    [UserInfoManager conserveUserID:dataDic[@"data"][@"id"]];
                    [UserInfoManager conserveUserName:dataDic[@"data"][@"nickname"]];
                    hudLabel.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
            }
            
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
    
    NSLog(@"修改完成");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
