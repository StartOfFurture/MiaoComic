//
//  HomeViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "HomeViewController.h"
#import "UIButton+FinishClick.h"
#import "ComicsModel.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *comicsTableView;// 更新TableView
@property (nonatomic, strong) UITableView *comicsTableView_switchover;// 更新TableView的替换表视图
@property (nonatomic, strong) NSMutableArray *comicsArray;// 更新请求的数据漫画数组
@property (nonatomic, strong) UIScrollView *headView;// 更新的头视图
@property (nonatomic, strong) UIButton *selectButton;// 更新的标记已经选择按钮
@property (nonatomic, strong) UIButton *comicsBtn;// 导航栏上的更新按钮
@property (nonatomic, copy) NSString *urlString;// 更新中刷新数据时，传给刷新方法的参数

@property (nonatomic, strong) UITableView *attentionTableView;// 关注TableView
@property (nonatomic, strong) NSMutableArray *attentionArray;// 关注请求的数据漫画数组
@property (nonatomic, strong) NSMutableDictionary *attentionDic;// 关注请求的数据漫画字典
@property (nonatomic, strong) UIButton *attentionBtn;// 导航栏上的关注按钮
@property (nonatomic, copy) NSString *attentionUrl;// 关注的url参数

@property (nonatomic, strong) UIButton *navSelectBtn;// 导航栏上被选中的按钮

@end

@implementation HomeViewController


#pragma mark - 懒加载 -

- (NSMutableArray *)comicsArray {
    if (_comicsArray == nil) {
        self.comicsArray = [NSMutableArray array];
    }
    return _comicsArray;
}

- (NSMutableArray *)attentionArray {
    if (_attentionArray == nil) {
        self.attentionArray = [NSMutableArray array];
    }
    return _attentionArray;
}

- (NSMutableDictionary *)attentionDic {
    if (_attentionDic == nil) {
        self.attentionDic = [NSMutableDictionary dictionary];
    }
    return _attentionDic;
}


#pragma mark - 创建基础视图 -
- (void)createNavigationButton {
    // 设置导航栏的背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
    
    // 搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 20, 20);
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchBtn.block = ^(id button){
        NSLog(@"zhuhzhu");
        return button;
    };
    UIBarButtonItem *seachItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = seachItem;
    
    // 关注按钮
    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionBtn.frame = CGRectMake(0, 0, 50, 25);
    [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _attentionBtn.backgroundColor = [UIColor clearColor];
    _attentionBtn.layer.cornerRadius = 12;
    _attentionBtn.layer.masksToBounds = YES;
    _attentionBtn.layer.borderWidth = 0;
    
    // 关注的第一次数据请求
    [self requestDataForAttentionWithAttentionUrl:@"0"];

    __block UIButton *attentionBtn = _attentionBtn;
    attentionBtn.block = (id)^(id button){
        self.navSelectBtn = ((UIButton *)button);
        
//        // 请求数据
//        [self requestDataForAttentionWithAttentionUrl:_attentionUrl];
        
        // 改变两个按钮的颜色
        [_comicsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _comicsBtn.backgroundColor = [UIColor clearColor];
        [((UIButton *)button) setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
        ((UIButton *)button).backgroundColor = [UIColor whiteColor];
        
        // 切换tableView
        [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            //添加帧动画
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                _headView.frame = CGRectMake(ScreenWidth, 64, ScreenWidth, 30);
                self.comicsTableView.frame = CGRectMake(ScreenWidth, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
            }];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
                self.attentionTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49);
            }];
            
        } completion:^(BOOL finished) {
            NSLog(@"finished");
        }];
        
        return button;
    };
    
    // 更新按钮
    _comicsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _comicsBtn.frame = CGRectMake(50, 0, 50, 25);
    [_comicsBtn setTitle:@"更新" forState:UIControlStateNormal];
    _comicsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_comicsBtn setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
    _comicsBtn.backgroundColor = [UIColor whiteColor];
    _comicsBtn.layer.cornerRadius = 12;
    _comicsBtn.layer.masksToBounds = YES;
    _comicsBtn.layer.borderWidth = 0;
    
    __block UIButton *comicsBtn = _comicsBtn;
    comicsBtn.block = (id)^(id button){
        self.navSelectBtn = ((UIButton *)button);
        
        // 改变两个按钮的颜色
        [_attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _attentionBtn.backgroundColor = [UIColor clearColor];
        [((UIButton *)button) setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
        ((UIButton *)button).backgroundColor = [UIColor whiteColor];
        
        // 切换tableView
        [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            //添加帧动画
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                
                self.attentionTableView.frame = CGRectMake(-ScreenWidth, 64, ScreenWidth, ScreenHeight - 64 - 49);
            }];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
                _headView.frame = CGRectMake(0, 64, ScreenWidth, 30);
                self.comicsTableView.frame = CGRectMake(0, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
            }];
            
        } completion:^(BOOL finished) {
            NSLog(@"finished");
        }];
        
        //        [self.comicsTableView reloadData];
        return button;
    };
    
    // 记录 导航栏上被点击的按钮
    self.navSelectBtn = _comicsBtn;
    
    // 创建导航视图控制器的标题视图，并添加关注和更新按钮
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [titleView addSubview:_attentionBtn];
    [titleView addSubview:_comicsBtn];
    
    self.navigationItem.titleView = titleView;
}

