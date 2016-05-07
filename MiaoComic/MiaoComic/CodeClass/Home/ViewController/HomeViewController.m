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
#import "HomeCell.h"
#import "SearchViewController.h"
#import "AuthorViewController.h"
#import "CompleteViewController.h"
#import "DetailsViewController.h"
#import "LoginViewController.h"

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
@property (nonatomic, assign) int attentionUrl;// 关注的url参数

//@property (nonatomic, strong) UIButton *navSelectBtn;// 导航栏上被选中的按钮

@property (nonatomic, assign) BOOL isEnding;// 标记是否到了尾部

@property (nonatomic, strong) UIView *loginView;// 提示用户登录

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

#pragma mark - 创建关注部分的登录判断视图视图 -

- (UIView *)loginView {
    if (!_loginView) {
        self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49)];
        _loginView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
        imageV.image = [UIImage imageNamed:@"Logo_Miao"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 120, 20)];
        label.text = @"请先登录~";
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
        [loginBtn setTitleColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1] forState:UIControlStateNormal];
        loginBtn.frame = CGRectMake(ScreenWidth / 2 - 40, ScreenHeight / 3, 80, 40);
        loginBtn.layer.cornerRadius = 20;
        loginBtn.layer.masksToBounds = YES;
//        _attentionBtn.layer.borderWidth = 0;
        //__block UIButton *login = loginBtn;
        //弱引用，只有在，block内部要使用，“调用block的实例变量” 或者 “self的属性” 时，才使用
        //外部 __block HomeViewController *homeVC = self;
        //内部 homeVC.属性
        
        /**
         这里如果在block的实现中，返回值的类型不为空，在实现的类型部分可写可不写：但是，如果不写 ^(id button) {}，block的实现中，要返回同类型的变量；而写了 (id)^(id button) {}， 如果不写返回值，可以通过编译，但是不能运行， 要返回同类型的变量 或 nil。
         -->返回值，如果有，在block的内部一定要写！！！
         */

        loginBtn.block = (id)^(id button) {
            LoginViewController *loginVC =[[LoginViewController alloc] init];
            UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:navc animated:YES completion:nil];
            return nil;
        };
        [_loginView addSubview:loginBtn];
        [_loginView addSubview:label];
        [_loginView addSubview:imageV];
    }
    return _loginView;
}



#pragma mark - 创建基础视图 -

- (void)createNavigationButton {
    
    // 搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 20, 20);
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchBtn.block = (id)^(id button){
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.ControllerWithstring = @"HomeViewController";
        searchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
        return nil;
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

    
    __block HomeViewController *homeVC = self;
    
    _attentionBtn.block = ^(id button){
//        self.navSelectBtn = ((UIButton *)button);
        
//        if ([[UserInfoManager getUserID] isEqual:@" "]) {
//            self.attentionTableView.bounces = NO;
//            self.attentionArray = nil;
//            self.attentionDic = nil;
//            self.attentionTableView.tableHeaderView = self.loginView;// 返回提醒登录的视图
//            
//        } else if (self.attentionArray.count == 0) {// 已登录，且如果数组为空，请求一次数据
//            [self requestDataForAttentionWithAttentionUrl:0];
//        }

        // 改变两个按钮的颜色
        [homeVC.comicsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        homeVC.comicsBtn.backgroundColor = [UIColor clearColor];
        [((UIButton *)button) setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
        ((UIButton *)button).backgroundColor = [UIColor whiteColor];
        
        // 切换tableView
        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            //添加帧动画
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                homeVC.headView.frame = CGRectMake(ScreenWidth, 64, ScreenWidth, 30);
                homeVC.comicsTableView.frame = CGRectMake(ScreenWidth, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
            }];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                homeVC.attentionTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49);
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

    _comicsBtn.block = ^(id button){
        
        // 改变两个按钮的颜色
        [homeVC.attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        homeVC.attentionBtn.backgroundColor = [UIColor clearColor];
        [((UIButton *)button) setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
        ((UIButton *)button).backgroundColor = [UIColor whiteColor];
        
        // 切换tableView
        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            //添加帧动画
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                
                homeVC.attentionTableView.frame = CGRectMake(-ScreenWidth, 64, ScreenWidth, ScreenHeight - 64 - 49);
            }];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                homeVC.headView.frame = CGRectMake(0, 64, ScreenWidth, 30);
                homeVC.comicsTableView.frame = CGRectMake(0, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49);
            }];
            [homeVC.attentionTableView reloadData];
            
        } completion:^(BOOL finished) {
            NSLog(@"finished");
        }];

        return button;
    };
    
    // 记录 导航栏上被点击的按钮
