//
//  HomeCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;// 漫画类型
@property (strong, nonatomic) IBOutlet UIButton *comicNameBtn;// 漫画名
@property (strong, nonatomic) IBOutlet UIButton *authorNameBtn;// 作者名
@property (strong, nonatomic) IBOutlet UIButton *thisComicTitleBtn;// 本集漫画名
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;// 喜欢数
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;// 评论数
@property (strong, nonatomic) IBOutlet UIImageView *coverImgV;// 封面

@end
