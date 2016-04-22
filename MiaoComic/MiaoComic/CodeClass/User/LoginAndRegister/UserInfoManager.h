//
//  UserInfoManager.h
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject


+ (instancetype)defaultManager;


// 保存用户的name
+ (void)conserveUserName:(NSString *)userName;
// 获取用户的name
+ (NSString *)getUserName;

// 保存用户的id
+ (void)conserveUserID:(NSString *)userID;
// 获取用户ID
+ (NSString *)getUserID;
// 取消用户的ID
+ (void)cancelUserID;

// 保存用户的Icon
+ (void)conserVeUserIcon:(NSString *)userIcon;
// 获取用户的Icon
+ (NSString *)getUserIcon;


@end
