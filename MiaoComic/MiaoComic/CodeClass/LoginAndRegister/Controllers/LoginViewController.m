//
//  LoginViewController.m
//  Comic
//
//  Created by lanou on 16/4/16.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCell.h"
#import "NetWorkRequestManager.h"

@interface LoginViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *loginTableView;// 填写用户登录信息（账号、密码）的tableView

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左按钮（返回按钮）
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBar;
    
    // 右按钮（忘记密码按钮）
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(ScreenWidth - 70, 0, 70, 15);
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetButton addTarget:self action:@selector(forget) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *forgetBar = [[UIBarButtonItem alloc] initWithCustomView:forgetButton];
    self.navigationItem.rightBarButtonItem = forgetBar;

    
    // 注册cell的nib文件
    [_loginTableView registerNib:[UINib nibWithNibName:@"LoginCell" bundle:nil] forCellReuseIdentifier:@"loginCell"];
    
    _loginTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _loginTableView.separatorColor = [UIColor grayColor];
    _loginTableView.scrollEnabled = NO; //设置tableview 不能滚动
    
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 返回和忘记密码按钮

// 返回
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 忘记密码
- (void)forget {
    
}


#pragma mark - 页面点击上触发的按钮点击事件

// 登录
- (IBAction)login:(id)sender {
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api.kuaikanmanhua.com/v1/phone/signin" dic:@{@"phone":((LoginCell *)([_loginTableView viewWithTag:1001])).loginTextFiled.text,@"password":((LoginCell *)([_loginTableView viewWithTag:1002])).loginTextFiled.text} successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic[@"data"][@"avatar_url"]);
    } errorMessage:^(NSError *error) {
        NSLog(@"lala");
    }];
}

// 跳转到注册界面
- (IBAction)skipToRegister:(id)sender {
}


#pragma mark - 登录信息的loginTableView设置

// UITableViewDataSource代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.loginImgV.image = [UIImage imageNamed:@"Login_Phone"];
        cell.loginTextFiled.placeholder = @"请输入用户名";
        cell.tag = 1001;
    } else {
        cell.loginImgV.image = [UIImage imageNamed:@"Login_Pwd_1"];
        cell.loginTextFiled.placeholder = @"请输入密码";
        cell.tag = 1002;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// UITableViewDelegate代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 设置cell的高度：为表格的一半，为了去掉第二条分割线，在去掉一个像素
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _loginTableView.frame.size.height / 2 + 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
