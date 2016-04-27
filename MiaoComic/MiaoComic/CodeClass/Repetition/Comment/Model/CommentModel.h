//
//  CommentModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

@property (nonatomic, copy)NSString *content;//评论内容
@property (nonatomic, copy)NSString *likes_count;//点赞数
@property (nonatomic, copy)NSString *avatar_url;//用户头像
@property (nonatomic, copy)NSString *nickname;//用户名
@property (nonatomic, copy)NSString *created_at;//发评论的时间
@property (nonatomic, copy)NSString *ID;//回复评论要传入的ID
@property (nonatomic, copy)NSString *is_liked;//是否点赞
@property (nonatomic, copy)NSString *userID;//用户id

@end
