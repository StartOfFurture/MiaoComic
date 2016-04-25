//
//  AuthorView.h
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseView.h"

@interface AuthorView : BaseView
@property (nonatomic, strong) UIImageView *headerView;// 头部视图
@property (nonatomic, strong) UIImageView *headerImgV;// 头像视图
@property (nonatomic, strong) UILabel *nameLabel;// 姓名
@property (nonatomic, strong) UILabel *introLabel;// 作者的简介
@property (nonatomic, strong) UITableView *productionTableV;// 作品显示
@end
