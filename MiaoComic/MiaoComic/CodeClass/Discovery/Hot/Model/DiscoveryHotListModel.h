//
//  DiscoveryHotListModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface DiscoveryHotListModel : BaseModel

@property (nonatomic, copy)NSString *GroupTitle;//漫画分组
@property (nonatomic, copy)NSString *vertical_image_url;//图片链接
@property (nonatomic, copy)NSString *cover_image_url;//图片链接
@property (nonatomic, copy)NSString *title;//漫画的名称
@property (nonatomic, copy)NSString *ID;//该本漫画的id
@property (nonatomic, copy)NSString *nickname;//作者的名称
@property (nonatomic, copy)NSString *pic;//官方显示图片的链接
@property (nonatomic, copy)NSString *target_title;//官方该漫画的标题
@property (nonatomic, copy)NSString *target_id;//官方传到下一个界面的id值

@end
