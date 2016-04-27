//
//  DetailsModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "DetailsTopicModel.h"

@interface DetailsModel : BaseModel

@property (nonatomic, copy) NSString *comments_count;// 漫画的评论数
@property (nonatomic, copy) NSString *likes_count;// 漫画的点赞数
@property (nonatomic, strong) NSArray *images;// 漫画的图片
@property (nonatomic, copy) NSString *next_comic_id;// 下一片漫画的id
@property (nonatomic, copy) NSString *previous_comic_id;// 上一篇漫画的id
@property (nonatomic, copy) NSString *title;// 该篇漫画的标题
@property (nonatomic, strong) DetailsTopicModel *topic;// 每本漫画的信息


@end
