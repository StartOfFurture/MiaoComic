//
//  MessageModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "MessageComicModel.h"
#import "MessageUserModel.h"

@interface MessageModel : BaseModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;// 时间戳
@property (nonatomic, strong) MessageComicModel *target_comic;
@property (nonatomic, copy) NSString *tcontent;
@property (nonatomic, strong) MessageUserModel *user;


@end
