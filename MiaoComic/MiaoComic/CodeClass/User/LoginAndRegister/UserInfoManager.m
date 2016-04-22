//
//  UserInfoManager.m
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager


+ (instancetype)defaultManager {
    static UserInfoManager *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[UserInfoManager alloc] init];
    });
    return manage;
}


// 保存用户的name
+ (void)conserveUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取用户的name
+ (NSString *)getUserName {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    if (name == nil) {
        return @" ";
    }
    return name;
}

// 保存用户的id
+ (void)conserveUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取用户ID
+ (NSString *)getUserID {
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if (ID == nil) {
        return @" ";
    }
    return ID;
}
// 取消用户的ID
+ (void)cancelUserID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 保存用户的Icon
+ (void)conserVeUserIcon:(NSString *)userIcon {
    [[NSUserDefaults standardUserDefaults] setObject:userIcon forKey:@"UserIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取用户的Icon
+ (NSString *)getUserIcon {
    NSString *icon = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIcon"];
    if (icon == nil) {
        return @" ";
    }
    return icon;
}

@end
