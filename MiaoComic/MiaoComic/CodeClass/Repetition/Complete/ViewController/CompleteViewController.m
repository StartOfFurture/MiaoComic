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

@interface CompleteViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) CompleteView *completeView;
@property (nonatomic, strong) NSMutableArray *completeArray;
//@property (nonatomic, copy) NSString *descriptions;// 作品简介
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) AuthorUserInfo *authorUserInfo;// 作者信息
@property (nonatomic, strong) UIImageView *newView;// 第一组的row
@property (nonatomic, assign) BOOL is_favourite;// 标记是否被关注
@property (nonatomic, strong) UIButton *attentionBtn;// 关注按钮

@property (nonatomic, strong) ComicsModel *topComics;// 封面图片，评论，点赞，是否关注 is_favourite，作品简介 descriptions
@property (nonatomic, strong) UITableView *introTableV;// 简介表
@property (nonatomic, strong) UITableView *contentTableV;// 内容表

@property (nonatomic, strong) UIScrollView *scrollView;// scrollView


@property (nonatomic, assign) CGFloat productionY;// 标记上一次的cell的高度


@end

@implementation CompleteViewController


#pragma mark - 懒加载 -

- (NSMutableArray *)completeArray {
    if (_completeArray == nil) {
        self.completeArray = [NSMutableArray array];
    }
    return _completeArray;
}

- (UIImageView *)newView {
    if (_newView == nil) {
        self.newView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - ScreenHeight / 3 + 64, ScreenWidth, ScreenHeight / 3)];
        
        // 阴影
        for (CGFloat i = 0, a1 = 1.0, Max = 255.0, height = 150.0; i < Max; i ++) {
            a1 = (0 + i) / 255.0;
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight / 3 - height / Max * i, ScreenWidth, height / Max)];
            view.backgroundColor=[UIColor colorWithRed:a1 green:a1 blue:a1 alpha:1 - i / Max];// 1 - i / Max
            [self.newView addSubview:view];
        }

    }
    return _newView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 40)];
        _scrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - 64 - 40);// ScreenHeight / 3 * 2 - 40
        _scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [_scrollView addSubview:_introTableV];
        [_scrollView addSubview:_contentTableV];
    }
    return _scrollView;
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

// 改变按钮外形状态
- (void)attentionState{
    
}

#pragma mark - 创建表 -

- (void)createTableView {
    self.completeView.contentTableV.delegate = self;
    self.completeView.contentTableV.dataSource = self;
//    [self.completeView.contentTableV registerNib:[UINib nibWithNibName:@"CompleteCell" bundle:nil] forCellReuseIdentifier:@"ComicsModel"];
    self.completeView.contentTableV.scrollEnabled = NO;//设置tableview 不能滚动
    
    
    self.introTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _introTableV.backgroundColor = [UIColor redColor];
    self.introTableV.delegate = self;
    self.introTableV.dataSource = self;
    self.introTableV.scrollEnabled = NO;
    
    self.contentTableV = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 64 - 40) style:UITableViewStylePlain];
    self.contentTableV.delegate = self;
    self.contentTableV.dataSource = self;
    [self.contentTableV registerNib:[UINib nibWithNibName:@"CompleteCell" bundle:nil] forCellReuseIdentifier:@"ComicsModel"];
    self.contentTableV.scrollEnabled = NO;
    self.contentTableV.backgroundColor = [UIColor blueColor];
}


#pragma mark - 数据请求 -

- (void)request:(NSString *)sort {
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@?sort=%@", COMPLETEURL, self.ids, sort]);
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"%@%@?sort=%@", COMPLETEURL, self.ids, sort] dic:@{} successful:^(NSData *data) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];

        // 每本作品信息
        NSArray *array = dictionary[@"data"][@"comics"];
//        NSLog(@"%@", dictionary);
        for (NSDictionary *mDic in array) {
            ComicsModel *comics = [[ComicsModel alloc] init];
            [comics setValuesForKeysWithDictionary:mDic];
            [self.completeArray addObject:comics];
        }
        
        // 封面图片，评论，点赞，是否关注 is_favourite，作品简介 descriptions
        _topComics = [[ComicsModel alloc] init];
        [_topComics setValuesForKeysWithDictionary:dictionary[@"data"]];
        
        
