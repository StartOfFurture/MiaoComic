//
//  HomeCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "HomeCell.h"
#import "ComicsModel.h"

@interface HomeCell ()
//@property (nonatomic, strong) UILabel *typeLabel;// 漫画类型
//@property (nonatomic, strong) UILabel *comicNameLabel;// 漫画名
//@property (nonatomic, strong) UIImageView *authorImgV;// 作者的标识符图片
//@property (nonatomic, strong) UILabel *authorNameLabel;// 作者名
//@property (nonatomic, strong) UIImageView *coverImgV;//封面图片
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;// 漫画类型
@property (strong, nonatomic) IBOutlet UILabel *comicNameLabel;// 漫画名
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;// 作者名
@property (strong, nonatomic) IBOutlet UILabel *thisComicTitleLabel;// 本集漫画名
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;// 喜欢数
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;// 评论数
@property (strong, nonatomic) IBOutlet UIImageView *coverImgV;// 封面



@end


@implementation HomeCell


- (void)setDataWithModel:(BaseModel *)model {
    ComicsModel *comicsModel = (ComicsModel *)model;
    _typeLabel.text = comicsModel.label_text;
    _comicNameLabel.text = comicsModel.topicModel.title;
    _authorNameLabel.text = comicsModel.authorUserInfo.nickname;
    _thisComicTitleLabel.text = comicsModel.title;
    _likeLabel.text = comicsModel.likes_count;
    _commentLabel.text = comicsModel.comments_count;
//    _coverImgV.image = [UIImage ]
}

// 布局
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
