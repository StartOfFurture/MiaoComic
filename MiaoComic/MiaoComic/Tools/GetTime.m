//
//  GetTime.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "GetTime.h"

@implementation GetTime

// 将某个秒数字符串转换成时间NSDate
+ (NSDate *)getDateFromSecondString:(NSString *)secondString {
    NSTimeInterval time = [secondString doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

// 将某个时间转换成相应的格式
+ (NSDate *)getDate:(NSDate *)date formatString:(NSString *)formatString {
    // 获取今天的时间距离1970年的秒数
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatString];// 去掉多余的秒数，获取今天0时0分0秒的时间
    NSString *todayStr = [formatter stringFromDate:date];
    NSDate *today = [formatter dateFromString:todayStr];
    return today;
}

// 从 某个秒数字符串，获取时间（如果时间在一个小时内显示 刚刚、1分钟前）
+ (NSString *)getTimeFromSecondString:(NSString *)secondString timeFormatType:(TimeFormatType)timeFormatType {
    NSTimeInterval time = [secondString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    // 传入的时间在一个小时内
    if (time + 60 > timeNow) {
        return @"刚刚";
    } else if (time + 60 * 60 > timeNow) {
        return [NSString stringWithFormat:@"%.0f分钟前", (timeNow - time) / 60];
    } else {
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute;
        
        comps = [calendar components:unitFlags fromDate:date];
        
        NSInteger year= [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        
        // 获取当前的 年份
        NSDateComponents *thisComps = [[NSDateComponents alloc] init];
        thisComps = [calendar components:unitFlags fromDate:[NSDate date]];
        NSInteger thisYear = [thisComps year];
        
        // 判断是否显示 年份
        NSString *dataString = nil;
        if (timeFormatType == Month_Day_Hour_Minute) {
            if (thisYear == year) {
                dataString = [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",month,day, hour, minute];
                return dataString;
            } else {
                dataString = [NSString stringWithFormat:@"%02ld-%02ld-%02ld %02ld:%02ld",year,month,day, hour, minute];
                return dataString;
                
            }
        } else {
            if (thisYear == year) {
                dataString = [NSString stringWithFormat:@"%02ld月%02ld日 %02ld:%02ld",month,day, hour, minute];
                return dataString;
            } else {
                dataString = [NSString stringWithFormat:@"%ld年%02ld月%02ld日 %02ld:%02ld",year,month,day, hour, minute];
                return dataString;
                
            }
        }
        
    }
    
    return nil;
}

// 从 秒 获取 天：精确到天
+ (NSString *)getDayFromSecondString:(NSString *)secondString {

    NSTimeInterval time = [secondString doubleValue];
    
    // 获取今天的时间，去掉小时和秒数
    NSDate *today = [GetTime getDate:[NSDate date] formatString:@"YYYY-MM-dd"];
    
    // 判断时间是否显示为今天、昨天、2天前
    CGFloat interval = 24 * 60 * 60;// 一天的时间
    CGFloat today_d = [today timeIntervalSince1970];// 今天的范围下限
    CGFloat today_u = today_d + interval;// 今天的范围上限
    CGFloat yesterday_d = today_d - interval;// 昨天的范围下限
    CGFloat beforeYesterday_d = yesterday_d - interval;// 前天的范围下限
    
    if (time >= today_d && time < today_u) {
        return @"今日";
    } else if (time >= yesterday_d && time < today_d) {
        return @"昨日";
    } else if (time >= beforeYesterday_d && time < yesterday_d) {
        return @"两天前";
    } else {
        
        // 获取传入时间的年、月、日
        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
   
        comps = [calendar components:unitFlags fromDate:timeDate];
        
        NSInteger year= [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        
        // 获取当前的 年份
        NSDateComponents *thisComps = [[NSDateComponents alloc] init];
        thisComps = [calendar components:unitFlags fromDate:[NSDate date]];
        NSInteger thisYear = [thisComps year];
        
        // 判断是否显示 年份
        NSString *dataString = nil;
        if (thisYear == year) {
            dataString = [NSString stringWithFormat:@"%ld月%ld日",month,day];
            return dataString;
        } else {
            dataString = [NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
            return dataString;

        }
    }
    

}


@end