//    self.navSelectBtn = _comicsBtn;
    
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
    _comicsTableView.showsVerticalScrollIndicator = NO;
    _comicsTableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1];
    [self.view addSubview:_comicsTableView];
    
    [self.comicsTableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComicsModel"];
    
    // 更新页面2
    _comicsTableView_switchover = [[UITableView alloc] initWithFrame:CGRectMake(- ScreenWidth, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49) style:UITableViewStylePlain];
    _comicsTableView_switchover.delegate = self;
    _comicsTableView_switchover.dataSource = self;
    _comicsTableView_switchover.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1];
    [self.view addSubview:_comicsTableView_switchover];
    
    [self.comicsTableView_switchover registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComicsModel"];
    
    // 关注页面
    _attentionTableView = [[UITableView alloc] initWithFrame:CGRectMake(- ScreenWidth, 64, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    _attentionTableView.delegate = self;
    _attentionTableView.dataSource = self;
    _attentionTableView.showsVerticalScrollIndicator = NO;
    _attentionTableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1];
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

            if (i == 6) {
                _urlString = @"0";
            } else {
                _urlString = [NSString stringWithFormat:@"%.0f", [[NSDate dateWithTimeInterval:(i - 6) * 24 * 60 * 60  sinceDate:date] timeIntervalSince1970]];
            }

            // 请求数据
            [self requestData:_urlString];
            
            return button;
        };
        
        [_headView addSubview:weekBtn];
    }
    
    [self.view addSubview:_headView];
}


#pragma mark - 更新日期的计算 -

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


#pragma mark - 更新的请求网络数据 -

- (void)requestData:(NSString *)dateString {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?since=0",HOME_NEW, dateString];
   
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

            comics.cover_image_url = [NSString stringWithFormat:@"%@.jpg", mDic[@"cover_image_url"]];
            
            [self.comicsArray addObject:comics];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
/*
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
  */
            [self.comicsTableView reloadData];
            [self.comicsTableView.mj_header endRefreshing];
        });
       
    } errorMessage:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - 关注的请求网络数据 -

- (void)requestDataForAttentionWithAttentionUrl:(int)attentionUrl {

    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"%@?since=%d",HOME_ATTENTION, attentionUrl] dic:@{} successful:^(NSData *data) {
        NSDictionary *dateDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        _attentionUrl = [dateDic[@"data"][@"since"] intValue];
        if (_attentionUrl == 0 && _attentionArray.count > 0) {
            _isEnding = YES;
        }

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

- (void)refreshComics{
    __weak HomeViewController *homeVC = self;
    // 更新列表添加下拉功能
    self.comicsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (homeVC.comicsTableView.contentOffset.y < 0) {
            [homeVC.comicsTableView.mj_header endRefreshing];
        }
        // 进入刷新状态后会自动调用这个block
        self.comicsArray = nil;// 置空数组
        [homeVC requestData:_urlString];
    }];
}

