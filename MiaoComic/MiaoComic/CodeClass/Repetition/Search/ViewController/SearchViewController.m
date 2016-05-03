//
//  SearchViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchModelCell.h"
#import "SearchModelCellChange.h"
#import "SearchModel.h"
#import "LoginViewController.h"
#import "DiscoveryViewController.h"
#import "ClassifyListModel.h"
#import "CompleteViewController.h"

@interface SearchViewController ()<UISearchResultsUpdating,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UISearchController *searchController;
@property (strong, nonatomic)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation SearchViewController

//数组懒加载
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

//请求数据
- (void)requestData:(NSString *)str1{
    if (self.dataArr.count != 0) {
        [self.dataArr removeAllObjects];
    }
    NSString *str = [NSString stringWithFormat:SEARCH_url,str1];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetWorkRequestManager requestWithType:GET urlString:str dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSArray *array = dic[@"data"][@"topics"];
        for (NSDictionary *dic1 in array) {
            SearchModel *model = [[SearchModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            model.nickname = dic1[@"user"][@"nickname"];
            [self.dataArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//关注请求
- (void)requestFAV:(NSString *)ID{
    [NetWorkRequestManager requestWithType:POST urlString:[NSString stringWithFormat:Discover_fav,ID] dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"message"] isEqualToString:@"OK"]) {
            NSLog(@"成功关注");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestData:[self.searchController.searchBar text]];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    [self requestData:[self.searchController.searchBar text]];
    NSLog(@"zhuzhzuzhuz");
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.view.backgroundColor = [UIColor whiteColor];
    //手势的添加
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
//    [self.view addGestureRecognizer:tap];
    //表视图的显示
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
//    searchResultsController参数设置为nil,能在相同的视图中显示搜索结果
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 0, ScreenWidth, 40);
    //设置代理 搜索数据更新
    self.searchController.searchResultsUpdater = self;
    //遮盖层
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //当点击输入框的时候导航视图控制器的显隐问题
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //弹出键盘的样式
    self.searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
    //输入框的占位符
    self.searchController.searchBar.placeholder = @"搜索作品名、作者名";
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1.0];
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1.0];
    //设置搜索框加到哪个视图控制器上面，很重要!!!!!!!!!!!!如果是模态出来的要加，是push出来的不用加
//    self.definesPresentationContext = YES;
    //搜索框一进去就是第一响应者
    self.searchController.searchBar.text = @"";
    //按钮
    self.searchController.searchBar.showsBookmarkButton = YES;
    
    
    self.navigationItem.titleView = self.searchController.searchBar;
    
    // Do any additional setup after loading the view.
}

//手势方法的实现
//- (void)back{
//    if (self.dataArr.count == 0) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        self.tableView.userInteractionEnabled = YES;
//    }
//}

#pragma mark-------SearchViewController协议方法-------------

//必须实现的方法
//使用UISearchResultsUpdating协议更新搜索结果根据用户输入的信息搜索栏。
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //把SearchBar上面的Cancel按钮改成中文
    searchController.searchBar.showsCancelButton = YES;
    UIButton *cancelButton = [[UIButton alloc] init];
    UIView *topView = self.searchController.searchBar.subviews[0];
    NSLog(@"%@", topView);
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            NSDictionary* TextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]};
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"取消" attributes:TextAttributes];
            cancelButton.titleLabel.attributedText = str;
            cancelButton.tintColor = [UIColor blackColor];
            cancelButton.block = (id)^(id button){
//                [self dismissViewControllerAnimated:YES completion:nil];
                NSArray *array = self.navigationController.childViewControllers;
                UIViewController *viewVC = nil;
                NSLog(@"%@",array);
                for (UIViewController *viewVC1 in array) {
                    if ([viewVC1 isKindOfClass:[NSClassFromString(self.ControllerWithstring) class]]) {
                        viewVC = viewVC1;
                    }
                }
                [self.navigationController popToViewController:viewVC animated:YES];
                return nil;
            };
        }
    }
    [self requestData:[self.searchController.searchBar text]];
}

#pragma mark ---tableView的协议---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchModel *model = self.dataArr[indexPath.row];
    BaseTableViewCell *cell = nil;
    //    NSLog(@"%@",model.is_favourite);
    if ([[UserInfoManager getUserID] isEqual:@" "]) {
        cell = (SearchModelCell *)[self createWithTableView:tableView identifier:@"SearchModelCell" cell:cell];
        UIButton *button = (UIButton *)[cell viewWithTag:101];
        button.block = (id)^(id button){
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [[self topViewController] presentViewController:naVC animated:YES completion:nil];
            return nil;
        };
        
    }else{
        if ([[NSString stringWithFormat:@"%@",model.is_favourite] isEqualToString:@"1"]) {
            cell = [self createWithTableView:tableView identifier:@"SearchModelCellChange" cell:cell];
        }else{
            cell = [self createWithTableView:tableView identifier:@"SearchModelCell" cell:cell];
            UIButton *button = (UIButton *)[cell viewWithTag:101];
            button.block = (id)^(id button){
                [self requestFAV:model.ID];
                return nil;
            };
        }
    }
    [cell setDataWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyListModel *model = self.dataArr[indexPath.row];
    CompleteViewController *compleVC = [[CompleteViewController alloc] init];
    compleVC.ids = model.ID;
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:compleVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

- (BaseTableViewCell *)createWithTableView:(UITableView *)tableView identifier:(NSString *)identifier cell:(BaseTableViewCell *)cell{
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    return cell;
}


//模态，判断是哪个视图控制器推出来的
- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:self.searchController];
    //return [self topViewControllerWithRootViewController:self.window.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
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
