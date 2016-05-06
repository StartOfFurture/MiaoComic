//
//  CompleteView.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CompleteView.h"


//static UIView *_headerView = nil;

@implementation CompleteView
#pragma mark - 导航栏 (返回、关注)




#pragma mark - 创建一个头视图

- (UIView *)createHeadViewWithURL:(NSURL *)URL {
    // 创建头视图
//    if (!_headerView) {
    
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight / 3)];
    [imageView sd_setImageWithURL:URL];
//    }
    
    return imageView;
}

#pragma mark - 第一组cell 的第一个row
- (UIView *)createSection_One_Row_One{

    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - 64, ScreenWidth, ScreenHeight / 3)];
        
        for (CGFloat i = 0, a1 = 1.0, Max = 255.0, height = 150.0; i < Max; i ++) {
            a1 = (0 + i) / 255.0;
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight / 3 - height / Max * i, ScreenWidth, height / Max)];
            view.backgroundColor=[UIColor colorWithRed:a1 green:a1 blue:a1 alpha:1 - i / Max];// 1 - i / Max
            [_headerView addSubview:view];
        }
        
        
        // 点赞图片
        UIImageView *likeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 160, ScreenHeight / 3 - 30, 20, 20)];
        likeImgV.image = [UIImage imageNamed:@"w_like"];
        [_headerView addSubview:likeImgV];
        // 点赞
        _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 135, ScreenHeight / 3 - 30, 45, 20)];
        _likeLabel.font = [UIFont systemFontOfSize:13];
        _likeLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:_likeLabel];
        
        // 评论图片
        UIImageView *commentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 80, ScreenHeight / 3 - 30, 20, 20)];
        commentImgV.image = [UIImage imageNamed:@"w_comment"];
        [_headerView addSubview:commentImgV];
        // 评论
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 55, ScreenHeight / 3 - 30, 45, 20)];
        _commentLabel.font = [UIFont systemFontOfSize:13];
        _commentLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:_commentLabel];
        
        // 漫画名
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, ScreenHeight / 3 - 30, ScreenWidth / 2, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:10];
        _titleLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:self.titleLabel];
        
    }
    
    return _headerView;
}

#pragma mark - 第二组cell 的头部视图（简介、内容、标记图片）
- (UIView *)createSection_Two_Header {
    // 头视图
    /**
     分组头视图只能设置高度
     CGRectMake( 0, 0, 0, height)
     这里的宽度是设置给 另外一个视图的
     */
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, ScreenWidth, 40)];
//    tableHeaderView.backgroundColor = [UIColor blackColor];
//    // 设置阴影，向上
//    tableHeaderView.layer.shadowColor = [UIColor blackColor].CGColor;
//    tableHeaderView.layer.shadowOffset = CGSizeMake(0, - 40);
//    tableHeaderView.layer.shadowRadius =  30 ;
//    tableHeaderView.layer.shadowOpacity = 1;
//
    // 简介按钮
    _introBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _introBtn.frame = CGRectMake(-1, 0, ScreenWidth / 2 + 1, 40);
    _introBtn.backgroundColor = [UIColor whiteColor];
    [_introBtn setTitle:@"简介" forState:UIControlStateNormal];
    [_introBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1] forState:UIControlStateNormal];
    _introBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _introBtn.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
    _introBtn.layer.borderWidth = 1;
    UIView *makeIntro = [[UIView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth / 2 + 3, 5)];
    makeIntro.backgroundColor = [UIColor clearColor];
    [_introBtn addSubview:makeIntro];
    
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
    UIView *makeContent = [[UIView alloc] initWithFrame:CGRectMake(1, 35, ScreenWidth / 2, 5)];
    makeContent.backgroundColor = [UIColor colorWithRed:0.77 green:0.38 blue:0.67 alpha:1];
    [_contentBtn addSubview:makeContent];
    
    [tableHeaderView addSubview:_contentBtn];
    
    
    __block CompleteView * completeView = self;
    
    // 简介 和 内容
    _introBtn.block = ^(id button){
        [(UIButton *)button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        makeIntro.backgroundColor = [UIColor colorWithRed:0.77 green:0.38 blue:0.67 alpha:1];
        [completeView.contentBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1] forState:UIControlStateNormal];
        makeContent.backgroundColor = [UIColor clearColor];

        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"introAndContent" object:nil userInfo:@{@"selectBtn":@"0"}];
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        
        return button;
    };
    
    _contentBtn.block = ^(id button){
        [(UIButton *)button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        makeContent.backgroundColor = [UIColor colorWithRed:0.77 green:0.38 blue:0.67 alpha:1];
        [completeView.introBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1] forState:UIControlStateNormal];
        makeIntro.backgroundColor = [UIColor clearColor];
        
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"introAndContent" object:nil userInfo:@{@"selectBtn":@"1"}];
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        return button;
    };
    
    
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
    _sortBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sortBtn setTitle:@"倒序" forState:UIControlStateNormal];
    [_sortBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1] forState:UIControlStateNormal];
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
        _contentTableV = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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
