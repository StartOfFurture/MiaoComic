//
//  CollectModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "CollectTopicModel.h"

@interface CollectModel : BaseModel


@property (nonatomic, copy) NSString *cover_image_url;// 封面图片
@property (nonatomic, copy) NSString *cid;// id
@property (nonatomic, copy) NSString *title;// 该篇的标题

@property (nonatomic, strong) CollectTopicModel *topic;// 本本漫画的信息

@end
