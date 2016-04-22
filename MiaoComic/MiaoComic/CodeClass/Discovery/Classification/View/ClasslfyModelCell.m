//
//  ClasslfyModelCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ClasslfyModelCell.h"
#import "ClassifyModel.h"
@implementation ClasslfyModelCell

- (void)setDataWithModel:(ClassifyModel *)model{
    self.iconView.layer.cornerRadius = 40;
    self.iconView.layer.masksToBounds = YES;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.titleLable.text = model.title;
}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        self.iconView.layer.cornerRadius = 20;
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.iconView.layer.cornerRadius = 20;
//    }
//    return self;
//}

@end
