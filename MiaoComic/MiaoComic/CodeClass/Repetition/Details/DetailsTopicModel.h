//
//  DetailsTopicModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "DetailsUserModel.h"

@interface DetailsTopicModel : BaseModel

@property (nonatomic, copy) NSString *tid;// 本本漫画的id
@property (nonatomic, strong) DetailsUserModel *user;// 用户信息


@end
