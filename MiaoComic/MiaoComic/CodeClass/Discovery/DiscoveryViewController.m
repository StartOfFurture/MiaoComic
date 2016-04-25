//
//  DiscoveryViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "ClassifyModel.h"
#import "ClasslfyModelCell.h"
#import "ClassifyListTableViewController.h"
#import "DiscoveryHoTBannerModel.h"
#import "CycleScrollView.h"
#import "DiscoveryHotListModel.h"
#import "DiscoveryHotSecondView.h"
#import "DiscoveryHotRenQiCell.h"
#import "SearchViewController.h"

@interface DiscoveryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *hotTableView;//热门视图
@property (nonatomic, strong)NSMutableArray *hotBannerArr;//热门轮播数组
@property (nonatomic, strong)CycleScrollView *headerScrollView;//头视图
@property (nonatomic, strong)NSMutableDictionary *hotListDic;//热门列表字典
@property (nonatomic, strong)NSMutableArray  *hotListArr;//热门列表的分组数组

@property (nonatomic, strong)UICollectionView *collectionView;//分类视图
@property (nonatomic, strong)NSMutableArray *collectionArray;//分类数组

@end

@implementation DiscoveryViewController

//热门列表的分组数组的懒加载
- (NSMutableArray *)hotListArr{
    if (_hotListArr == nil) {
        _hotListArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hotListArr;
}

//热门列表字典的懒加载
- (NSMutableDictionary *)hotListDic{
    if (_hotListDic == nil) {
        _hotListDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _hotListDic;
}

//热门轮播数组的懒加载
- (NSMutableArray *)hotBannerArr{
    if (_hotBannerArr == nil) {
        _hotBannerArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hotBannerArr;
}

//分类数组的懒加载
- (NSMutableArray *)collectionArray{
    if (_collectionArray == nil) {
        _collectionArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _collectionArray;
}

//请求分类数据
- (void)requestData{
    [NetWorkRequestManager requestWithType:GET urlString:Discovery_CLASSIFY dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSArray *array = dic[@"data"][@"suggestion"];
        for (NSDictionary *dic1 in array) {
            ClassifyModel *classifyModel = [[ClassifyModel alloc] init];
            [classifyModel setValuesForKeysWithDictionary:dic1];
            [self.collectionArray addObject:classifyModel];
        }
        NSLog(@"%@",self.collectionArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//请求热门数据
- (void)requestHotData{
    //轮播请求
    [NetWorkRequestManager requestWithType:GET urlString:Discover_Hot_banner dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
        NSArray *array = dic[@"data"][@"banner_group"];
        for (NSDictionary *dic1 in array) {
            DiscoveryHoTBannerModel *model = [[DiscoveryHoTBannerModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            [self.hotBannerArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createHotBannerView];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"1%@",error);
    }];
    //列表请求
    [NetWorkRequestManager requestWithType:GET urlString:Discover_Hot_topic_lists dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
        NSArray *array = dic[@"data"][@"infos"];
        for (NSDictionary *dic1 in array) {
            NSMutableArray *listArr = [[NSMutableArray alloc] initWithCapacity:0];
            if ([dic1[@"title"] isEqualToString:@"官方活动"]) {
                NSArray *arr = dic1[@"banners"];
                for (NSDictionary *dic2 in arr) {
                    DiscoveryHotListModel *model = [[DiscoveryHotListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic2];
                    model.ID = @"";
                    model.GroupTitle = dic1[@"title"];
                    [listArr addObject:model];
                }
            }else{
                NSArray *arr = dic1[@"topics"];
                for (NSDictionary *dic2 in arr) {
                    DiscoveryHotListModel *model = [[DiscoveryHotListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic2];
                    model.nickname = dic2[@"user"][@"nickname"];
                    model.GroupTitle = dic1[@"title"];
                    [listArr addObject:model];
                }
            }
            [self.hotListArr addObject:dic1[@"title"]];
            [self.hotListDic setObject:listArr forKey:dic1[@"title"]];
        }
        NSLog(@"%@",self.hotListDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hotTableView reloadData];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"2%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据分类请求
    [self requestData];
    //热门数据
    [self requestHotData];
    
    //导航栏的颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //热门、分类标题的显示
    UISegmentedControl *segVC = [[UISegmentedControl alloc] initWithItems:@[@"热门",@"分类"]];
    //这个时候什么搜不会显示
    segVC.tintColor = [UIColor clearColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1.0]};
    [segVC setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]};
    
    [segVC setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    segVC.selectedSegmentIndex = 0;
    [segVC addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segVC;

    //搜索按钮的添加
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed:@"search_change"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 20, 20);
    button.block = (id)^(id but){
//        NSLog(@"搜索搜索");
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:searchVC];
//        searchVC.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
//        naVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//        [self.view addSubview:naVC.view];
        [self presentViewController:naVC animated:YES completion:nil];
        return nil;
    };
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //页面搭建
    //热门
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _hotTableView.backgroundColor = [UIColor whiteColor];
    _headerScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 230) animationDuration:2];
    _hotTableView.tableHeaderView = _headerScrollView;
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    //cell之间的分割线去掉
    _hotTableView.separatorStyle = NO;
    //注册
    [_hotTableView registerClass:[DiscoveryHotRenQiCell class] forCellReuseIdentifier:@"renqi"];
    [self.view addSubview:_hotTableView];
    
    //分类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth - 60)/3, (ScreenWidth - 60)/3 + 20);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ScreenWidth, 64, ScreenWidth, ScreenHeight - 64 - 44) collectionViewLayout:layout];
//    _collectionView.backgroundColor = [UIColor orangeColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView  registerNib:[UINib nibWithNibName:@"ClassifyModelCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ClassifyModel"];
    [self.view addSubview:_collectionView];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ---UITableView的实现---

//创建头视图的轮播图
- (void)createHotBannerView{
    NSMutableArray *picArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (DiscoveryHoTBannerModel *model in self.hotBannerArr) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerScrollView.frame.size.width, _headerScrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
        [picArray addObject:imageView];
    }
    _headerScrollView.totalPagesCount = picArray.count;
    _headerScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger page){
        return picArray[page];
    };
}

//协议的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hotListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *title = self.hotListArr[section];
    if ([title isEqualToString:@"人气飙升"]) {
        return 1;
    }else{
        return [self.hotListDic[title] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.hotListArr[indexPath.section];
    BaseTableViewCell *cell = nil;
    if ([title isEqualToString:@"人气飙升"]) {
        static NSString *renqiStr = @"renqi";
       cell = (DiscoveryHotRenQiCell *)[tableView dequeueReusableCellWithIdentifier:renqiStr];
        ((DiscoveryHotRenQiCell *)cell).array = self.hotListDic[title];
        NSLog(@"%@",((DiscoveryHotRenQiCell *)cell).array);
    }else{
        DiscoveryHotListModel *model = self.hotListDic[title][indexPath.row];
        static NSString *str = @"lala";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        if (model.title == nil) {
            cell.textLabel.text = model.target_title;
        }else{
            cell.textLabel.text = model.title;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.hotListArr[indexPath.section] isEqualToString:@"人气飙升"]) {
        return 130;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DiscoveryHotSecondView *view = [[NSBundle mainBundle] loadNibNamed:@"DiscoveryHotSecondView" owner:nil options:nil][0];
//    view.frame = CGRectMake(0, 0, ScreenWidth, 50);
//    view.backgroundColor = [UIColor whiteColor];
    [view setDataModel:self.hotListArr[section]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"lolo");
}

#pragma mark ---UICollectionView协议实现---

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyModel *model = self.collectionArray[indexPath.row];
//    NSLog(@"%@",model.icon);
    return [FactoryCollectionViewCell creatCollectionViewCell:model andCollectionView:collectionView indexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        ClassifyModel *model = self.collectionArray[indexPath.row];
        ClassifyListTableViewController *classifyTable = [[ClassifyListTableViewController alloc] init];
        classifyTable.titleStr = model.title;
        self.navigationItem.title = @"";
        //    [self.navigationController pushViewController:classifyTable animated:YES];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:classifyTable];
        naVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:naVC animated:YES completion:nil];
}

#pragma mark ---分段控件的点击事件---

- (void)segClick:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.hotTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            self.collectionView.frame = CGRectMake(ScreenWidth, 64, ScreenWidth, ScreenHeight - 64 - 44);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.hotTableView.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
            self.collectionView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 44);
        }];
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
