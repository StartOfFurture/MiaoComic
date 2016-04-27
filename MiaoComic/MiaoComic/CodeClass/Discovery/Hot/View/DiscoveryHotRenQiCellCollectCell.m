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
#pragma mark -----设备不同的时候图片出不来------
//    if (ScreenWidth == 320) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model.vertical_image_url stringByAppendingString:@".jpg"]]];
////    }else{
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.vertical_image_url]];
//    }
    
#pragma mark -----图片格式不同的时候图片出不来------
    
    NSString *string = model.vertical_image_url;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[ImageURL ImageStrWithString:string]]];
    self.imageView.userInteractionEnabled = YES;
    self.label.text = model.title;
    NSLog(@"%@",model.vertical_image_url);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 30)];
    view.backgroundColor = [UIColor blackColor];
    
    view.layer.shadowOffset = CGSizeMake(0, - 15);
    view.layer.shadowRadius = 15;//阴影半径
    view.layer.shadowOpacity = 1;//不透明度
    [self.contentView addSubview:view];
    [self.contentView addSubview:self.label];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

}

@end
