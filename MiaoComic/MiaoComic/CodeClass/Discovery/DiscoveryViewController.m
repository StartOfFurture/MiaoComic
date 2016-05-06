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
#import "DiscoveryHotPaiHangCell.h"
#import "DiscoveryXinZuoCell.h"
#import "DiscoveryHotGuanFangCell.h"
#import "HotPaiHangViewController.h"
#import "CommentViewController.h"
#import "DetailsViewController.h"
#import "CompleteViewController.h"
#import "LoadingView.h"


@interface DiscoveryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate,DiscoveryHotPaiHangCellDelegate>

@property (nonatomic, strong)UITableView *hotTableView;//热门视图
@property (nonatomic, strong)NSMutableArray *hotBannerArr;//热门轮播数组
@property (nonatomic, strong)CycleScrollView *headerScrollView;//头视图
@property (nonatomic, strong)NSMutableDictionary *hotListDic;//热门列表字典
@property (nonatomic, strong)NSMutableArray  *hotListArr;//热门列表的分组数组
@property (nonatomic, assign)BOOL isNew;//判断是否可以刷新

@property (nonatomic, strong)UICollectionView *collectionView;//分类视图
@property (nonatomic, strong)NSMutableArray *collectionArray;//分类数组

@property (nonatomic, strong)LoadingView *hotLoadingView;//热门的加载视图
@property (nonatomic, strong)LoadingView *collectionLoadingView;//分类的加载视图


@end

@implementation DiscoveryViewController

//视图即将显示
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏的颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = NO;
    _hotLoadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
    [_hotLoadingView createAnimationWithCountImage:4 nameImage:@"6bed450854904c8dd50d5b2553f62cf5－%d（被拖移）.tiff" timeInter:0.5 labelText:@"正在加载中～～～"];
    [self.hotTableView addSubview:_hotLoadingView];
    
    _collectionLoadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
    [_collectionLoadingView createAnimationWithCountImage:4 nameImage:@"6bed450854904c8dd50d5b2553f62cf5－%d（被拖移）.tiff" timeInter:0.5 labelText:@"正在加载中～～～"];
    [self.collectionView addSubview:_collectionLoadingView];
    //数据分类请求
    [self requestData];
    //热门数据
    [self requestHotData];
}

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
            [_collectionLoadingView removeFromSuperview];
            [_collectionView reloadData];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionLoadingView removeFromSuperview];
            _collectionLoadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
            [_collectionLoadingView createAnimationWithCountImage:20 nameImage:@"630f0cdb690cf448f97a0126dfadf414－%d（被拖移）.tiff" timeInter:2 labelText:@"哎呀！网络出问题了？"];
            [self.collectionView addSubview:_collectionLoadingView];
        });
    }];
}

//请求热门数据
- (void)requestHotData{
    [self.hotBannerArr removeAllObjects];
    [self.hotListArr removeAllObjects];
    
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
            [_hotLoadingView removeFromSuperview];
            [self createHotBannerView];
            [_hotTableView.mj_header endRefreshing];
        });
    } errorMessage:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hotLoadingView removeFromSuperview];
            _hotLoadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
            [_hotLoadingView createAnimationWithCountImage:20 nameImage:@"630f0cdb690cf448f97a0126dfadf414－%d（被拖移）.tiff" timeInter:2 labelText:@"哎呀！网络出问题了？"];
            [self.hotTableView addSubview:_hotLoadingView];
        });
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

#warning 测试评论
    UIButton *button11 = [UIButton buttonWithType:UIButtonTypeSystem];
    button11.frame = CGRectMake(0, 0, 50, 20);
    [button11 setTitle:@"评论" forState:UIControlStateNormal];
    button11.block = (id)^(id button1){
        CommentViewController *commVC = [[CommentViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:commVC];
        [self presentViewController:naVC animated:YES completion:nil];
        return nil;
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button11];
    
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
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.ControllerWithstring = @"DiscoveryViewController";
        searchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
        return nil;
    };
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //页面搭建
    //热门
    _isNew = NO;
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _hotTableView.backgroundColor = [UIColor whiteColor];
    _headerScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 2 / 3) animationDuration:2];
    _hotTableView.tableHeaderView = _headerScrollView;
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    //cell之间的分割线去掉
    _hotTableView.separatorStyle = NO;
    //注册
    [_hotTableView registerClass:[DiscoveryHotRenQiCell class] forCellReuseIdentifier:@"renqi"];
    [_hotTableView registerClass:[DiscoveryHotPaiHangCell class] forCellReuseIdentifier:@"paihang"];
    [_hotTableView registerClass:[DiscoveryXinZuoCell class] forCellReuseIdentifier:@"xinzuo"];
    [_hotTableView registerClass:[DiscoveryHotRenQiCell class] forCellReuseIdentifier:@"zhubian"];
    [_hotTableView registerClass:[DiscoveryHotGuanFangCell class] forCellReuseIdentifier:@"guangfang"];
    _hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_hotTableView.contentOffset.y >= 0 && _isNew) {
            [self requestHotData];
        }else{
            [_hotTableView.mj_header endRefreshing];
        }
    }];
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
    
    //添加观察者
    [self addObserver];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- ---添加观察者---

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renqi:) name:@"push" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guanfang:) name:@"guanfang" object:nil];
}

