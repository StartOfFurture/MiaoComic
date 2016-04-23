//
//  AttentionViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AttentionViewController.h"
#import "AttentionModel.h"
#import "AttentionModelCell.h"

@interface AttentionViewController ()<UITableViewDataSource,UITableViewDelegate>
/**加载的位置*/
@property (nonatomic, assign) NSInteger offset;
/**加载的条数*/
@property (nonatomic, assign) NSInteger limit;

/**数据数组*/
@property (nonatomic, strong) NSMutableArray *dataArray;


/**列表*/
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AttentionViewController


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}


-(void)requestData{
    NSString *str = [NSString stringWithFormat:ATTENTIONURL,@(_offset),@(_limit)];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetWorkRequestManager requestWithType:GET urlString:str dic:nil successful:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArray = dataDic[@"data"][@"topics"];
        NSLog(@"%@",dataArray);
        for (NSDictionary *dic in dataArray) {
            NSLog(@"dic %@",dic);
            AttentionModel *aModel = [[AttentionModel alloc] init];
            UserModel *userModel = [[UserModel alloc] init];
            [aModel setValuesForKeysWithDictionary:dic];
            [userModel setValuesForKeysWithDictionary:dic[@"user"]];
            aModel.user = userModel;
            [self.dataArray addObject:aModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSLog(@"dataArray %@",self.dataArray);
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UISegmentedControl *segVC = [[UISegmentedControl alloc] initWithItems:@[@"我的关注"]];
    segVC.tintColor = [UIColor clearColor];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]};
    [segVC setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.navigationItem.titleView = segVC;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    // 数据请求
    _limit = 20;
    _offset = 0;
    [self requestData];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AttentionModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AttentionModel class])];
    [self.view addSubview:self.tableView];
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionModel *model = self.dataArray[indexPath.row];
//    NSLog(@"model is %@",model);
    AttentionModelCell *cell = (AttentionModelCell *)[FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
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
