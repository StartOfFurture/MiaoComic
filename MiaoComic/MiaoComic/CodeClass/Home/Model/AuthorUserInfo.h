//
//  authorUserInfo.h
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface AuthorUserInfo : BaseModel

@property (nonatomic, copy) NSString *ids;// 点击作者要传入的id
@property (nonatomic, copy) NSString *nickname;// 作者名
@property (nonatomic, copy) NSString *reg_type;

@end
