//
//  ClassifyListTableViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ClassifyListTableViewController.h"
#import "ClassifyListModel.h"
#import "ClassifyListModelCell.h"
#import "ClassifyListModelCellChange.h"
#import "LoginViewController.h"
#import "CompleteViewController.h"
#import "LoadingView.h"

@interface ClassifyListTableViewController ()

@property (nonatomic, strong)NSMutableArray *listArr;//列表数组
//@property (nonatomic, strong)UIButton *button;

@property (nonatomic, assign)NSInteger startCount;//开始请求

@property (nonatomic, strong)LoadingView *loadingView;//正在加载的View

@end

@implementation ClassifyListTableViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestData];
}
 
//数据请求
- (void)requestData{
    if (self.listArr.count != 0 && self.startCount == 0) {
        [self.listArr removeAllObjects];
    }
    NSString *str = [NSString stringWithFormat:Discover_CLASSIFYLIST,@"20",[NSString stringWithFormat:@"%ld",(long)self.startCount],self.titleStr];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetWorkRequestManager requestWithType:GET urlString:str dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
        NSArray *array = dic[@"data"][@"topics"];
        for (NSDictionary *dic1 in array) {
            ClassifyListModel *model = [[ClassifyListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            model.nickname = dic1[@"user"][@"nickname"];
            [self.listArr addObject:model];
        }
//        NSLog(@"%@",self.listArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingView removeFromSuperview];
//            self.tableView.scrollEnabled = YES;
            //让他在第一次数据请求之后只执行一次
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    self.startCount += 20;
                    [self requestData];
                }];
            });
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (self.listArr.count < (self.startCount + 20)) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        });
    } errorMessage:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingView removeFromSuperview];
            _loadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
            [_loadingView createAnimationWithCountImage:20 nameImage:@"630f0cdb690cf448f97a0126dfadf414－%d（被拖移）.tiff" timeInter:2 labelText:@"哎呀！网络出问题了？"];
            [self.view addSubview:_loadingView];
        });
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
            [self requestData];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//列表数组懒加载
- (NSMutableArray *)listArr{
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航标题的显示
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.titleStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.attributedText = str;
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //设置从那里开始请求
    self.startCount = 0;

    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.tableView.contentOffset.y >= 0) {
            self.startCount = 0;
            [self requestData];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
    
    _loadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
    [_loadingView createAnimationWithCountImage:4 nameImage:@"6bed450854904c8dd50d5b2553f62cf5－%d（被拖移）.tiff" timeInter:0.5 labelText:@"正在加载中~~~"];
//    self.tableView.scrollEnabled = NO;
    [self.view addSubview:_loadingView];
    
    // Do any additional setup after loading the view.
}

//返回按钮
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---tableView协议实现---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyListModel *model = self.listArr[indexPath.row];
    BaseTableViewCell *cell = nil;
//    NSLog(@"%@",model.is_favourite);
    if ([[UserInfoManager getUserID] isEqual:@" "]) {
        cell = (ClassifyListModelCell *)[self createWithTableView:tableView identifier:@"ClassifyListModelCell" cell:cell];
//        __block ClassifyListTableViewController *contrllerVC = self;
//        _button = (UIButton *)[cell viewWithTag:101];
//        _button.block = (id)^(id button){
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            [contrllerVC presentViewController:loginVC animated:YES completion:nil];
//            return nil;
//        };
        UIButton *button = (UIButton *)[cell viewWithTag:101];
        button.block = (id)^(id button){
              LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
              [self presentViewController:naVC animated:YES completion:nil];
                return nil;
         };
        
    }else{
        if ([[NSString stringWithFormat:@"%@",model.is_favourite] isEqualToString:@"1"]) {
            cell = [self createWithTableView:tableView identifier:@"ClassifyListModelCellChange" cell:cell];
        }else{
            cell = [self createWithTableView:tableView identifier:@"ClassifyListModelCell" cell:cell];
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

- (BaseTableViewCell *)createWithTableView:(UITableView *)tableView identifier:(NSString *)identifier cell:(BaseTableViewCell *)cell{
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyListModel *model = self.listArr[indexPath.row];
    CompleteViewController *compleVC = [[CompleteViewController alloc] init];
    compleVC.ids = model.ID;
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:compleVC];
    [self presentViewController:naVC animated:YES completion:nil];
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
