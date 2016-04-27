//
//  DetailsTopicModel.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailsTopicModel.h"

@implementation DetailsTopicModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.tid = value;
    }
}

@end
