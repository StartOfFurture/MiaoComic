//
//  authorUserInfo.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AuthorUserInfo.h"

@implementation AuthorUserInfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ids = value;
    }
}

@end
