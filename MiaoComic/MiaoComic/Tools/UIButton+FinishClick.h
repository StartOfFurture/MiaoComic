//
//  UIButton+FinishClick.h
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id(^FinishBlock)(id button);
@interface UIButton (FinishClick)

@property (nonatomic, copy)FinishBlock block;

@end
