//
//  DiscoveryHotRenQiCellCollectCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotRenQiCellCollectCell.h"

@implementation DiscoveryHotRenQiCellCollectCell

- (void)setDataModel:(DiscoveryHotListModel *)model{
//    if (ScreenWidth == 320) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model.vertical_image_url stringByAppendingString:@".jpg"]]];
////    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.vertical_image_url]];
//    }
    self.imageView.userInteractionEnabled = YES;
    self.label.text = model.title;
    NSLog(@"%@",model.vertical_image_url);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

}

@end
