//
//  AuthorModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "AuthorTopicModel.h"

@interface AuthorModel : BaseModel
@property (nonatomic, copy) NSString *avatar_url;// 作者图片连接
@property (nonatomic, copy) NSString *intro;// 简介
@property (nonatomic, copy) NSString *nickname;// 用户名

@property (nonatomic, strong) AuthorTopicModel *topicModel;// 作品详情
@end
