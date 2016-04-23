//
//  MessageViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "MessageComicModel.h"
#import "MessageUserModel.h"
#import "MessageMoldeCell.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageViewController

-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArray;
}


-(void)requestData {
    NSString *str = [NSString stringWithFormat:MESSAGEURL,@"0"];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetWorkRequestManager requestWithType:GET urlString:str dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArray = dic[@"data"][@"comments"];
        
//        NSLog(@"dataArray is %@",dataArray);
        for (NSDictionary *dic in dataArray) {
            NSLog(@"dic is %@",dic);
            MessageModel *model = [[MessageModel alloc] init];
            MessageComicModel *cModel = [[MessageComicModel alloc] init];
            MessageUserModel *uModel = [[MessageUserModel alloc] init];
            
            
            [model setValuesForKeysWithDictionary:dic];
            
            [cModel setValuesForKeysWithDictionary:dic[@"target_comic"]];
            [uModel setValuesForKeysWithDictionary:dic[@"user"]];
            model.tcontent = dic[@"target_comment"][@"content"];
//            NSLog(@"%@",model.tcontent);
            model.target_comic = cModel;
            model.user = uModel;
            
            [self.listArray addObject:model];
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
    self.view.backgroundColor = [UIColor blueColor];
    
    UISegmentedControl *segVC = [[UISegmentedControl alloc] initWithItems:@[@"我的消息"]];
    segVC.tintColor = [UIColor clearColor];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]};
    [segVC setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.navigationItem.titleView = segVC;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    [self requestData];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageModel class])];
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.listArray[indexPath.row];
//    NSLog(@"model is %@",model.user.nickname);
    MessageMoldeCell *cell = (MessageMoldeCell *)[FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
    
    [cell setDataWithModel:model];

    return cell;
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
