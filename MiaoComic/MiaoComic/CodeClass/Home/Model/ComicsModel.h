//
//  ComicsModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "TopicModel.h"
#import "AuthorUserInfo.h"

@interface ComicsModel : BaseModel
@property (nonatomic, copy) NSString *label_text;// 漫画类型
@property (nonatomic, copy) NSString *label_color;// 该漫画类型的背景颜色
@property (nonatomic, copy) NSString *cover_image_url;// 图片链接
@property (nonatomic, copy) NSString *title;// 本集漫画名
@property (nonatomic, copy) NSString *likes_count;// 喜欢数量
@property (nonatomic, copy) NSString *comments_count;// 评论数量
@property (nonatomic, copy) NSString *ids;// 点击进入下一个界面需要的id

@property (nonatomic, strong) TopicModel *topicModel;// 整本漫画信息
@property (nonatomic, strong) AuthorUserInfo *authorUserInfo;// 作者信息
@end
