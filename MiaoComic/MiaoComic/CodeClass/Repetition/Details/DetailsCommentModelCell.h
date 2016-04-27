//
//  DetailsCommentModelCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DetailsCommentModelCell : BaseTableViewCell

@property (nonatomic, strong) UIButton *likeButton;// 点赞按钮
@property (nonatomic, strong) UILabel *likeLabel;// 点赞文本
@property (nonatomic, strong) UIButton *commentButton;// 评论按钮
@property (nonatomic, strong) UILabel *commentLabel;// 评论文本
@property (nonatomic, strong) UIButton *shareButton;// 分享按钮
@property (nonatomic, strong) UILabel *shareLabel;// 分享文本
@property (nonatomic, strong) UIView *crossLine;// 横线
@property (nonatomic, strong) UIView *verticalLine;// 纵线
@property (nonatomic, strong) UIButton *previousButton;// 上一篇按钮
@property (nonatomic, strong) UILabel *previousLabel;// 上一篇文本
@property (nonatomic, strong) UIButton *nextButton;// 下一篇按钮
@property (nonatomic, strong) UILabel *nextLabel;// 下一篇文本


@end