//        // 用于 判断是否 关注
        _is_favourite = _topComics.is_favourite;
//
//        // 作品简介 descriptions
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, 0)];
        _descLabel.text = _topComics.descriptions;
        _descLabel.font = [UIFont systemFontOfSize:13];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1];
        _descLabel.text = _topComics.descriptions;
        
        // 作者信息 authorUserInfo.avatar_url、authorUserInfo.nickname、id
        _authorUserInfo = [[AuthorUserInfo alloc] init];
        [_authorUserInfo setValuesForKeysWithDictionary:dictionary[@"data"][@"user"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            // - 头部视图 -
            // 封面图片
            [self.completeView.headerView sd_setImageWithURL:[NSURL URLWithString:_topComics.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            // 新的头视图
            [self.newView sd_setImageWithURL:[NSURL URLWithString:_topComics.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            // 点赞数
            if (_topComics.likes_count > 100000) {
                self.completeView.likeLabel.text = [NSString stringWithFormat:@"%ld万", _topComics.likes_count / 10000];
            } else {
                self.completeView.likeLabel.text = [NSString stringWithFormat:@"%ld", _topComics.likes_count];
            }
            // 评论数
            if (_topComics.comments_count > 100000) {
                self.completeView.commentLabel.text = [NSString stringWithFormat:@"%ld万", _topComics.comments_count / 10000];
            } else {
                self.completeView.commentLabel.text = [NSString stringWithFormat:@"%ld", _topComics.comments_count];
            }

            // 漫画名
            self.completeView.titleLabel.text = _topComics.title;
            
            [self.completeView.contentTableV reloadData];
            [self.contentTableV reloadData];
        
            // 截获对contentsize的设置
            [self setTableViewContentOffset];
            
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
    
    /**
     让 navigationController 透明，但任然存在
     */
    [self request:@"0"];
    
//    _cellOfY = 64;
    
    UIImage *image = [UIImage imageNamed:@"placeholder"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsCompact];
    /**
     打印 导航栏 的子视图
     进入 层次图，找到 线条 所在父视图
     将 打印出来的视图 与层次图的视图对比，删除 线条
     */
//    NSLog(@"%@",self.navigationController.navigationBar.subviews);
    [[[self.navigationController.navigationBar.subviews firstObject].subviews firstObject] removeFromSuperview];

    // 创建导航栏按钮
    [self createNaVCBtn];
    
    // 创建表
    [self createTableView];

    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"introAndContent" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)notice:(NSNotification *)notification{
    NSString *getsendValue = [[notification userInfo] valueForKey:@"selectBtn"];
    if ([getsendValue isEqualToString:@"0"]) {
        self.completeView.contentTableV.scrollEnabled = NO;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
    } else {
        
#warning - 调用方法，判断主表是否能够滚动 -
        self.completeView.contentTableV.scrollEnabled = YES;
        self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }
    
    NSLog(@"%@",getsendValue);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.completeView.contentTableV reloadData];
//    [self.contentTableV reloadData];
//    [self.introTableV reloadData];
    
//    [self.view addSubview:[self.completeView createHeadView]];// 头视图
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView的代理方法 -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.completeView.contentTableV) {
        return 2;
    }
    return 1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.completeView.contentTableV) {
        if (section == 0) {
            return nil;
        } else {
#warning - 在第二组的 “第一个cell” 里创建 “一张表”
#warning - 判断在第二组的 第几张表 -
            return [self.completeView createSection_Two_Header];
        }
    }

    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.completeView.contentTableV) {
        if (section == 0) {
            return 0.00001;
        } else {
            return 40;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.completeView.contentTableV) {
        if (indexPath.section == 0) {
            return ScreenHeight / 3 - 64;
        } else if (indexPath.section == 1){// 第二组的第一个cell的大小
            return ScreenHeight - 64 - 40;//ScreenHeight / 3 * 2 - 40
        }
    }
    
    if (tableView == self.introTableV) {
        if (indexPath.row == 0) {
     
//            CGRect rect = [_descLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth, FLT_MAX) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
//            NSLog(@"%f,%f,%f,%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            UITableViewCell *cell = [self tableView:self.introTableV cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        } else {
            return 40;
        }
    }
    
    if (tableView == self.contentTableV) {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 100;
        }
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.completeView.contentTableV) {
        return 1;
    }
    
    if (tableView == self.introTableV) {
        return 2;
    }
    
    if (tableView == self.contentTableV) {
        return self.completeArray.count + 1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    if (tableView == self.completeView.contentTableV) {
        cell = [[BaseTableViewCell alloc] init];
        if (indexPath.section == 0) {
            [cell.contentView addSubview:[self.completeView createSection_One_Row_One]];
        } else {
            [cell.contentView addSubview:self.scrollView];
        }
    }
    

    
    if (tableView == self.introTableV) {
        cell = [[BaseTableViewCell alloc] init];
        if (indexPath.row == 0) {
            CGRect rect = [_topComics.descriptions boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            CGFloat height = rect.size.height;

            // CGRectMake(0, 0, ScreenWidth, 80)
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
            UILabel *descriptionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, height + 10)];

            descriptionsLabel.text = _topComics.descriptions;
            descriptionsLabel.font = [UIFont systemFontOfSize:12];
            descriptionsLabel.numberOfLines = 0;
            descriptionsLabel.textColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1];
            // 分割线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height + 10 - 1, ScreenWidth, 1)];
            line.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1];
            [view addSubview:line];
            [view addSubview:descriptionsLabel];
            [cell.contentView addSubview:view];
        } else {
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
            
            imageV.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_authorUserInfo.avatar_url]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            imageV.layer.cornerRadius = 15;
            imageV.layer.masksToBounds = YES;
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, ScreenWidth - 105, 40)];
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_authorUserInfo.avatar_url] placeholderImage:[UIImage imageNamed:@"pre"]];
            
            textLabel.text = _authorUserInfo.nickname;
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.textColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1];

            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 50, 40)];
            view.backgroundColor = [UIColor whiteColor];
            
            [view addSubview:imageV];
            [view addSubview:textLabel];
            
            [cell.contentView addSubview:view];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
            
           

        }
     
    }
    
    if (tableView == self.contentTableV) {
        if (indexPath.row == 0){
            cell = [[BaseTableViewCell alloc] init];
            [cell.contentView addSubview:[self.completeView createSection_Two_Row_One]];
            
        } else if (indexPath.row >= 1){
            
            ComicsModel *comicsmodel = self.completeArray[indexPath.row - 1];
            cell = [FactoryTableViewCell creatTableViewCell:comicsmodel tableView:tableView indexPath:indexPath];
            
            // 设置滚动条件
//            CGFloat y = cell.frame.origin.y;// cell的y轴
//            CGFloat height = cell.frame.size.height;
//            CGFloat tableViewHeight = ScreenHeight - 64;
//            if (y + height > tableViewHeight) {// 当最后一个cell超出表格，可以滚动
//                tableView.scrollEnabled = YES;
//            }
        }
      
        
    }
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.bounces = NO;// 去掉回弹效果
    tableView.showsVerticalScrollIndicator = NO;
    
      /*
     else if (indexPath.section == 1 && indexPath.row == 0){
        
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
*/

    


   
    
    return cell;
}


