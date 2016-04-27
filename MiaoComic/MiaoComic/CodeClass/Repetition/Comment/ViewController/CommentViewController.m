//
//  CommentViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentTableCell.h"
#import "ReadKeyBoard.h"
#import "LoginViewController.h"

@interface CommentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;//表视图
@property (nonatomic, copy)NSString *since;//从哪里开始加载
@property (nonatomic, strong)NSMutableArray *array;//存放数据的数组
@property (nonatomic, strong)ReadKeyBoard *keyBoard;//输入框
@property (nonatomic, strong)UISegmentedControl *segVC;//标题

@end

@implementation CommentViewController

- (NSMutableArray *)array{
    if (_array == nil) {
        _array = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _array;
}

//数据解析
- (void)jiexiCreateData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    self.since = dic[@"data"][@"since"];
    NSArray *arr = dic[@"data"][@"comments"];
    for (NSDictionary *dic1 in arr) {
        CommentModel *model = [[CommentModel alloc] init];
        [model setValuesForKeysWithDictionary:dic1];
        model.avatar_url = dic1[@"user"][@"avatar_url"];
        model.nickname = dic1[@"user"][@"nickname"];
        model.userID = dic1[@"user"][@"id"];
        [self.array addObject:model];
    }
    NSLog(@"%@",self.array);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    });
}

//最新数据请求
- (void)requestData:(NSString *)string{
    if ([[NSString stringWithFormat:@"%@",self.since] isEqualToString:@"0"]) {
        [self.array removeAllObjects];
    }
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:string, self.ID, self.since] dic:nil successful:^(NSData *data) {
        [self jiexiCreateData:data];
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.since = @"0";
    self.ID = @"10720";
    //请求数据
    [self requestData:COMMENT_New];
    
    //按钮的显示
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setBackgroundImage:[[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.block = (id)^(id button1){
        [self dismissViewControllerAnimated:YES completion:nil];
        return nil;
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //评论标题的显示
    _segVC = [[UISegmentedControl alloc] initWithItems:@[@"最新评论",@"最热评论"]];
    //这个时候什么搜不会显示
    _segVC.tintColor = [UIColor lightGrayColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [_segVC setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    [_segVC setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    _segVC.selectedSegmentIndex = 0;
    [_segVC addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segVC;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CommentTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentModel"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_tableView.contentOffset.y < 0) {
            [_tableView.mj_header endRefreshing];
        }
        self.since = @"0";
        [self requestData:COMMENT_New];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestData:COMMENT_New];
    }];
    [self.view addSubview:_tableView];
    
    //输入框的添加
    _keyBoard = [[ReadKeyBoard alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    _keyBoard.ID = self.ID;
    //键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBoardKey:) name:UIKeyboardDidShowNotification object:nil];
    //键盘即将消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidKeyBoard:) name:UIKeyboardDidHideNotification object:nil];
    [self.view addSubview:_keyBoard];
    
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"shuaxin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"nouser" object:nil];
    
    // Do any additional setup after loading the view.
}

#pragma mark ---刷新界面,判断有没有用户---

- (void)shuaxin{
    if (_segVC.selectedSegmentIndex == 0) {
        self.since = @"0";
        [self requestData:COMMENT_New];
    }
}

- (void)login{
    LoginViewController *logVC = [[LoginViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:logVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

#pragma mark ---点击遮盖层---

- (void)click{
    [_keyBoard.textView resignFirstResponder];
}

#pragma mark ---键盘即将出现和消失的方法---

- (void)showBoardKey:(NSNotification *)no{
    CGRect keyBoard = [no.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyBoard.transform = CGAffineTransformMakeTranslation(0, -keyBoard.size.height);
    }];
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    view.tag = 201;
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [view addGestureRecognizer:pan];
    [_tableView addSubview:view];
}

- (void)hidKeyBoard:(NSNotification *)no{
    [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyBoard.transform = CGAffineTransformIdentity;
    }];
    UIView *view = [_tableView viewWithTag:201];
    [view removeFromSuperview];
}

#pragma mark ---表视图的协议---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.array[indexPath.row];
    CommentTableCell *cell = (CommentTableCell *)[FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.array[indexPath.row];
    NSString *string = model.content;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}  context:nil];
    return rect.size.height + 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_keyBoard.textView becomeFirstResponder];
}

#pragma mark ---分段控件的点击---

- (void)segClick:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 1) {
        self.since = @"0";
        [self requestData:COMMENT_Hot];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (_tableView.contentOffset.y < 0) {
                [_tableView.mj_header endRefreshing];
            }
            self.since = @"0";
            [self requestData:COMMENT_Hot];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestData:COMMENT_Hot];
        }];
    }else{
        self.since = @"0";
        [self requestData:COMMENT_New];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (_tableView.contentOffset.y < 0) {
                [_tableView.mj_header endRefreshing];
            }
            self.since = @"0";
            [self requestData:COMMENT_New];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestData:COMMENT_New];
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
