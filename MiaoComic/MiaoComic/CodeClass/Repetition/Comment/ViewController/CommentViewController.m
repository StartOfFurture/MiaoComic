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
#import "LoadingView.h"

//键盘已经出现
static dispatch_once_t onceTock;
//键盘即将出现
static dispatch_once_t onceTock1;
@interface CommentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;//表视图
@property (nonatomic, copy)NSString *since;//从哪里开始加载
@property (nonatomic, strong)NSMutableArray *array;//存放数据的数组

@property (nonatomic, strong)ReadKeyBoard *keyBoardS;//输入框
@property (nonatomic, strong)UISegmentedControl *segVC;//标题

@property (nonatomic, strong)UIView *blackView;//遮盖层

@property (nonatomic, strong)LoadingView *loadingView;//正在加载视图

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
        [_loadingView removeFromSuperview];
        static dispatch_once_t onceToken2;
        dispatch_once(&onceToken2, ^{
            if (self.array.count != 0) {
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self requestData:COMMENT_New];
                }];
            }
        });
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingView removeFromSuperview];
            _loadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
            [_loadingView createAnimationWithCountImage:20 nameImage:@"630f0cdb690cf448f97a0126dfadf414－%d（被拖移）.tiff" timeInter:2 labelText:@"哎呀！网络出问题了？"];
            [self.view addSubview:_loadingView];
        });
        NSLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.since = @"0";
//    self.ID = @"11857";
    
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
    //这个时候什么都不会显示
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    [self.view addSubview:_tableView];
    
    //输入框的添加
    _keyBoardS = [[ReadKeyBoard alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    _keyBoardS.ID = self.ID;
    _keyBoardS.isHuiFu = NO;
//    //键盘即将出现
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBoardKey:) name:UIKeyboardWillShowNotification  object:nil];
//    //键盘即将消失
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    [self.view addSubview:_keyBoardS];
    
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"shuaxin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"nouser" object:nil];
    
    //请求数据
    [self requestData:COMMENT_New];
    
    _loadingView = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
    [_loadingView createAnimationWithCountImage:4 nameImage:@"6bed450854904c8dd50d5b2553f62cf5－%d（被拖移）.tiff" timeInter:0.5 labelText:@"正在加载中～～～"];
    [self.view addSubview:_loadingView];
    
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
    [_keyBoardS.textView resignFirstResponder];
    LoginViewController *logVC = [[LoginViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:logVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

#pragma mark ---点击遮盖层---

- (void)click11{
    [_keyBoardS.textView resignFirstResponder];
}

#pragma mark ---键盘即将出现和消失的方法---

- (void)showBoardKey1:(NSNotification *)no{
    CGRect keyBoard = [no.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f",keyBoard.size.height);
    if (_blackView == nil && keyBoard.size.height!=0) {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.contentOffset.y, self.view.frame.size.width, self.view.frame.size.height)];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0;
        
        [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.keyBoardS.transform = CGAffineTransformMakeTranslation(0, -keyBoard.size.height);
            _blackView.alpha = 0.5;
        }];
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click11)];
        [_blackView addGestureRecognizer:pan];
        _tableView.scrollEnabled = NO;
        [_tableView addSubview:_blackView];
    }
    NSLog(@"键盘弹出");
}

- (void)hidKeyBoard1:(NSNotification *)no{
        [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.keyBoardS.transform = CGAffineTransformIdentity;
            _blackView.alpha = 0;
        }];
        _tableView.scrollEnabled = YES;
        _keyBoardS.plahchLabel.text = @"来吐槽把～～";
        _keyBoardS.textView.text = @"";
    //当视图消失的时候，回复的bool变成NO
        _keyBoardS.isHuiFu = NO;
        [_blackView removeFromSuperview];
    _blackView = nil;
    
    //防止第一次弹出键盘的时候出不来
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    dispatch_once(&onceTock1, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBoardKey1:) name:UIKeyboardWillShowNotification  object:nil];
    });
    NSLog(@"键盘消失");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"11111");
    if (_blackView != nil) {
        [_blackView removeFromSuperview];
        _blackView = nil;
    }
    
    //键盘已经出现
    NSLog(@"onceTockonceTock%ld",onceTock);
    dispatch_once(&onceTock, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBoardKey1:) name:UIKeyboardDidShowNotification  object:nil];
    });
    
    //键盘即将消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidKeyBoard1:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    onceTock = 0;
    onceTock1 = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark ---表视图的协议---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.array[indexPath.row];
    CommentTableCell *cell = (CommentTableCell *)[FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
    cell.keyBoard = _keyBoardS;
    //如果使用父类的直接赋值的话，cell.keyBoard还没有赋值为空，所以重新写一个自己的赋值方法,让父类的赋值方法，空实现
    [cell setDataWithModel1:model];
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
    CommentModel *model = self.array[indexPath.row];
    _keyBoardS.plahchLabel.text = [NSString stringWithFormat:@"回复@%@",model.nickname];
    [_keyBoardS.textView becomeFirstResponder];
    _keyBoardS.huifuID = [NSString stringWithFormat:@"%@",model.ID];
    _keyBoardS.huifuName = model.nickname;
    _keyBoardS.isHuiFu = YES;
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
