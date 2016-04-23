//
//  TopicModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface CollectTopicModel : BaseModel
@property (nonatomic, copy) NSString *cover_image_url;// 封面图片
@property (nonatomic, copy) NSString *desc;// 简介
@property (nonatomic, copy) NSString *tid;// 漫画的id
@property (nonatomic, copy) NSString *title;// 漫画的标题
@end
