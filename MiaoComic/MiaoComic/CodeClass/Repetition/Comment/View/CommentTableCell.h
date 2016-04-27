//
//  CommentTableCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CommentTableCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cover_imageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *yubaoButton;
@property (strong, nonatomic) IBOutlet UIButton *zanButton;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *huifuButton;


@end
