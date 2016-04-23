//
//  UserModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface MessageUserModel : BaseModel

@property (nonatomic, copy) NSString *avatar_url;// 头像
@property (nonatomic, copy) NSString *uid;// id
@property (nonatomic, copy) NSString *nickname;// 昵称

@end
