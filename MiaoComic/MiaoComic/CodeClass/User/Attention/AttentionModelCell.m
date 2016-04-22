//
//  AttentionModelCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AttentionModelCell.h"
#import "AttentionModel.h"

@implementation AttentionModelCell

-(void)setDataWithModel:(AttentionModel *)model{
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    self.titleLabel.text = model.title;
    self.nameLabel.text = model.user.nickname;
    self.LatestLabel.text = model.latest_comic_title;
}

@end
