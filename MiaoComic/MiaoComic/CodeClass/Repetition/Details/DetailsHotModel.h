//
//  DetailsHotModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "DetailsUserModel.h"

@interface DetailsHotModel : BaseModel

@property (nonatomic, strong) NSString *content;// 评论的内容
@property (nonatomic, copy) NSString *likes_count;// 评论的点赞数
@property (nonatomic, copy) NSString *created_at;// 评论的时间
@property (nonatomic, strong) DetailsUserModel *user;// 用户信息

@end