#pragma mark - 设置表的偏移量 -

- (void)setTableViewContentOffset {
    // 主表呈现的时候，内容表中的每集漫画cell的可用位置
    CGFloat comicsCellSurplusH = ScreenHeight / 3 * 2 - 40 - 40;
    
    // 每集漫画的所有cell的总高度
    CGFloat comicsCellTotalH = 100 * self.completeArray.count;
    
    // 当主表到达导航栏下的时候，内容表中的每集漫画的cell的可用位置
    CGFloat comicsCellH = ScreenHeight - 64 - 40 - 40;
    
    /**
     用于判断主表可偏移的位置：
     offset <= 0，主表不可滚动，内容表不可滚动；
     0 < offset < comicsCellH，主表的滚动范围为 offset，主表可滚动，内容表不可滚动；
     offset >＝ comicsCellH，主表的滚动范围为 comicsCellH，内容表可滚动，主表不可滚动
     */
    CGFloat offset = comicsCellTotalH - comicsCellSurplusH;
    NSLog(@"%f", offset);
    if (offset > 0) {
        self.completeView.contentTableV.scrollEnabled = YES;
        if(comicsCellTotalH <= comicsCellH) {
            self.completeView.contentTableV.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 64 + offset);
            
  
        } else {
            // 当主表的偏移量在
            
        }
    }
    
}



