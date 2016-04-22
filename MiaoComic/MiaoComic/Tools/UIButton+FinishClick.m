//
//  UIButton+FinishClick.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "UIButton+FinishClick.h"
#import <objc/runtime.h>

static const char *UIButtonClick;
@implementation UIButton (FinishClick)

- (void)setBlock:(FinishBlock)block{
    //为系统的类添加属性，并且为他写set。get方法必须有下面下个方法
    objc_setAssociatedObject(self, &UIButtonClick, block, OBJC_ASSOCIATION_COPY_NONATOMIC);//执行set方法的时候调用
    
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (FinishBlock)block{
    return objc_getAssociatedObject(self, &UIButtonClick);//执行get方法的时候调用
}

- (void)click{
    if (self.block) {
        self.block(self);
    }
}

@end
