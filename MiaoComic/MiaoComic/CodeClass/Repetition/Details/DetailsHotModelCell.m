//
//  DetailsHotModelCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailsHotModelCell.h"
#import "DetailsHotModel.h"

@implementation DetailsHotModelCell


-(void)setDataWithModel:(DetailsHotModel *)model{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.user.avatar_url]];
    self.nicknameLabel.text = model.user.nickname;
    self.timeLabel.text = [GetTime getTimeFromSecondString:model.created_at timeFormatType:Month_Day_Hour_Minute];
    self.contentLabel.text = model.content;
    self.likecount.text = model.likes_count;
}

@end
