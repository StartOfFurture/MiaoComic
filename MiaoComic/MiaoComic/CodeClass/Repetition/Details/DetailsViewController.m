//
//  DetailsViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailsModel.h"
#import "DetailsModelCell.h"
#import "DetailsCommentModelCell.h"
#import "DetailsHotModel.h"
#import "DetailsHotModelCell.h"

@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;// 漫画数据数组

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *collectButton;// 收藏按钮

@property (nonatomic, strong) NSMutableArray *commentArray;// 漫画热门评论数据数组

@property (nonatomic, assign) NSInteger comiCount;// 保存漫画的张数

@property (nonatomic, strong) UIButton *allButton;// 全集按钮

@end

@implementation DetailsViewController

// 懒加载
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

-(NSMutableArray *)commentArray{
    if (_commentArray == nil) {
        _commentArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _commentArray;
}



// 漫画数据
-(void)requestData{
    NSString *str = [DETAILCOMICURL stringByAppendingString:[NSString stringWithFormat:@"%@",_cid]];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@",str);
    [NetWorkRequestManager requestWithType:GET urlString:str dic:nil successful:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        DetailsModel *model = [[DetailsModel alloc] init];
        DetailsTopicModel *topicModel = [[DetailsTopicModel alloc] init];
        DetailsUserModel *userModel = [[DetailsUserModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dataDic[@"data"]];
        [topicModel setValuesForKeysWithDictionary:dataDic[@"data"][@"topic"]];
        [userModel setValuesForKeysWithDictionary:dataDic[@"data"][@"topic"][@"user"]];
        topicModel.user = userModel;
        model.topic = topicModel;
//        NSLog(@"images is %@",model.images);
        
        [self.dataArray addObject:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
    
}

// 加载评论数据
-(void)requestCommentData{
    NSString *str = [DETAILCOMICURLHOTCOMMENT stringByAppendingString:[NSString stringWithFormat:@"%@/hot_comments",_cid]];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@",str);
    [NetWorkRequestManager requestWithType:GET urlString:str dic:nil successful:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dataDic is %@",dataDic);
        NSArray *dataArray = dataDic[@"data"][@"comments"];
        for (NSDictionary *dic in dataArray) {
            DetailsHotModel *model = [[DetailsHotModel alloc] init];
            DetailsUserModel *userModel = [[DetailsUserModel alloc] init];
            
            [model setValuesForKeysWithDictionary:dic];
            [userModel setValuesForKeysWithDictionary:dic[@"user"]];
            model.user = userModel;
            [self.commentArray addObject:model];
        }
        
        // 回到主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"adads";
    // 加载漫画数据
    [self requestData];
    // 加载漫画热门数据
    [self requestCommentData];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 10, 10);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [back setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allButton.frame = CGRectMake(0, 0, 40, 20);
    [_allButton setTitle:@"全集" forState:UIControlStateNormal];
    _allButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_allButton setTitleColor:[UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_allButton];
    self.navigationItem.rightBarButtonItem = item;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DetailsHotModelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"hot"];
    [self.view addSubview:self.tableView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0 || self.commentArray.count == 0){
        return 0;
    } else {
        DetailsModel *model = self.dataArray[0];
        return model.images.count + 12;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count == 0 || self.commentArray.count == 0) {
        static NSString *kong = @"kong";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kong];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kong];
        }
        cell.textLabel.text = @"正在加载~~~~";
        
        return cell;
    } else {
        DetailsModel *model = self.dataArray[0];
        self.navigationItem.title = model.title;
        self.comiCount = model.images.count;
        
        if (indexPath.row == 0) {
            
            static NSString *headerIdentifier = @"header";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:headerIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.imageView.backgroundColor = [UIColor redColor];
            cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.topic.user.avatar_url]]];
            cell.imageView.layer.cornerRadius = 25;
            cell.imageView.layer.masksToBounds = YES;
            cell.textLabel.text = model.topic.user.nickname;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            collectButton.frame = CGRectMake(ScreenWidth - 40, 10, 30, 30);
            [collectButton addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
            [collectButton setBackgroundImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            self.collectButton = collectButton;
            [cell addSubview:collectButton];
           
            return cell;
            
        } else if(indexPath.row > 0 && indexPath.row < model.images.count){
            
            static NSString *imagesIdentifier = @"images";
            DetailsModelCell *cell = [tableView dequeueReusableCellWithIdentifier:imagesIdentifier];
            
            if (cell == nil) {
                cell = [[DetailsModelCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:imagesIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@",model.images[indexPath.row - 1]];
            
            [cell.comicImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            
            return cell;
        
        } else if (indexPath.row == model.images.count){
            static NSString *commentIdentifier = @"comment";
            DetailsCommentModelCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
            if (cell == nil) {
                cell = [[DetailsCommentModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.likeLabel.text = [NSString stringWithFormat:@"%@",model.likes_count];
            cell.likeLabel.font = [UIFont systemFontOfSize:12];
            cell.likeLabel.textAlignment = NSTextAlignmentCenter;
            
            [cell.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
            cell.commentLabel.text = @"热门评论";
            cell.commentLabel.font = [UIFont systemFontOfSize:12];
            cell.commentLabel.textAlignment = NSTextAlignmentCenter;
            
            [cell.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            cell.shareLabel.text = @"分享";
            cell.shareLabel.font = [UIFont systemFontOfSize:12];
            cell.shareLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.crossLine.backgroundColor = [UIColor grayColor];
            cell.verticalLine.backgroundColor = [UIColor grayColor];
            
            [cell.previousButton setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
            cell.previousLabel.text = @"上一篇";
            cell.previousLabel.font = [UIFont systemFontOfSize:12];
            
            [cell.nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
            cell.nextLabel.text = @"下一篇";
            cell.nextLabel.font = [UIFont systemFontOfSize:12];
            
            return cell;
        } else if (indexPath.row == _comiCount + 11) {
            static NSString *more = @"more";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:more];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:more];
            }
            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            moreButton.frame = CGRectMake(tableView.frame.size.width / 2 - 75, 10, 150, 40);
            [moreButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
            moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
//            moreButton.titleLabel.textColor = [UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0];
            [moreButton setTitleColor:[UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0] forState:UIControlStateNormal];
            moreButton.layer.cornerRadius = 10;
            moreButton.layer.borderWidth = 2;
            moreButton.layer.borderColor = [[UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0] CGColor];
//            moreButton.backgroundColor = [UIColor redColor];
            [cell addSubview:moreButton];
            return cell;
        } else {
//            NSLog(@"row %ld",(long)(indexPath.row - model.images.count));
            DetailsHotModel *hotModel = self.commentArray[indexPath.row - model.images.count - 1];
//            NSLog(@"hotModel is %@",hotModel);
            static NSString *hotIdentifier = @"hot";
            DetailsHotModelCell *cell = [tableView dequeueReusableCellWithIdentifier:hotIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            
            [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:hotModel.user.avatar_url]];
            cell.headerImage.layer.cornerRadius = 25;
            cell.headerImage.layer.masksToBounds = NO;
            cell.nicknameLabel.text = hotModel.user.nickname;
            cell.timeLabel.text = [GetTime getTimeFromSecondString:hotModel.created_at timeFormatType:Month_Day_Hour_Minute];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",hotModel.content];
            cell.likecount.text = [NSString stringWithFormat:@"%@",hotModel.likes_count];
            
            return cell;
        }
    }
    
}
-(void)collectClick{
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"collect_1"] forState:UIControlStateNormal];
    NSLog(@"收藏");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    } else if(indexPath.row == _comiCount - 1){
//        NSLog(@"modelImage %ld",(long)_comiCount);
//        NSLog(@"%ld",(long)indexPath.row);
        DetailsHotModel *model = self.commentArray[indexPath.row + 1 - _comiCount];
//        NSLog(@"model is %@",model);
        NSString *string = [NSString stringWithFormat:@"%@",model.content];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(tableView.bounds.size.width - 65, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}  context:nil];
        return rect.size.height + 70;
    } else if (indexPath.row == _comiCount + 11) {
        return 60;
    }
    return 200;
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
