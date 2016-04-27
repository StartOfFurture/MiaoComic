//
//  ImageURL.m
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ImageURL.h"

@implementation ImageURL

+ (NSString *)ImageStrWithString:(NSString *)str{
    NSMutableArray *array = [[str componentsSeparatedByString:@"."] mutableCopy];
    NSInteger max = array.count;
    if ([array[max - 1] isEqualToString:@"webp"]) {
        array[max - 1] = @"w.jpg";
    }else if ([array[max - 1] isEqualToString:@"webp-w320"]){
        array[max - 1] = @"webp-w320.w.jpg";
    }else if ([array[max - 1] isEqualToString:@"jpg-w320"]){
        array[max - 1] = @"jpg-w320.w.jpg";
    }else if ([array[max - 1] isEqualToString:@"webp-w750"]){
        array[max - 1] = @"webp-w750.jpg";
    }
    NSString *string = [array componentsJoinedByString:@"."];
    return string;
}

@end
