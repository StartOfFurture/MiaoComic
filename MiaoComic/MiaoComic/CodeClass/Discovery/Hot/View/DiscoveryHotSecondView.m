//
//  DiscoveryHotSecondView.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotSecondView.h"
@implementation DiscoveryHotSecondView

- (void)setDataModel:(NSString *)string{
    self.leftView.layer.cornerRadius = 3;
    self.leftView.layer.masksToBounds = YES;
    if (![string isEqualToString:@"每周排行榜"]) {
        [_labaImage removeFromSuperview];
        [_chubanLabel removeFromSuperview];
    }
    _groupTitleLable.text = string;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
