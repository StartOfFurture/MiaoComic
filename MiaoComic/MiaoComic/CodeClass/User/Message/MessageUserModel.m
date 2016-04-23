//
//  UserModel.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "MessageUserModel.h"

@implementation MessageUserModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}

@end