- (void)refreshAttention {
    __weak HomeViewController *homeVC = self;

    // 关注列表添加下拉功能
    self.attentionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (homeVC.attentionTableView.contentOffset.y < 0 || [[UserInfoManager getUserID] isEqual:@" "]) {
            [homeVC.attentionTableView.mj_header endRefreshing];
        }
        if (![[UserInfoManager getUserID] isEqual:@" "]) {
            self.attentionArray = nil;// 置空数组
            self.attentionDic = nil;
            [homeVC requestDataForAttentionWithAttentionUrl:0];
        }
    }];
    
    // 关注列表上拉功能
    self.attentionTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_isEnding) {
            [self.attentionTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        if (![[UserInfoManager getUserID] isEqual:@" "]) {
            [homeVC requestDataForAttentionWithAttentionUrl:_attentionUrl];
        } else {
            [homeVC.attentionTableView.mj_footer endRefreshing];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;// 去掉留白
    
    // 首次数据请求
    [self requestData:@"0"];

    _attentionUrl = 0;

    _isEnding = 0;
    
    // 创建基础视图
    [self createNavigationButton];
    [self createTableView];
    
    // 创建更新的头视图
    [self createHeadView];
    
    // 创建更新的刷新
    [self refreshComics];
    
    // 创建轻扫手势
    [self createSwipeGesture];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航栏的背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
//    [self.attentionTableView reloadData];

    // 用户没有登录，清空数组，让表不能回弹，指定登录提醒视图
    if ([[UserInfoManager getUserID] isEqual:@" "]) {
        self.attentionTableView.bounces = NO;
        self.attentionArray = nil;
        self.attentionDic = nil;
        self.attentionTableView.tableHeaderView = self.loginView;// 返回提醒登录的视图
        [self.attentionTableView reloadData];
        
    } else if (self.attentionArray.count == 0) {// 已登录，且如果数组为空，请求一次数据
        self.attentionTableView.bounces = YES;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.000000001)];
        headerView.backgroundColor = [UIColor clearColor];
        self.attentionTableView.tableHeaderView = headerView;
        [self requestDataForAttentionWithAttentionUrl:0];
        // 下拉刷新，上拉加载
        [self refreshAttention];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.comicsTableView == tableView) {
        if (self.comicsArray.count == 0) {// 当数组为空的时候， 不返回底部视图
            return 0;
        }
        return self.comicsArray.count + 1;
    }
    else {
        if (![[UserInfoManager getUserID] isEqual:@" "]) {
//            NSLog(@"604:%ld", self.attentionArray.count);
            return self.attentionArray.count;
        }
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.comicsTableView == tableView) {
        return 1;
    }
    else {
        // 判断数组的元素总和 不为0，才可以执行 self.attentionArray[section]
        if (self.attentionArray.count != 0) {
            NSString *key = self.attentionArray[section];
            return [self.attentionDic[key] count];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.comicsTableView == tableView && indexPath.section == self.comicsArray.count) {
        return 50;// 最后一组的高度
    }
    return (ScreenWidth) * ((float)10 / 17) + 10 * 4 + 20 + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.comicsArray.count == 0 && tableView == self.comicsTableView) {
        return nil;
    }
    
    /**
     
     if (self.attentionArray.count == 0 && tableView == self.attentionTableView) {
     
     //        BaseTableViewCell *cell = nil;
     //        return cell;
     }
     
     self.attentionTableView.tableHeaderView = self.loginView; 
     在 表 有头视图的情况下， 会 直接执行 到 cell中
     且 必须 获取 一个 不为空的 cell
     
     就像是 你给了TA 一个分组一样 ，
     相当于 执行了 方法  tableView:numberOfRowsInSection:
     获取的返回值是 1
     
     之后再去执行 tableView:heightForRowAtIndexPath:
     
     （这里没有置空数据）
     
     
     解决办法： 
     先执行 置空数组和指定 tableHeaderView；
     再执行一遍刷新视图的方法，截断跳转；
     然后，在 tableView:numberOfRowsInSection: 中，将数组的返回值 设为0。

     */
    
    if (self.attentionArray.count == 0 && tableView == self.attentionTableView) {
        return nil;
    }

    // 最后一组，滑到底的时候
    if (indexPath.section == self.comicsArray.count && self.comicsTableView == tableView) {
        BaseTableViewCell *cell = [[BaseTableViewCell alloc] init];
        cell.textLabel.text = @" 到底了哦，看看前一天的吧~";
        cell.imageView.image = [UIImage imageNamed:@"Logo_Miao"];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }

    
    ComicsModel *comics = nil;
    if (self.comicsTableView == tableView) {
        comics = _comicsArray[indexPath.section];
    }
    else {
        NSString *key = _attentionArray[indexPath.section];
        comics = _attentionDic[key][indexPath.row];
    }
    
    BaseTableViewCell *cell = [FactoryTableViewCell creatTableViewCell:comics tableView:tableView indexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.cornerRadius = 25;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    HomeCell *mycell = (HomeCell *)cell;
    mycell.comicNameBtn.block = (id)^(id button) {
        CompleteViewController *completeVC = [[CompleteViewController alloc] init];
        completeVC.ids = comics.topicModel.ids;// 传入全集的id
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:completeVC];
        [self.navigationController presentViewController:navc animated:YES completion:nil];
        return nil;
    };
    
    mycell.authorNameBtn.block = (id)^(id button) {
        AuthorViewController *authorVC = [[AuthorViewController alloc] init];
        authorVC.ids = comics.authorUserInfo.ids;// 传入作者的id
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:authorVC];
        [self.navigationController presentViewController:navc animated:YES completion:nil];
        return nil;
    };
    
    mycell.thisComicTitleBtn.block = (id)^(id button) {
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.cid = comics.ids;// 传入详情的id

        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];

        return nil;
    };
    mycell.imgVblock = ^{
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.cid = comics.ids;// 传入详情的id
        
        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
    };

    return cell;
}


#pragma mark - 设置组间距和颜色 -

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.comicsTableView) {
        return 10;// cell 之间的间距
    } else {
        if ([[UserInfoManager getUserID] isEqual:@" "]) {
            return ScreenHeight - 64 - 49;
        }
        return 25.000001;// 每组的时间的高度
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (tableView == self.attentionTableView && self.attentionArray.count != 0) {
        UIImageView *clockImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2.5, 20, 20)];
        clockImageV.image = [UIImage imageNamed:@"clock"];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 180, 25)];
        timeLabel.text = [NSString stringWithFormat:@"%@更新", _attentionArray[section]];
        timeLabel.font = [UIFont systemFontOfSize:15];
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
        [timeView addSubview:timeLabel];
        [timeView addSubview:clockImageV];
        timeView.backgroundColor = [UIColor clearColor];
        return timeView;// 返回时间头视图
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;// 返回空的头视图
}

@end
