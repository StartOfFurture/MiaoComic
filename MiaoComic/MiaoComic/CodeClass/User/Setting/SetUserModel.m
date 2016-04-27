//
//  SetUserModel.m
//  MiaoComic
//
//  Created by lanou on 16/4/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SetUserModel.h"

@implementation SetUserModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}

@end
