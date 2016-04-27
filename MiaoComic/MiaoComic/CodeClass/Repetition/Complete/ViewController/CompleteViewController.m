//
//  CompleteViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CompleteViewController.h"
#import "CompleteView.h"
#import "ComicsModel.h"
#import "AuthorUserInfo.h"

@interface CompleteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) CompleteView *completeView;
@property (nonatomic, strong) NSMutableArray *completeArray;
@property (nonatomic, strong) UIView *makeView;// 标记用的cell
@property (nonatomic, strong) UIView *newView;// 第一组的row
@property (nonatomic, strong) BaseTableViewCell *makeCell;
@end

@implementation CompleteViewController

- (NSMutableArray *)completeArray {
    if (_completeArray == nil) {
        self.completeArray = [NSMutableArray array];
    }
    return _completeArray;
}

- (UIView *)newView {
    if (_newView == nil) {
        self.newView = [[UIView alloc] initWithFrame:CGRectMake(0, - ScreenHeight / 3 + 64, ScreenWidth, ScreenHeight)];
        [self.newView addSubview:[self.completeView createSection_One_Row_One]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -40, ScreenWidth, 40)];
        view.backgroundColor = [UIColor blackColor];
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, - 40);
        view.layer.shadowRadius =  30 ;
        view.layer.shadowOpacity = 1;
        [self.newView addSubview:view];
        
    }
    return _newView;
}

#pragma mark - 返回按钮 -
- (void)createBackBtn {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"pre"] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius= 20;
    backBtn.layer.masksToBounds = YES;
    backBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    backBtn.block = (id)^(id button) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return nil;
    };
    
    // 去除高亮状态
    backBtn.adjustsImageWhenHighlighted = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    [self.view addSubview:backBtn];
}

- (void)request:(NSString *)sort {
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@?sort=%@", COMPLETEURL, self.ids, sort]);
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"%@%@?sort=%@", COMPLETEURL, self.ids, sort] dic:@{} successful:^(NSData *data) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        // 每集作品信息
        NSArray *array = dictionary[@"data"][@"comics"];
//        NSLog(@"%@", dictionary);
        for (NSDictionary *mDic in array) {
            ComicsModel *comics = [[ComicsModel alloc] init];
            [comics setValuesForKeysWithDictionary:mDic];
            [self.completeArray addObject:comics];
        }
        // 作者信息
        AuthorUserInfo *authorUserInfo = [[AuthorUserInfo alloc] init];
        [authorUserInfo setValuesForKeysWithDictionary:dictionary[@"data"][@"user"]];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            // 封面图片
            [self.completeView.headerView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"data"][@"cover_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            // 点赞数
            self.completeView.likeLabel.text =[NSString stringWithFormat:@"%ld", (NSInteger)(dictionary[@"data"][@"likes_count"])];
            // 评论数
            self.completeView.commentLabel.text =[NSString stringWithFormat:@"%ld", (NSInteger)(dictionary[@"data"][@"comments_count"])];
            // 漫画名
            self.completeView.titleLabel.text = dictionary [@"title"];
            [self.completeView.contentTableV reloadData];
            
        });
        
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

- (void)loadView {
    [super loadView];
    self.completeView = [[CompleteView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.view = self.completeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"placeholder"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsCompact];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.translucent = YES;
    
    self.completeView.contentTableV.delegate = self;
    self.completeView.contentTableV.dataSource = self;
    [self.completeView.contentTableV registerNib:[UINib nibWithNibName:@"CompleteCell" bundle:nil] forCellReuseIdentifier:@"ComicsModel"];
    
    self.completeView.contentTableV.scrollEnabled = NO;//设置tableview 不能滚动
    
    // 创建返回按钮
    [self createBackBtn];
    
    [self request:@"0"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {

        self.makeView = [self.completeView createSection_Two_Header];
        return [self.completeView createSection_Two_Header];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.00001;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ScreenHeight / 3;
    } else if (indexPath.section == 1 && indexPath.row == 0){
        return 40;
    } else {
        return 100;
    }
}

#pragma mark - UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.completeArray.count + 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    
    if (indexPath.section == 0) {

        cell = [[BaseTableViewCell alloc] init];
        [cell.contentView addSubview:[self.completeView createSection_One_Row_One]];
        cell.backgroundColor = [UIColor orangeColor];
        self.makeCell = cell;

    } else if (indexPath.section == 1 && indexPath.row == 0){

        cell = [[BaseTableViewCell alloc] init];
        
        [cell.contentView addSubview:[self.completeView createSection_Two_Row_One]];
//        NSLog(@"---%@",cell);
    } else if (indexPath.section == 1 && indexPath.row >= 1){
        NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
        
        ComicsModel *comicsmodel = self.completeArray[indexPath.row - 1];
        cell = [FactoryTableViewCell creatTableViewCell:comicsmodel tableView:tableView indexPath:indexPath];

//        NSLog(@"++++%@",cell);
        
        CGFloat y = cell.frame.origin.y;// cell的y轴
        CGFloat height = cell.frame.size.height;
        CGFloat tableViewHeight = tableView.frame.size.height;
        if (y + height > tableViewHeight) {// 当最后一个cell超出表格，可以滚动
            tableView.scrollEnabled = YES;
        }
    }else {
        return nil;
    }

    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect rectInTableView = [self.completeView.contentTableV rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    CGRect rect = [self.completeView.contentTableV convertRect:rectInTableView toView:[self.completeView.contentTableV superview]];
    if (rect.origin.y < - ScreenHeight / 3 + 64) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.newView];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newView removeFromSuperview];
        });
    }
    NSLog(@"rect.height:%f", rect.size.height);
    NSLog(@"rect.y:%f", rect.origin.y);
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
