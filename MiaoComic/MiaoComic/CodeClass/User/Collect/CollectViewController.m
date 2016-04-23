//
//  CollectViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectModel.h"
#import "CollectModelCell.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>

/**加载的位置*/
@property (nonatomic, assign) NSInteger offset;
/**加载的条数*/
@property (nonatomic, assign) NSInteger limit;
/**数据数组*/
@property (nonatomic, strong) NSMutableArray *listArray;

/**列表*/
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CollectViewController


-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArray;
}


-(void)requestData{
    NSString *str = [NSString stringWithFormat:COLLECTURL,@(_offset),@(_limit)];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetWorkRequestManager requestWithType:GET urlString:str dic:nil successful:^(NSData *data) {
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dic is %@",dicData);
        NSArray *dataArray = dicData[@"data"][@"comics"];
        for (NSDictionary *dic in dataArray) {
//            NSLog(@"dic is %@",dic);
            CollectModel *cModel = [[CollectModel alloc] init];
            CollectTopicModel *tModel = [[CollectTopicModel alloc] init];
            [cModel setValuesForKeysWithDictionary:dic];
            [tModel setValuesForKeysWithDictionary:dic[@"topic"]];
            cModel.topic = tModel;
            [self.listArray addObject:cModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    
    UISegmentedControl *segVC = [[UISegmentedControl alloc] initWithItems:@[@"我的收藏"]];
    segVC.tintColor = [UIColor clearColor];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]};
    [segVC setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.navigationItem.titleView = segVC;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    _offset = 0;
    _limit = 20;
    [self requestData];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CollectModel class])];
    [self.view addSubview:self.tableView];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectModel *model = self.listArray[indexPath.row];
    
    CollectModelCell *cell = (CollectModelCell *)[FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
