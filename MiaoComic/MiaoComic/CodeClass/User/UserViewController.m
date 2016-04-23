//
//  UserVieViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "UserViewController.h"
#import "SettingViewController.h"
#import "AttentionViewController.h"
#import "CollectViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"
#import "UserInfoManager.h"

@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate>

/**列表视图*/
@property (nonatomic, strong) UITableView *tableView;

/**图标数组*/
@property (nonatomic, strong) NSArray *icoArray;

/**标题数组*/
@property (nonatomic, strong) NSArray *titleArray;

/**显示登录Label*/
@property (nonatomic, strong) UILabel *nameLabel;

/**显示用户头像*/
@property (nonatomic, strong) UIImageView *headerView;

@end

@implementation UserViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[UserInfoManager getUserID] isEqual:@" "]) {
        _nameLabel.text = [UserInfoManager getUserName];
        // 获取图片路径的最后一个字符
        NSString *w = [[UserInfoManager getUserIcon] substringFromIndex:[[UserInfoManager getUserIcon] length] - 1];
        // 判断
        if ([w isEqualToString:@"w"]) {
            [_headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",[UserInfoManager getUserIcon]]] placeholderImage:[UIImage imageNamed:@"pheader"]];
        } else {
            [_headerView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager getUserIcon]] placeholderImage:[UIImage imageNamed:@"pheader"]];
        }
    } else {
        _nameLabel.text = @"登录";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.tableHeaderView = [self headerView];
    [self.view addSubview:self.tableView];
    
    _icoArray = [[NSArray alloc] initWithObjects:@[@"xx"],@[@"gz",@"sc"],@[@"sz"], nil];
    _titleArray = [[NSArray alloc] initWithObjects:@[@"我的消息"],@[@"我的关注",@"我的收藏"],@[@"设置"], nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _icoArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_icoArray[section] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuse";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.imageView.image = [UIImage imageNamed:_icoArray[indexPath.section][indexPath.row]];
//    NSLog(@"%@",[NSValue valueWithCGRect:cell.imageView.frame]);
    cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/**创建头视图*/
-(UIView *)headerView{
    // 创建头视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight / 3)];
    view.backgroundColor = [UIColor colorWithHue:225/255.0 saturation:133/255.0 brightness:213/255.0 alpha:255/255.0];
    
    //头像视图
    _headerView = [[UIImageView alloc] init];
    _headerView.frame = CGRectMake(view.frame.size.width / 2 - 50, view.frame.size.height / 2 - 40, 100, 100);
    _headerView.layer.cornerRadius= 50;
    _headerView.layer.masksToBounds = YES;// 
    _headerView.userInteractionEnabled = YES;// 打开用户交互
    _headerView.backgroundColor = [UIColor grayColor];
    // 给头像添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_headerView addGestureRecognizer:tap];
    
    // 昵称Lable
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2 - 100, view.frame.size.height / 2 + 70, 200, 20)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_nameLabel];
    [view addSubview:_headerView];
    return view;
}

// 手势方法
-(void) tapAction:(UITapGestureRecognizer *)tap{
    if (![[UserInfoManager getUserID] isEqual:@" "]) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"确定取消登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 取消用户ID和用户
            [UserInfoManager cancelUserID];
            
            _nameLabel.text = @"登录";
            _headerView.image = nil;
            
        }];
        
        [alter addAction:cancel];
        [alter addAction:sure];
        
        [self presentViewController:alter animated:YES completion:nil];
        
        return;
    }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:naVC animated:YES completion:nil];
}


#pragma mark - tableView代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            MessageViewController *messVC = [[MessageViewController alloc] init];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:messVC];
            [naVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            [self presentViewController:naVC animated:YES completion:nil];
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                AttentionViewController *attentionVC = [[AttentionViewController alloc] init];
                UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:attentionVC];
                [naVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [self presentViewController:naVC animated:YES completion:nil];
            } else {
                CollectViewController *collectVC = [[CollectViewController alloc] init];
                UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:collectVC];
                [naVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [self presentViewController:naVC animated:YES completion:nil];
            }
        }
            break;
        case 2:
        {
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:settingVC];
            [naVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            [self presentViewController:naVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
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
