//
//  CollectModelCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CollectModelCell.h"
#import "CollectModel.h"

@implementation CollectModelCell

-(void)setDataWithModel:(CollectModel *)model{
    [self.coveImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    self.titleLabel.text = model.title;
    self.nameLabel.text = model.topic.title;
}
@end
