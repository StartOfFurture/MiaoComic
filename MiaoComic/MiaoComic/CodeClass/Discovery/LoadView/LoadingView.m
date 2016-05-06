//
//  LoadingView.m
//  MiaoComic
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()

@property (nonatomic, strong)NSMutableArray *array;

@end

@implementation LoadingView

- (NSMutableArray *)array{
    if (_array == nil) {
        _array = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _array;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.array removeAllObjects];
    self.MyImageView.frame = CGRectMake(50, 100, ScreenWidth - 100, ScreenWidth - 100);
    self.LabelState.frame = CGRectMake(50, 100 + ScreenWidth - 100 + 20, ScreenWidth - 100, 22);
    for (int i = 1; i < self.countImage + 1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:self.nameImage,i]];
//        NSLog(@"%@",image);
        [self.array addObject:image];
    }
    self.MyImageView.animationImages = self.array;
    self.MyImageView.animationDuration = self.timeInter;
    self.MyImageView.animationRepeatCount = MAXFLOAT;
    [self.MyImageView startAnimating];
}

- (void)createAnimationWithCountImage:(NSInteger)countImage nameImage:(NSString *)nameImage timeInter:(NSTimeInterval)timeInterval labelText:(NSString *)text{
    self.countImage = countImage;
    self.nameImage = nameImage;
    self.timeInter = timeInterval;
    self.LabelState.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
