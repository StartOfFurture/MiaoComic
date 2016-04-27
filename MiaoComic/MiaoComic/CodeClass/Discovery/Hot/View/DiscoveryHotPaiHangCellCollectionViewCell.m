//
//  DiscoveryHotPaiHangCellCollectionViewCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotPaiHangCellCollectionViewCell.h"


@implementation DiscoveryHotPaiHangCellCollectionViewCell

- (void)setDataModel:(DiscoveryHotListModel *)model{
    [self.cover_imageView sd_setImageWithURL:[NSURL URLWithString:[ImageURL ImageStrWithString:model.cover_image_url]] placeholderImage:[UIImage imageNamed:@"find_change"]];
    NSLog(@"1111111%@",model.cover_image_url);
    self.titleLabel.text = model.title;
    self.nickNameLabel.text = model.nickname;
    self.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor;
    self.layer.borderWidth = 0.01;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