- (void)createTableView {
    
    // 更新页面
    _comicsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49) style:UITableViewStylePlain];
    _comicsTableView.delegate = self;
    _comicsTableView.dataSource = self;
    _comicsTableView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [self.view addSubview:_comicsTableView];
    
    [self.comicsTableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComicsModel"];
    
    // 更新页面2
    _comicsTableView_switchover = [[UITableView alloc] initWithFrame:CGRectMake(- ScreenWidth, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49) style:UITableViewStylePlain];
    _comicsTableView_switchover.delegate = self;
    _comicsTableView_switchover.dataSource = self;
    _comicsTableView_switchover.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [self.view addSubview:_comicsTableView_switchover];
    
    [self.comicsTableView_switchover registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComicsModel"];
    
    // 关注页面
    _attentionTableView = [[UITableView alloc] initWithFrame:CGRectMake(- ScreenWidth, 64, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _attentionTableView.delegate = self;
    _attentionTableView.dataSource = self;
    _attentionTableView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [self.view addSubview:_attentionTableView];
    
    [self.attentionTableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComicsModel"];
}


#pragma mark - 创建头部日期滚动视图 -

- (void)createHeadView {
    _headView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 30)];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.contentSize = CGSizeMake(ScreenWidth / 6 * 7, 30);
    _headView.contentOffset = CGPointMake(ScreenWidth / 6, 0);
    _headView.bounces = NO;
    _headView.pagingEnabled = NO;
    _headView.showsHorizontalScrollIndicator = NO;
 
    for (int i = 0; i < 7; i ++) {
        CGFloat width = ScreenWidth / 6;
        
        // 日期按钮
        UIButton *weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weekBtn.frame = CGRectMake(i * width, 0, width, 30);
        weekBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [weekBtn setTitle:[self computeTimeWithIndex:i] forState:UIControlStateNormal];
        [weekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 标记视图
        UIView *markView = [[UIView alloc] initWithFrame:CGRectMake(width * 0.15, 25, width * 0.7, 5)];

        markView.backgroundColor = [UIColor clearColor];
        [weekBtn addSubview:markView];
        
        // 日期按钮的初始设置
        if (i == 6) {
            self.selectButton = weekBtn;
            [weekBtn setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
            [weekBtn.subviews lastObject].backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
        }
        
        // weekBtn按钮 回调
        weekBtn.block = (id)^(id button){
            UIButton *mybutton = (UIButton *)button;
            
            if (self.selectButton == mybutton) {
                return button;
            }
            
            // 置空数组
            self.comicsArray = nil;

            // 重置上一次选择的按钮的颜色
            [self.selectButton.subviews lastObject].backgroundColor = [UIColor clearColor];
            [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            // 设置本次选择的按钮的颜色
            [mybutton setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
            [mybutton.subviews lastObject].backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
            
            // 更新被选择的按钮
            self.selectButton = mybutton;
      
            // 计算时间
            NSDate *date = [GetTime getDate:[NSDate date] formatString:@"YYYY-MM-dd"];
//            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"YYYY-MM-dd"];
//            NSString *dataString = [formatter stringFromDate:[NSDate date]];
//            NSDate *date = [formatter dateFromString:dataString];
            _urlString = [NSString stringWithFormat:@"%.0f", [[NSDate dateWithTimeInterval:(i - 6) * 24 * 60 * 60  sinceDate:date] timeIntervalSince1970]];

            // 请求数据
            [self requestData:_urlString];
            
            return button;
        };
        
        [_headView addSubview:weekBtn];
    }
    
    [self.view addSubview:_headView];
}


#pragma mark - 更新时间的计算 -

- (NSString *)computeTimeWithIndex:(int)index {
    if (index == 6) {
        return @"今天";
    } else if (index == 5) {
        return @"昨天";
    }
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate dateWithTimeInterval:(index - 6) * 24 * 60 * 60 sinceDate:[NSDate date]]];
    return [weekdays objectAtIndex:theComponents.weekday];
}


#pragma mark - 更新的请求网络数据 -

- (void)requestData:(NSString *)dateString {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?since=0",HOME_NEW, dateString];
    NSLog(@"%@",urlString);
    [NetWorkRequestManager requestWithType:GET urlString:urlString dic:@{} successful:^(NSData *data) {
        NSDictionary *dateDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSArray *array = dateDic[@"data"][@"comics"];
        for (NSDictionary *mDic in array) {
            ComicsModel *comics = [[ComicsModel alloc] init];
            comics.authorUserInfo = [[AuthorUserInfo alloc] init];
            comics.topicModel = [[TopicModel alloc] init];
            
            [comics setValuesForKeysWithDictionary:mDic];
            [comics.topicModel setValuesForKeysWithDictionary:mDic[@"topic"]];
            [comics.authorUserInfo setValuesForKeysWithDictionary:mDic[@"topic"][@"user"]];
            
            [self.comicsArray addObject:comics];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

//            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//                self.comicsTableView.frame = CGRectMake(ScreenWidth / 0.5, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
//            } completion:^(BOOL finished) {
//                self.comicsTableView.frame = CGRectMake(0, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
//                [self.comicsTableView reloadData];
//            }];

            
//            [UIView animateKeyframesWithDuration:2.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//                //添加帧动画
//                [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
//                    self.comicsTableView.frame = CGRectMake(ScreenWidth / 0.5, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
//                }];
//                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
//                    self.comicsTableView_switchover.frame = CGRectMake(0, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
//                        [self.comicsTableView_switchover reloadData];
//                }];
//                
//            } completion:^(BOOL finished) {
//                NSLog(@"finished");
//            }];
 
            [self.comicsTableView reloadData];
            [self.comicsTableView.mj_header endRefreshing];
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - 关注的请求网络数据 -

- (void)requestDataForAttentionWithAttentionUrl:(NSString *)attentionUrl {
    NSString *urlString = [NSString stringWithFormat:@"%@?since=%@",HOME_ATTENTION, attentionUrl];
    
    [NetWorkRequestManager requestWithType:GET urlString:urlString dic:@{} successful:^(NSData *data) {
        NSDictionary *dateDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSArray *array = dateDic[@"data"][@"comics"];
        for (NSDictionary *mDic in array) {
            
            ComicsModel *comics = [[ComicsModel alloc] init];
            comics.authorUserInfo = [[AuthorUserInfo alloc] init];
            comics.topicModel = [[TopicModel alloc] init];
            
            [comics setValuesForKeysWithDictionary:mDic];
            [comics.topicModel setValuesForKeysWithDictionary:mDic[@"topic"]];
            [comics.authorUserInfo setValuesForKeysWithDictionary:mDic[@"topic"][@"user"]];

            // 分组名
            NSString *groupName = [GetTime getDayFromSecondString:mDic[@"created_at"]];
            NSMutableArray *mArr = [self.attentionDic valueForKey:groupName];
            if (mArr == nil) {
                mArr = [[NSMutableArray alloc] initWithCapacity:0];
                [mArr addObject:comics];
                [self.attentionDic setValue:mArr forKey:groupName];
                [self.attentionArray addObject:groupName];
                
            } else {
                [mArr addObject:comics];
            }
        }


        _attentionUrl = dateDic[@"data"][@"since"];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.attentionTableView reloadData];
            [self.attentionTableView.mj_header endRefreshing];
            [self.attentionTableView.mj_footer endRefreshing];
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}


#pragma mark -添加上拉加载和下拉刷新-

- (void)refresh{
    __weak HomeViewController *homeVC = self;
    // 更新列表添加下拉功能
    self.comicsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self.comicsArray = nil;// 置空数组
        [homeVC requestData:_urlString];
    }];
    
    // 关注列表添加下拉功能
    self.attentionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.attentionArray = nil;// 置空数组
        self.attentionDic = nil;
        [homeVC requestDataForAttentionWithAttentionUrl:@"0"];
    }];
    
    // 关注列表上拉功能
    self.attentionTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [homeVC requestDataForAttentionWithAttentionUrl:_attentionUrl];
    }];
}


#pragma mark - 创建轻扫手势 -

- (void)createSwipeGesture {
    //向右
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeGesture];
    
    //向左
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGestureLeft.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeGestureLeft];
}


#pragma mark - 轻扫手势 -

-(void)swipeGesture:(id)sender
{
    static int mark = 0;
    for (int i = 0; i < 7; i ++) {
        if (self.selectButton == (UIButton *)((_headView.subviews)[i])) {
            mark = i;
            break;
        }
    }
    
    UISwipeGestureRecognizer *swipe = sender;
    if(swipe.direction == UISwipeGestureRecognizerDirectionLeft)   {
        //向左轻扫，向后一天，+ 1
        if (mark < 6) {
            if (mark == 5) {
                [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _headView.contentOffset = CGPointMake(ScreenWidth / 6, 0);
                } completion:nil];
            }
            ((UIButton *)((_headView.subviews)[mark + 1])).block((UIButton *)((_headView.subviews)[mark + 1]));
        }
    } if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
        //向右轻扫，向前一天，- 1
        if (mark > 0) {
            if (mark == 1) {
                [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _headView.contentOffset = CGPointMake(0, 0);
                } completion:nil];
            }
            ((UIButton *)((_headView.subviews)[mark - 1])).block((UIButton *)((_headView.subviews)[mark - 1]));
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;// 去掉留白
    
    // 首次数据请求
    [self requestData:@"0"];
    _attentionUrl = @"0";
    
    // 创建基础视图
    [self createNavigationButton];
    [self createTableView];
    
    // 创建更新的头视图
    [self createHeadView];
    
    // 下拉刷新
    [self refresh];
    
    // 创建轻扫手势
    [self createSwipeGesture];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.navSelectBtn == self.comicsBtn) {
        return self.comicsArray.count + 1;
    } else {
        return self.attentionArray.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.navSelectBtn == self.comicsBtn) {
        return 1;
    } else {
        NSString *key = self.attentionArray[section];
        return [self.attentionDic[key] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == self.comicsArray.count && tableView == _comicsTableView) || (indexPath.section == self.attentionArray.count && tableView == _attentionTableView)) {// 最后一组的高度
        return 50;
    }
    return (ScreenWidth) * ((float)10 / 17) + 10 * 4 + 20 + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.comicsArray == nil){
        return nil;
    }
    
    // 最后一组，滑到底的时候
    if (indexPath.section == self.comicsArray.count) {
        BaseTableViewCell *cell = [[BaseTableViewCell alloc] init];
        cell.textLabel.text = @" 到底了哦，看看前一天的吧~";
        cell.imageView.image = [UIImage imageNamed:@"Logo_Miao"];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
//    if (indexPath.section == self.attentionArray.count && tableView == _attentionTableView) {
//        BaseTableViewCell *cell = [[BaseTableViewCell alloc] init];
//        cell.textLabel.text = @" 到底了哦，看看其他的吧~";
//        cell.imageView.image = [UIImage imageNamed:@"Logo_Miao"];
//        cell.backgroundColor = [UIColor clearColor];
//        return cell;
//    }
    
    ComicsModel *comics = nil;
     comics = _comicsArray[indexPath.section];
//    if (tableView == _comicsTableView) {
//        comics = _comicsArray[indexPath.section];
//    } else {
//        NSString *key = _attentionArray[indexPath.section];
//        comics = _attentionDic[key][indexPath.row];
//    }
    
    BaseTableViewCell *cell = [FactoryTableViewCell creatTableViewCell:comics tableView:tableView indexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.cornerRadius = 25;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    return cell;

}


#pragma mark - 设置组间距和颜色 -

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (tableView == _attentionTableView) {
//        return _attentionArray[section];
//    } else {
//        return nil;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _comicsTableView) {
        return 10;
    } else {
        return 20;
    }
//    return 10;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
