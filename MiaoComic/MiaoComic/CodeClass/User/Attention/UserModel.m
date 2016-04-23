//
//  UserModel.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}

@end
