//
//  SetUserModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface SetUserModel : BaseModel

@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;

@end
