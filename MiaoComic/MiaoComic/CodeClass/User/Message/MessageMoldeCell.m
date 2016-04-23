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
    self.nicknameLabel.text = model.user.nickname;
//    self.timeLabel.text = 
    
}
@end
