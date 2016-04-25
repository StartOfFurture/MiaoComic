//
//  AuthorView.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AuthorView.h"

@implementation AuthorView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // 创建头视图
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight / 3 - 30)];
        [self addSubview:_headerView];
        
        //实现模糊效果
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = _headerView.bounds;
        visualEffectView.alpha = 1.0;
        [_headerView addSubview:visualEffectView];

        //头像视图
        _headerImgV = [[UIImageView alloc] init];
        _headerImgV.frame = CGRectMake(ScreenWidth / 2 - 40, ScreenHeight / 6 - 80, 80, 80);
        _headerImgV.layer.cornerRadius= 40;
        _headerImgV.layer.masksToBounds = YES;//
        _headerImgV.userInteractionEnabled = YES;// 打开用户交互

        [_headerImgV sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"pheader"]];
        [_headerView addSubview:_headerImgV];
        
        // 昵称Lable
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight / 6 + 10, ScreenWidth, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:_nameLabel];
        
        // 作者简介
        _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight / 6 + 40, ScreenWidth, 20)];
        _introLabel.textAlignment = NSTextAlignmentCenter;
        _introLabel.font = [UIFont systemFontOfSize:14];
        _introLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:_introLabel];
        
        // 分割线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,ScreenHeight / 3 - 30, ScreenWidth, 10)];
        lineLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1];
        [self addSubview:lineLabel];
        

        
        UILabel *productionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ScreenHeight / 3 - 15, ScreenWidth, 20)];
        productionLabel.text = @"TA的作品";
        productionLabel.tintColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
        
        productionLabel.font = [UIFont systemFontOfSize:15];
    
        [self addSubview:productionLabel];
        
        _productionTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight / 3 + 15, ScreenWidth, ScreenHeight / 3 * 2 - 15) style:UITableViewStylePlain];
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:_productionTableV];

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
