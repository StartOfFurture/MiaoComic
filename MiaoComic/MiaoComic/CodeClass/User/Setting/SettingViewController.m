//
//  SettingViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SettingViewController.h"
#import "UIButton+FinishClick.h"
#import "SetUserViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

/**列表视图*/
@property (nonatomic, strong) UITableView *tableView;

/**数据数组*/
@property (nonatomic, strong) NSArray *nameArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISegmentedControl *segVC = [[UISegmentedControl alloc] initWithItems:@[@"设置"]];
    segVC.tintColor = [UIColor clearColor];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]};
    [segVC setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.navigationItem.titleView = segVC;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    _nameArray = [[NSArray alloc] initWithObjects:@[@"用户设置",@"修改密码"],@[@"清理缓存",@"版本更新",@"关于喵"],@[@"赏个好评"], nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nameArray[section] count];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuse";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    cell.textLabel.text = _nameArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                if ([[UserInfoManager getUserID] isEqual:@" "]) {
                    NSLog(@"您还没有登陆");
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"您还没有登陆" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"随便看看" style:UIAlertActionStyleDefault handler:nil];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"马上登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                        [self presentViewController:naVC animated:YES completion:nil];
                    }];
                    
                    [alter addAction:cancel];
                    [alter addAction:sure];
                    [self presentViewController:alter animated:YES completion:nil];
                    
                }
                [self.navigationController popViewControllerAnimated:YES];
                SetUserViewController *setUserVC = [[SetUserViewController alloc] init];
                [self.navigationController pushViewController:setUserVC animated:YES];
            } else {
                NSLog(@"修改密码");
            }
        }
            break;
            case 1:
        {
            if (indexPath.row == 0) {
                NSLog(@"清理缓存");
            } else if (indexPath.row == 1){
//                UILabel *hudLabel = [UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
                NSLog(@"版本更新");
            } else {
                NSLog(@"关于喵");
            }
        }
            break;
            case 2:
        {
            NSLog(@"好评");
        }
            break;
        default:
            break;
    }
}


@end
