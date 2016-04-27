//
//  DiscoveryHotGuanFangColletionCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotGuanFangColletionCell.h"
#import "DiscoveryHotListModel.h"
@implementation DiscoveryHotGuanFangColletionCell

- (void)setDataWithModel:(DiscoveryHotListModel *)model{
    [self.MyimageView sd_setImageWithURL:[NSURL URLWithString:[ImageURL ImageStrWithString:model.pic]]];
    NSLog(@"pic%@",model.pic);
    self.titleLabel.text = model.target_title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