- (void)renqi:(NSNotification *)no{
    CompleteViewController *compleVC = [[CompleteViewController alloc] init];
    compleVC.ids = (NSString *)no.object;
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:compleVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)guanfang:(NSNotification *)no{
    DetailsViewController *DetailVC = [[DetailsViewController alloc] init];
    DetailVC.cid = (NSString *)no.object;
    DetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DetailVC animated:YES];
}

#pragma mark- ---jump协议---

- (void)jump{
    HotPaiHangViewController *hotPaiHangVC = [[HotPaiHangViewController alloc] init];
//    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:hotPaiHangVC];
//    [self presentViewController:naVC animated:YES completion:nil];
    [self.navigationController pushViewController:hotPaiHangVC animated:YES];
}

#pragma mark- ---UITableView的实现---

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
        _isNew = YES;
        return picArray[page];
    };
    __block DiscoveryViewController *discVC = self;
    _headerScrollView.TapActionBlock = ^(NSInteger page){
        DiscoveryHoTBannerModel *model = discVC.hotBannerArr[page];
        NSLog(@"%@",model.value);
        if (model.value.length == 3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:model.value];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guanfang" object:model.value];
        }
    };
}

//协议的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hotListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *title = self.hotListArr[section];
    if ([title isEqualToString:@"人气飙升"] || [title isEqualToString:@"每周排行榜"] || [title isEqualToString:@"主编力推"]|| [title isEqualToString:@"官方活动"]) {
        return 1;
    }else{
        return [self.hotListDic[title] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.hotListArr[indexPath.section];
    BaseTableViewCell *cell = nil;
    DiscoveryHotListModel *model = self.hotListDic[title][indexPath.row];
    if ([title isEqualToString:@"人气飙升"] || [title isEqualToString:@"主编力推"]) {
        if ([title isEqualToString:@"人气飙升"]) {
            static NSString *renqiStr = @"renqi";
            cell = (DiscoveryHotRenQiCell *)[tableView dequeueReusableCellWithIdentifier:renqiStr];
            ((DiscoveryHotRenQiCell *)cell).array = self.hotListDic[title];
            ((DiscoveryHotRenQiCell *)cell).identent = @"renqi";
        }else{
            static NSString *zhubianStr = @"zhubian";
            cell = (DiscoveryHotRenQiCell *)[tableView dequeueReusableCellWithIdentifier:zhubianStr];
            ((DiscoveryHotRenQiCell *)cell).zhubianArray = self.hotListDic[title];
            ((DiscoveryHotRenQiCell *)cell).identent = @"zhubian";
        }
        NSLog(@"%@",((DiscoveryHotRenQiCell *)cell).array);
    }else if ([title isEqualToString:@"每周排行榜"]){
        static NSString *renqiStr = @"paihang";
        cell = (DiscoveryHotPaiHangCell *)[tableView dequeueReusableCellWithIdentifier:renqiStr];
        ((DiscoveryHotPaiHangCell *)cell).array = self.hotListDic[title];
        ((DiscoveryHotPaiHangCell *)cell).delegate = self;
    }else if ([title isEqualToString:@"新作出炉"]){
        static NSString *xinzuoStr = @"xinzuo";
        cell = (DiscoveryXinZuoCell *)[tableView dequeueReusableCellWithIdentifier:xinzuoStr];
        [cell setDataWithModel:model];
    }else{
        static NSString *guangfangStr = @"guangfang";
        cell = (DiscoveryHotGuanFangCell *)[tableView dequeueReusableCellWithIdentifier:guangfangStr];
        ((DiscoveryHotGuanFangCell *)cell).array = self.hotListDic[title];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    DiscoveryHotListModel *model = self.hotListDic[self.hotListArr[indexPath.section]][indexPath.row];
    if ([self.hotListArr[indexPath.section] isEqualToString:@"人气飙升"]) {
        return ((ScreenWidth - 24)/3) * 1.26 ;
    }else if ([self.hotListArr[indexPath.section] isEqualToString:@"每周排行榜"]){
        return (ScreenWidth - 30) / 4 * 3;
    }else if ([self.hotListArr[indexPath.section] isEqualToString:@"新作出炉"]){
        return 10 * (ScreenWidth - 16) / 17;
    }else if ([self.hotListArr[indexPath.section] isEqualToString:@"主编力推"]){
        return ((ScreenWidth - 24)/3) * 1.26 * 2 + 6;
    }
    return (ScreenWidth - 24)/2 * 11 / 13 - 30;
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
    DiscoveryHotListModel *model = self.hotListDic[self.hotListArr[indexPath.section]][indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:model.ID];
}

#pragma mark- ---UICollectionView协议实现---

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

#pragma mark- ---分段控件的点击事件---

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
