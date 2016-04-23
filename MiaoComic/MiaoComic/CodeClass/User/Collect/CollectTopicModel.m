//
//  TopicModel.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CollectTopicModel.h"

@implementation CollectTopicModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.tid = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
}

@end
