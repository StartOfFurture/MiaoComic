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
@property (nonatomic, copy) NSString *descriptions;// 作品简介
@property (nonatomic, strong) AuthorUserInfo *authorUserInfo;// 作者信息
@property (nonatomic, strong) UIView *newView;// 第一组的row
@property (nonatomic, assign) BOOL is_favourite;// 标记是否被关注


@end

@implementation CompleteViewController


#pragma mark - 懒加载 -

- (NSMutableArray *)completeArray {
    if (_completeArray == nil) {
        self.completeArray = [NSMutableArray array];
    }
    return _completeArray;
}

- (UIView *)newView {
    if (_newView == nil) {
        self.newView = [[UIView alloc] initWithFrame:CGRectMake(0, - ScreenHeight / 3 + 64, ScreenWidth, ScreenHeight / 3)];
        [self.newView addSubview:[self.completeView createSection_One_Row_One]];//CGRectMake(- 30, 0, ScreenWidth + 60, 40)
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight / 3, ScreenWidth, 40)];
        view.backgroundColor = [UIColor blackColor];
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, - 40);
        view.layer.shadowRadius =  30 ;
        view.layer.shadowOpacity = 1;
        [view addSubview:[self.completeView createSection_Two_Header]];
        [self.newView addSubview:view];
    }
    return _newView;
}


#pragma mark - 返回按钮 -

- (void)createNaVCBtn {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, ScreenHeight / 3 / 6, ScreenHeight / 3 / 6)];
    [backBtn setImage:[UIImage imageNamed:@"pre"] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius= ScreenHeight / 3 / 6 / 2;
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
    
    UIButton *attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20,  ScreenHeight / 3 / 6 / 5 * 4 * 2, ScreenHeight / 3 / 6 / 5 * 4)];
    [attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    attentionBtn.layer.cornerRadius= ScreenHeight / 3 / 6 / 5 * 4 / 2;
    attentionBtn.layer.masksToBounds = YES;
    attentionBtn.layer.borderWidth = 1;
    attentionBtn.layer.borderColor = [UIColor blackColor].CGColor;
    attentionBtn.backgroundColor = [UIColor colorWithRed:0.77 green:0.38 blue:0.67 alpha:1];
    attentionBtn.block = (id)^(id button) {
        UIButton *mybutton = ((UIButton *)button);
        [mybutton setTitle:@"已关注" forState:UIControlStateNormal];
        mybutton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [mybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        mybutton.titleLabel.font = [UIFont systemFontOfSize:14];

        mybutton.layer.borderColor = [UIColor whiteColor].CGColor;

        return nil;
    };
    
    // 去除高亮状态
    attentionBtn.adjustsImageWhenHighlighted = NO;
    
    UIBarButtonItem *attentionItem = [[UIBarButtonItem alloc] initWithCustomView:attentionBtn];
    self.navigationItem.rightBarButtonItem = attentionItem;
    
//    [self.view addSubview:backBtn];
}


#pragma mark - 数据请求 -

- (void)request:(NSString *)sort {
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@?sort=%@", COMPLETEURL, self.ids, sort]);
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"%@%@?sort=%@", COMPLETEURL, self.ids, sort] dic:@{} successful:^(NSData *data) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        // 用于 判断是否 关注
        _is_favourite = dictionary[@"data"][@"is_favourite"];
        
        // 作品简介 descriptions
        _descriptions = dictionary[@"data"][@"description"];
        
        // 作者信息 authorUserInfo.avatar_url、authorUserInfo.nickname、id
        _authorUserInfo = [[AuthorUserInfo alloc] init];
        [_authorUserInfo setValuesForKeysWithDictionary:dictionary[@"data"][@"user"]];
        
        // 每本作品信息
        NSArray *array = dictionary[@"data"][@"comics"];
//        NSLog(@"%@", dictionary);
        for (NSDictionary *mDic in array) {
            ComicsModel *comics = [[ComicsModel alloc] init];
            [comics setValuesForKeysWithDictionary:mDic];
            [self.completeArray addObject:comics];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            // - 头部视图 -
            // 封面图片
            [self.completeView.headerView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"data"][@"cover_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            // 点赞数
            self.completeView.likeLabel.text =[NSString stringWithFormat:@"%ld", (NSInteger)(dictionary[@"data"][@"likes_count"])];
            NSLog(@"%@", self.completeView.likeLabel.text);
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
    self.completeView = [[CompleteView alloc] initWithFrame:CGRectMake(0, - 64, ScreenWidth, ScreenHeight + 64)];
    self.view = self.completeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"placeholder"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsCompact];
    /**
     打印 导航栏 的子视图
     进入 层次图，找到 线条 所在父视图
     将 打印出来的视图 与层次图的视图对比，删除 线条
     */
//    NSLog(@"%@",self.navigationController.navigationBar.subviews);
    [[[self.navigationController.navigationBar.subviews firstObject].subviews firstObject] removeFromSuperview];
    
    self.completeView.contentTableV.delegate = self;
    self.completeView.contentTableV.dataSource = self;
    [self.completeView.contentTableV registerNib:[UINib nibWithNibName:@"CompleteCell" bundle:nil] forCellReuseIdentifier:@"ComicsModel"];
    
    self.completeView.contentTableV.scrollEnabled = NO;//设置tableview 不能滚动
    
    // 创建导航栏按钮
    [self createNaVCBtn];
    
    [self request:@"0"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView的代理方法 -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
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
//        self.makeCell = cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0){
        
        cell = [[BaseTableViewCell alloc] init];
        [cell.contentView addSubview:[self.completeView createSection_Two_Row_One]];
        
    } else if (indexPath.section == 1 && indexPath.row >= 1){

        ComicsModel *comicsmodel = self.completeArray[indexPath.row - 1];
        cell = [FactoryTableViewCell creatTableViewCell:comicsmodel tableView:tableView indexPath:indexPath];
        CGFloat y = cell.frame.origin.y;// cell的y轴
        CGFloat height = cell.frame.size.height;
        CGFloat tableViewHeight = tableView.frame.size.height - 64;
        if (y + height > tableViewHeight) {// 当最后一个cell超出表格，可以滚动
            tableView.scrollEnabled = YES;
        }
        
    }else {
        return nil;
    }

    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.bounces = NO;// 去掉回弹效果
    tableView.showsVerticalScrollIndicator = NO;

    return cell;
}


#pragma mark - 添加新的第一组的第一个row -

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
