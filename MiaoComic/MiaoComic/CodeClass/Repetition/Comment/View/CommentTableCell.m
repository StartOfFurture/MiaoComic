//
//  CommentTableCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CommentTableCell.h"
#import "CommentModel.h"

@implementation CommentTableCell

- (void)setDataWithModel:(CommentModel *)model{
    self.cover_imageView.layer.cornerRadius = 17.5;
    self.cover_imageView.layer.masksToBounds = YES;
    [self.cover_imageView sd_setImageWithURL:[NSURL URLWithString:[ImageURL ImageStrWithString:model.avatar_url]]];
    self.nickNameLabel.text = model.nickname;
    self.timeLabel.text = [NSString stringWithString:[GetTime getTimeFromSecondString:model.created_at timeFormatType:Month_Day_Hour_Minute]];
    self.contentLabel.text = model.content;
    if ([[NSString stringWithFormat:@"%@",model.likes_count] isEqualToString:@"0"]) {
        self.likeCountLabel.text = @"";
    }else{
        self.likeCountLabel.text = [NSString stringWithFormat:@"%@",model.likes_count];
    }
    NSLog(@"%@",model.is_liked);
//    model.is_liked = @"1";
    if ([[NSString stringWithFormat:@"%@",model.is_liked] isEqualToString:@"1"]) {
        [self.zanButton setBackgroundImage:[[UIImage imageNamed:@"zan-change"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