#pragma mark - 添加新的第一组的第一个row -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrollView == scrollView) {
        CGFloat pointX = _scrollView.contentOffset.x;
        if (pointX == 0) {
            _completeView.introBtn.block(_completeView.introBtn);
        } else {
            _completeView.contentBtn.block(_completeView.contentBtn);
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect rectInTableView = [self.completeView.contentTableV rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    CGRect rect = [self.completeView.contentTableV convertRect:rectInTableView toView:[self.completeView.contentTableV superview]];
    CGFloat height = ScreenHeight / 3 - 64;
    if (rect.origin.y + height < 64) {
        NSLog(@"%f", rect.origin.y);
        [self.view addSubview:self.newView];
        self.completeView.contentTableV.scrollEnabled = NO;
        self.contentTableV.scrollEnabled = YES;
    } else {
        [self.newView removeFromSuperview];
        
        CGRect rectcontentTV = [self.contentTableV rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGRect rectcontent = [self.contentTableV convertRect:rectcontentTV toView:[self.completeView.contentTableV superview]];
        
        
        if (rectcontent.origin.y < 64 + 40) {
            self.completeView.contentTableV.scrollEnabled = YES;
            self.contentTableV.scrollEnabled = NO;
        } else {
            // 判断，rectcontent.origin.y 是不是比上一次的大:
            // 如果是，就在往下拉，那么当rectcontent.origin.y == 64 + 40，
//            self.completeView.contentTableV.scrollEnabled = YES;
//            self.contentTableV.scrollEnabled = NO;
            // 如果不是，就在往上拉，那么当rectcontent.origin.y == 64 + 40，
//            self.completeView.contentTableV.scrollEnabled = NO;
//            self.contentTableV.scrollEnabled = YES;
            if (rectcontent.origin.y >= _productionY && rectcontent.origin.y == 64 + 40) {
                self.completeView.contentTableV.scrollEnabled = YES;
                self.contentTableV.scrollEnabled = NO;
            }
            if (rectcontent.origin.y < _productionY && rectcontent.origin.y == 64 + 40) {
                self.completeView.contentTableV.scrollEnabled = NO;
                self.contentTableV.scrollEnabled = YES;
            }
            
            
            
            
            
        }
        _productionY = rectcontent.origin.y;
        
    }
    


//    static CGFloat cellOfY = 64;
    

    
    
//    NSLog(@"----%@", self.completeView.headerView);
//    if (rect.origin.y + height > 64 && rect.origin.y + height < ScreenHeight / 3) {
//        NSLog(@"!!!%@", self.completeView.headerView);
//        CGRect frame = self.completeView.headerView.frame;
//        frame.origin.y = self.completeView.headerView.frame.origin.y + rect.origin.y - cellOfY;
//        NSLog(@"???%@", self.completeView.headerView);
//        NSLog(@"frame.origin.y:%f", frame.origin.y);
//        NSLog(@"%f", - ScreenHeight / 3 + 64);
//        if (frame.origin.y > - ScreenHeight / 3 + 64 && frame.origin.y <= 0) {
//            self.completeView.headerView.frame = frame;
//        }
//        
//    } else if (rect.origin.y == 64) {
//        self.completeView.headerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight / 3);
//    } else if ( rect.origin.y + height == 64) {
//        self.completeView.headerView.frame = CGRectMake(0, - ScreenHeight / 3 + 64, ScreenWidth, ScreenHeight / 3);
//    }
//    
//    NSLog(@"rect.origin.y - cellOfY:%f", rect.origin.y - cellOfY);
//    NSLog(@"rect.origin.y:%f, cellOfY:%f", rect.origin.y, cellOfY);
//    cellOfY = rect.origin.y;
//    NSLog(@"%f, %f", rect.origin.y, frame.origin.y);
    
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
