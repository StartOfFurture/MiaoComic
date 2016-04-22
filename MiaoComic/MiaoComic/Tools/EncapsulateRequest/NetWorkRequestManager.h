//
//  NetWorkRequestManager.h
//  Leisure
//
//  Created by lanou on 16/3/29.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType){
    GET,
    POST
};

typedef void(^Successful)(NSData *data);
typedef void(^Error)(NSError *error);

@interface NetWorkRequestManager : NSObject

@property (nonatomic, copy)Successful successful;
@property (nonatomic, copy)Error errorMessage;

+ (void)requestWithType:(RequestType)requestType urlString:(NSString *)urlString dic:(NSDictionary *)dic successful:(Successful)successful errorMessage:(Error)errorMessage;

@end
