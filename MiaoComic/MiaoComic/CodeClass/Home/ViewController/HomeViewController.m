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
@property (nonatomic, strong) NSMutableArray *comicsArray;// 更新请求的数据漫画数组
@property (nonatomic, strong) UIScrollView *headView;// 更新的头视图
@property (nonatomic, strong) UIButton *selectButton;// 更新的标记已经选择按钮
@property (nonatomic, strong) UIButton *comicsBtn;// 导航栏上的更新按钮


//@property (nonatomic, strong) UITableView *attentionTableView;// 关注TableView
//@property (nonatomic, strong) NSMutableArray *attentionArray;// 关注请求的数据漫画数组
//@property (nonatomic, strong) UIButton *attentionBtn;// 导航栏上的关注按钮

//@property (nonatomic, strong) UIButton *navSelectBtn;// 导航栏上被选中的按钮
@end

@implementation HomeViewController

#pragma mark - 懒加载 -
- (NSMutableArray *)comicsArray {
    if (_comicsArray == nil) {
        self.comicsArray = [NSMutableArray array];
    }
    return _comicsArray;
}
//- (NSMutableArray *)attentionArray {
//    if (_attentionArray == nil) {
//        self.attentionArray = [NSMutableArray array];
//    }
//    return _attentionArray;
//}

#pragma mark - 创建基础视图 -

- (void)createBaseView {
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
//    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _attentionBtn.frame = CGRectMake(0, 0, 50, 25);
//    [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
//    _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [_attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _attentionBtn.backgroundColor = [UIColor clearColor];
//    _attentionBtn.layer.cornerRadius = 12;
//    _attentionBtn.layer.masksToBounds = YES;
//    _attentionBtn.layer.borderWidth = 0;
//    
//    __block UIButton *attentionBtn = _attentionBtn;
//    attentionBtn.block = (id)^(id button){
////        self.navSelectBtn = ((UIButton *)button);
//        
//        [_comicsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _comicsBtn.backgroundColor = [UIColor clearColor];
//        [((UIButton *)button) setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
//        ((UIButton *)button).backgroundColor = [UIColor whiteColor];
//        [self.attentionTableView reloadData];
//        return button;
//    };
    
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
//    self.navSelectBtn = _comicsBtn;
    
    __block UIButton *comicsBtn = _comicsBtn;
    comicsBtn.block = (id)^(id button){
//        self.navSelectBtn = ((UIButton *)button);
        
//        [_attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _attentionBtn.backgroundColor = [UIColor clearColor];
        [((UIButton *)button) setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
        ((UIButton *)button).backgroundColor = [UIColor whiteColor];
        
        [self.comicsTableView reloadData];
        return button;
    };
    
    // 创建导航视图控制器的标题视图，并添加关注和更新按钮
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
//    [titleView addSubview:_attentionBtn];
    [titleView addSubview:_comicsBtn];
    
    self.navigationItem.titleView = titleView;
    
    
    // 更新页面
    _comicsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30 + 64, ScreenWidth, ScreenHeight - 30 - 64 - 49) style:UITableViewStylePlain];
    _comicsTableView.delegate = self;
    _comicsTableView.dataSource = self;
    _comicsTableView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [self.view addSubview:_comicsTableView];
    
    [self.comicsTableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComicsModel"];
    
    // 关注页面
//    _attentionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStylePlain];
//    _attentionTableView.delegate = self;
//    _attentionTableView.dataSource = self;
//    _attentionTableView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
//    [self.view addSubview:_attentionTableView];
//    
//    [self.attentionTableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComicsModel"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestData:@"0"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;// 去掉留白
    
    
    
    // 创建基础视图
    [self createBaseView];
    
    // 创建更新的头视图
    [self createHeadView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - 创建头部日期滚动视图 -

- (void)createHeadView {
    _headView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 30)];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.contentSize = CGSizeMake(ScreenWidth / 6 * 7, 30);
    NSLog(@"%f", ScreenWidth / 6 * 7);
    _headView.contentOffset = CGPointMake(ScreenWidth / 6, 0);
    _headView.bounces = NO;
    _headView.pagingEnabled = NO;
    _headView.showsHorizontalScrollIndicator = NO;
 
    
    for (int i = 0; i < 7; i ++) {
        CGFloat width = ScreenWidth / 6;
        UIButton *weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weekBtn.frame = CGRectMake(i * width, 0, width, 30);
        weekBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [weekBtn setTitle:[self computeTimeWithIndex:i] forState:UIControlStateNormal];
        [weekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIView *markView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, width, 5)];

        markView.backgroundColor = [UIColor clearColor];
        [weekBtn addSubview:markView];
        
        if (i == 6) {
            self.selectButton = weekBtn;
            [weekBtn setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
            [weekBtn.subviews lastObject].backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
        }
        
        
        weekBtn.block = (id)^(id button){
            UIButton *mybutton = (UIButton *)button;
            if (self.selectButton == mybutton) {
                return button;
            }
            
            [self.comicsArray removeAllObjects];
            [self.selectButton.subviews lastObject].backgroundColor = [UIColor clearColor];
            [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            [mybutton setTitleColor:[UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1] forState:UIControlStateNormal];
            [mybutton.subviews lastObject].backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
            
            self.selectButton = mybutton;
      
            // 请求数据
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dataString = [formatter stringFromDate:[NSDate date]];
            NSDate *date = [formatter dateFromString:dataString];
            NSString *urlString = [NSString stringWithFormat:@"%.0f", [[NSDate dateWithTimeInterval:(i - 6) * 24 * 60 * 60  sinceDate:date] timeIntervalSince1970]];

            [self requestData:urlString];
            return button;
        };
        
        [_headView addSubview:weekBtn];
    }
    
    [self.view addSubview:_headView];

}



#pragma mark - 时间的计算 -
- (NSString *)computeTimeWithIndex:(int)index {
    if (index == 6) {
        return @"今天";
    } else if (index == 5) {
        return @"昨天";
    }
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate dateWithTimeInterval:(index - 6) * 24 * 60 * 60 sinceDate:[NSDate date]]];
    return [weekdays objectAtIndex:theComponents.weekday];
}


#pragma mark - 请求网络数据 -

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

            [self.comicsTableView reloadData];
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


//#pragma mark - 时间获取 -
/**
 根据滚动视图的索引，返回一个时间
 */
//- (NSString *)getTimeWithIndex:(NSInteger *)index {
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.navSelectBtn == self.comicsBtn) {
//        return self.comicsArray.count + 1;
//    }
    NSLog(@"self.comicsArray.count + 1:%ld",self.comicsArray.count + 1);
#warning - 按时间分组
    return self.comicsArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.navSelectBtn == self.comicsBtn) {
//        return 1;
//    }
#warning - 按时间分组
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.comicsArray.count) {// 最后一组的高度
        return 50;
    }
    return (ScreenWidth) * ((float)10 / 17) + 10 * 4 + 20 + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 最后一组，滑到底的时候
    if (indexPath.section == self.comicsArray.count) {
        BaseTableViewCell *cell = [[BaseTableViewCell alloc] init];
        cell.textLabel.text = @"到底了，看看前一天的吧~";
        cell.imageView.image = [UIImage imageNamed:@"Logo_Miao"];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    
    ComicsModel *comics = _comicsArray[indexPath.section];
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

// 设置组间距和颜色
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//
//    // Pass the selected object to the new view controller.
//
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
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
