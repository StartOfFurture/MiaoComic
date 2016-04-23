//
//  GetTime.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TimeFormatType){
    Month_Day_Hour_Minute,// 显示为04-22 05:50，一个小时内显示为 1分钟前
    MonthMDayDHour_Minute// 显示为04月22日 05:50
};
@interface GetTime : NSObject

// 将某个秒数字符串转换成时间NSDate
+ (NSDate *)getDateFromSecondString:(NSString *)secondString;

// 将某个时间转换成相应的格式
+ (NSDate *)getDate:(NSDate *)date formatString:(NSString *)formatString;

// 从 某个秒数字符串，获取时间（如果时间在一个小时内显示 刚刚、1分钟前）
+ (NSString *)getTimeFromSecondString:(NSString *)secondString timeFormatType:(TimeFormatType)timeFormatType;

// 从 某个秒数字符串 获取 天：精确到天
+ (NSString *)getDayFromSecondString:(NSString *)secondString;
@end
