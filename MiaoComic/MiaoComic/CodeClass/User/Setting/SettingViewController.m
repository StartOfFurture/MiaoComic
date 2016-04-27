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
#import "AboutMeViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

/**列表视图*/
@property (nonatomic, strong) UITableView *tableView;

/**数据数组*/
@property (nonatomic, strong) NSArray *nameArray;

/**缓存数据*/
@property (nonatomic, assign) unsigned long long size;

/**清理缓存label*/
@property (nonatomic, strong) UILabel *cacheLabel;

@property (nonatomic, assign) unsigned long long zSize;

@end

@implementation SettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 计算缓存文件大小
    NSString *cachesfile = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.size = [self fileSizeForDir:cachesfile];
    NSLog(@"size is %llu",self.size);
    
    
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
    
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 2)) {
        cell.accessoryType = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        UILabel *cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 15, 50, 20)];
        cacheLabel.textColor = [UIColor lightGrayColor];
//        cacheLabel.backgroundColor = [UIColor redColor];
        cacheLabel.text = [NSString stringWithFormat:@"%lluM",self.size];
        self.cacheLabel = cacheLabel;
        [cell addSubview:cacheLabel];
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

                UILabel *hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 25, ScreenHeight - 100, 50, 20)];
                hudLabel.text = @"清理完成";
                hudLabel.font = [UIFont systemFontOfSize:12];
                hudLabel.layer.cornerRadius = 5;
                hudLabel.layer.masksToBounds = YES;
                hudLabel.backgroundColor = [UIColor grayColor];
                
                // 清理缓存
                [self deleteFile];
                
                [UIView animateWithDuration:2 animations:^{
                    hudLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    _cacheLabel.text = @"0M";
                }];
                [self.view addSubview:hudLabel];
            } else if (indexPath.row == 1){
                UILabel *hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 25, ScreenHeight - 100, 50, 20)];
                hudLabel.text = @"已是最新";
                hudLabel.font = [UIFont systemFontOfSize:12];
                hudLabel.layer.cornerRadius = 5;
                hudLabel.layer.masksToBounds = YES;
                hudLabel.backgroundColor = [UIColor grayColor];
                
                [UIView animateWithDuration:2 animations:^{
                    hudLabel.alpha = 0.0;
                }];
                [self.view addSubview:hudLabel];
                NSLog(@"版本更新");
            } else {
                AboutMeViewController *aboutMeVC = [[AboutMeViewController alloc] init];
                UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:aboutMeVC];
                [self presentViewController:naVC animated:YES completion:nil];
                NSLog(@"关于喵");
            }
        }
            break;
            case 2:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 100, ScreenHeight / 2 - 100, 200, 200)];
            imageView.image = [UIImage imageNamed:@"dianzan"];
            [UIView animateWithDuration:3 animations:^{
                imageView.alpha = 0.0;
            }];
            [self.view addSubview:imageView];
            NSLog(@"好评");
        }
            break;
        default:
            break;
    }
}

// 计算整个文件夹所有文件大小
-(long)fileSizeForDir:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    unsigned long long size = 0;
    
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if (!([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    _zSize += size;
    return _zSize / (1024.0 * 1024.0);
}

// 清理缓存
-(void)deleteFile{
    NSString *CachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSPath = [CachesPath stringByAppendingPathComponent:@"default"];
    BOOL isSuccess = [fileManager removeItemAtPath:iOSPath error:nil];
    if (isSuccess) {
        NSLog(@"delete success");
    }else{
        NSLog(@"delete fail");
    }
}

@end
