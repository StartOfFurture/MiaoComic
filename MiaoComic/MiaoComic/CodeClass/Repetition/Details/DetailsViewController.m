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
#import "CommentViewController.h"
#import "CompleteViewController.h"
#import "ReadKeyBoard.h"

@class DetailsViewController;

@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;// 漫画数据数组

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *collectButton;// 收藏按钮

@property (nonatomic, strong) NSMutableArray *commentArray;// 漫画热门评论数据数组

@property (nonatomic, assign) NSInteger comiCount;// 保存漫画的张数

@property (nonatomic, strong) UIButton *allButton;// 全集按钮

@property (nonatomic, copy) NSString *tid;// 保存本本漫画的id
@property (nonatomic, copy) NSString *pid;// 前一篇漫画的id
@property (nonatomic, copy) NSString *nid;// 后一篇漫画的id

@property (nonatomic, strong) ReadKeyBoard *keyBoard;

@end

@implementation DetailsViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.tableView reloadData];
    
}

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
    // 加载漫画数据
    [self requestData];
    // 加载漫画热门数据
    [self requestCommentData];

    self.navigationController.hidesBarsOnSwipe = YES;//滚动时隐藏导航栏
    
    // 返回按钮
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 10, 10);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    // 全集按钮测创建
    _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allButton.frame = CGRectMake(0, 0, 40, 20);
    [_allButton setTitle:@"全集" forState:UIControlStateNormal];
    _allButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_allButton setTitleColor:[UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0] forState:UIControlStateNormal];
    [_allButton addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_allButton];
    self.navigationItem.rightBarButtonItem = item;
    
    // 创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DetailsHotModelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"hot"];
    [self.view addSubview:self.tableView];
    
    // 输入框的添加
    _keyBoard = [[ReadKeyBoard alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    _keyBoard.ID = self.cid;
    // 键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBoardKey:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘即将消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidKeyBoard:) name:UIKeyboardDidHideNotification object:nil];
    [self.view addSubview:_keyBoard];
}

#pragma mark- 键盘方法
- (void)showBoardKey:(NSNotification *)no{
    CGRect keyBoard = [no.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyBoard.transform = CGAffineTransformMakeTranslation(0, -keyBoard.size.height);
    }];
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    view.tag = 201;
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyClick)];
    [view addGestureRecognizer:pan];
    [_tableView addSubview:view];
}

- (void)keyClick{
    [_keyBoard.textView resignFirstResponder];
}

- (void)hidKeyBoard:(NSNotification *)no{
    [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyBoard.transform = CGAffineTransformIdentity;
    }];
    UIView *view = [_tableView viewWithTag:201];
    [view removeFromSuperview];
}

#pragma mark- tableView协议

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0 || self.commentArray.count == 0){
        return 0;
    } else {
        DetailsModel *model = self.dataArray[0];
        return model.images.count + 13;
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
        self.comiCount = model.images.count;// 保存漫画的张数
        self.navigationItem.title = model.title;// 保存头标题
        self.tid = model.topic.tid;// 保存本漫画的id
        self.pid = model.previous_comic_id;
        self.nid = model.next_comic_id;

        // 作者信息
        if (indexPath.row == 0) {
            static NSString *headerIdentifier = @"header";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:headerIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            // 作者信息
            cell.imageView.backgroundColor = [UIColor redColor];
            cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.topic.user.avatar_url]]];
            cell.imageView.layer.cornerRadius = 25;
            cell.imageView.layer.masksToBounds = YES;
            cell.textLabel.text = model.topic.user.nickname;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            // 收藏按钮
            UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            collectButton.frame = CGRectMake(ScreenWidth - 40, 10, 30, 30);
            [collectButton addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
            [collectButton setBackgroundImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            self.collectButton = collectButton;
            [cell addSubview:collectButton];
           
            return cell;
            
            // 漫画图片
        } else if(indexPath.row > 0 && indexPath.row <= model.images.count){
            static NSString *imagesIdentifier = @"images";
            DetailsModelCell *cell = [tableView dequeueReusableCellWithIdentifier:imagesIdentifier];
            
            if (cell == nil) {
                cell = [[DetailsModelCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:imagesIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@",model.images[indexPath.row - 1]];
            
            [cell.comicImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            return cell;
        
            // 上一页下一页
        } else if (indexPath.row == model.images.count + 1){
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
            [cell.previousButton addTarget:self action:@selector(previousClick) forControlEvents:UIControlEventTouchUpInside];
            cell.previousLabel.text = @"上一篇";
            cell.previousLabel.font = [UIFont systemFontOfSize:12];
            
            [cell.nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
            [cell.nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
            cell.nextLabel.text = @"下一篇";
            cell.nextLabel.font = [UIFont systemFontOfSize:12];
            
            return cell;
            
            // 更多评论
        } else if (indexPath.row == model.images.count + 12) {
            static NSString *more = @"more";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:more];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:more];
            }
            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            moreButton.frame = CGRectMake(tableView.frame.size.width / 2 - 75, 10, 150, 40);
            [moreButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
            moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [moreButton addTarget:self action:@selector(moreComment) forControlEvents:UIControlEventTouchUpInside];
            [moreButton setTitleColor:[UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0] forState:UIControlStateNormal];
            moreButton.layer.cornerRadius = 10;
            moreButton.layer.borderWidth = 2;
            moreButton.layer.borderColor = [[UIColor colorWithHue:225/255.0 saturation:155/255.0 brightness:192/255.0 alpha:255/255.0] CGColor];
            [cell addSubview:moreButton];
            return cell;
            
            // 热门评论10条
        } else {
            DetailsHotModel *hotModel = self.commentArray[indexPath.row - model.images.count - 2];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_keyBoard.textView becomeFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    } else if(indexPath.row == _comiCount + 1){
        return 200;
    } else if (indexPath.row == _comiCount + 12) {
        return 90;
    } else if(indexPath.row > _comiCount + 1 && indexPath.row <= _comiCount + 11){
        DetailsHotModel *model = self.commentArray[indexPath.row  - _comiCount - 2];
        NSString *string = model.content;
        CGRect rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}  context:nil];
        return rect.size.height + 110;
    }
    return ScreenWidth * 0.78;
}

#pragma mark- 收藏
-(void)collectClick{
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"collect_1"] forState:UIControlStateNormal];
    NSLog(@"收藏");
}


#pragma mark- 查看更多评论
-(void)moreComment{
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    UINavigationController *naVc = [[UINavigationController alloc] initWithRootViewController:commentVC];
    commentVC.ID = _cid;
    [self presentViewController:naVc animated:YES completion:nil];
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark- 按钮方法

// 全集
-(void)allClick{
    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
    completeVC.ids = _tid;
    [self.navigationController pushViewController:completeVC animated:YES];
}

// 上一篇
-(void)previousClick{
    DetailsViewController *detailVC = [[DetailsViewController alloc] init];
    detailVC.cid = _pid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 下一篇
-(void)nextClick{
    DetailsViewController *detailVC = [[DetailsViewController alloc] init];
    detailVC.cid = _nid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
