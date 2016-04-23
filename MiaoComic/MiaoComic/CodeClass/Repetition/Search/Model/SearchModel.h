//
//  SearchModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface SearchModel : BaseModel

@property (nonatomic, copy)NSString *cover_image_url;//显示图片链接
@property (nonatomic, copy)NSString *title;//漫画名
@property (nonatomic, copy)NSString *likes_count;//赞的个数
@property (nonatomic, copy)NSString *comments_count;//评论的个数
@property (nonatomic, copy)NSString *ID;//漫画id
@property (nonatomic, copy)NSString *is_favourite;//是否关注
@property (nonatomic, copy)NSString *nickname;//作者名称

@end
