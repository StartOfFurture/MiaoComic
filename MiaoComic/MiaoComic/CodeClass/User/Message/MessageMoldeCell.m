//
//  MessageMoldeCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "MessageMoldeCell.h"
#import "MessageModel.h"

@implementation MessageMoldeCell

-(void)setDataWithModel:(MessageModel *)model{
    self.headerImage.layer.cornerRadius = 25;
    self.headerImage.layer.masksToBounds = YES;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.user.avatar_url]];
    self.nicknameLabel.text = [NSString stringWithFormat:@"%@", model.user.nickname];
//    self.nicknameLabel.backgroundColor = [UIColor redColor];
//    NSLog(@"self.nicknameLabel%@",self.nicknameLabel);
    self.timeLabel.text = [GetTime getTimeFromSecondString:model.created_at timeFormatType:@"MM-dd HH:mm"];
    [self.sendButton setTitle:@"回复" forState:UIControlStateNormal];
    self.contentLabel.text = model.content;
    self.myContentLabel.text = model.tcontent;
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.target_comic.cover_image_url]];
    self.titleLaebl.text = model.target_comic.title;
    self.nameLabel.text = model.target_comic.topic_title;
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
