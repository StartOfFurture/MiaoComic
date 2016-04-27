//
//  CompleteView.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CompleteView.h"

@implementation CompleteView
#pragma mark - 导航栏 (返回、关注)

#pragma mark - 第一组cell 的第一个row
- (UIView *)createSection_One_Row_One {
    // 创建头视图
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight / 3)];
    
    // 点赞图片
    UIImageView *likeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 165, ScreenHeight / 3 - 30, 20, 20)];
    likeImgV.image = [UIImage imageNamed:@"w_like"];
    [_headerView addSubview:likeImgV];
    // 点赞
    _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 140, ScreenHeight / 3 - 30, 50, 20)];
    _likeLabel.font = [UIFont systemFontOfSize:13];
    _likeLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_likeLabel];
    
    // 评论图片
    UIImageView *commentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 85, ScreenHeight / 3 - 30, 20, 20)];
    commentImgV.image = [UIImage imageNamed:@"w_comment"];
    [_headerView addSubview:commentImgV];
    // 评论
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 60, ScreenHeight / 3 - 30, 50, 20)];
    _commentLabel.font = [UIFont systemFontOfSize:13];
    _commentLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_commentLabel];
    
    return _headerView;
}

#pragma mark - 第二组cell 的头部视图（简介、内容、标记图片）
- (UIView *)createSection_Two_Header {
    // 头视图
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(- 30, 0, ScreenWidth + 60, 40)];
    tableHeaderView.backgroundColor = [UIColor blackColor];
    // 设置阴影，向上
    tableHeaderView.layer.shadowColor = [UIColor blackColor].CGColor;
    tableHeaderView.layer.shadowOffset = CGSizeMake(0, - 40);
    tableHeaderView.layer.shadowRadius =  30 ;
    tableHeaderView.layer.shadowOpacity = 1;
    
    // 简介按钮
    _introBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _introBtn.frame = CGRectMake(- 1, 0, ScreenWidth / 2 + 1, 40);
    _introBtn.backgroundColor = [UIColor whiteColor];
    [_introBtn setTitle:@"简介" forState:UIControlStateNormal];
    [_introBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1] forState:UIControlStateNormal];
    _introBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _introBtn.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
    _introBtn.layer.borderWidth = 1;
    [tableHeaderView addSubview:_introBtn];
    
    // 内容按钮
    _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contentBtn.frame = CGRectMake(ScreenWidth / 2, 0, ScreenWidth / 2 + 1, 40);
    _contentBtn.backgroundColor = [UIColor whiteColor];
    [_contentBtn setTitle:@"内容" forState:UIControlStateNormal];
    [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _contentBtn.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
    _contentBtn.layer.borderWidth = 1;
    [tableHeaderView addSubview:_contentBtn];
    
    return tableHeaderView;
}
#pragma mark - 第二组cell 的第一个row（作品列表、排序按钮）
- (UIView *)createSection_Two_Row_One {

    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    // 作品列表
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth / 2, 40)];
    contentLabel.text = @"作品列表";
    contentLabel.tintColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
    contentLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:contentLabel];
    
    // 排序
    _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sortBtn.frame = CGRectMake(ScreenWidth - 50 , 0, 30, 40);
    _sortBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sortBtn setTitle:@"倒序" forState:UIControlStateNormal];
    [_sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:_sortBtn];
    
    // 分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1];
    [view addSubview:lineLabel];
    return view;
}

#pragma mark - 漫画名 -

#pragma mark - 背景图片-
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // 表格
        _contentTableV = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _contentTableV.backgroundColor = [UIColor whiteColor];

        
        [self addSubview:_contentTableV];
        
//        _contentTableV.tableHeaderView = tableHeaderView;
//
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
