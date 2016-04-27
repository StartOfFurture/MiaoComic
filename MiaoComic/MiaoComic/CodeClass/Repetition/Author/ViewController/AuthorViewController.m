//
//  AuthorViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AuthorViewController.h"
#import "AuthorView.h"
#import "AuthorModel.h"
#import "AuthorTopicModel.h"
#import "FactoryTableViewCell.h"
#import "BaseModel.h"

@interface AuthorViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView *headerView;// 头像视图
@property (nonatomic, strong) UITableView *productionTableV;// 作品简介的表格
@property (nonatomic, strong) AuthorView *authorView;
@property (nonatomic, strong) NSMutableArray *productionArray;// 作品简介的数组
@property (nonatomic, strong) UITableViewCell *makeCell;// 标记cell是否重用

@end

@implementation AuthorViewController

- (NSMutableArray *)productionArray {
    if (_productionArray == nil) {
        self.productionArray = [NSMutableArray array];
    }
    return _productionArray;
}

- (void)request {
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"%@%@", AUTHORURL,self.ids] dic:@{} successful:^(NSData *data) {
        NSDictionary *dateDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
   
        NSArray *topicsArray = dateDic[@"data"][@"topics"];
        
        for (NSDictionary *dic in topicsArray) {
            AuthorTopicModel *topicModel = [[AuthorTopicModel alloc] init];
            [topicModel setValuesForKeysWithDictionary:dic];
            [self.productionArray addObject:topicModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            NSString *headImgString = dateDic[@"data"][@"avatar_url"];
            // 判断，如果图片以.w结尾，去掉.w
            if ([headImgString hasSuffix:@".w"]) {
                headImgString = [headImgString substringToIndex:headImgString.length - 2];
            }
        
            [_authorView.headerView sd_setImageWithURL:[NSURL URLWithString:headImgString]];
            
            [_authorView.headerImgV sd_setImageWithURL:[NSURL URLWithString:headImgString]];
            
            _authorView.nameLabel.text = dateDic[@"data"][@"nickname"];
            _authorView.introLabel.text = dateDic[@"data"][@"intro"];
            
            [self.authorView.productionTableV reloadData];
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"%@", error);
    }];

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
    
    [self.view addSubview:backBtn];
}

- (void)loadView {
    [super loadView];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    
    _authorView = [[AuthorView alloc] initWithFrame:CGRectMake(0, ScreenHeight / 3, ScreenWidth, ScreenHeight / 3 * 2)];
    self.view = _authorView;
    
    self.authorView.productionTableV.delegate = self;
    self.authorView.productionTableV.dataSource = self;
    [self.authorView.productionTableV registerNib:[UINib nibWithNibName:@"AuthorCell" bundle:nil] forCellReuseIdentifier:@"AuthorTopicModel"];
    
    self.authorView.productionTableV.scrollEnabled = NO;//设置tableview 不能滚动
    
    // 创建返回按钮
    [self createBackBtn];
    
    [self request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuthorTopicModel *authormodel = self.productionArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell creatTableViewCell:authormodel tableView:tableView indexPath:indexPath];
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.bounces = NO;// 去掉回弹效果
    tableView.showsVerticalScrollIndicator = NO;
    
    CGFloat y = cell.frame.origin.y;// cell的y轴
    CGFloat height = cell.frame.size.height;
    CGFloat tableViewHeight = tableView.frame.size.height;
    if (y + height > tableViewHeight) {// 当最后一个cell超出表格，可以滚动
        tableView.scrollEnabled = YES;
    }

    return cell;
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
