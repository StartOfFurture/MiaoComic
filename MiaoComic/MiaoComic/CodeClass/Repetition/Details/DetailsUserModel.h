//
//  DetailsUserModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface DetailsUserModel : BaseModel

@property (nonatomic, copy) NSString *avatar_url;// 头像
@property (nonatomic, copy) NSString *uid;// 用户id
@property (nonatomic, copy) NSString *nickname;// 作者昵称

@end
