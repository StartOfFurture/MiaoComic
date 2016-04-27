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
@property (nonatomic, assign) NSInteger likes_count;// 喜欢数量
@property (nonatomic, assign) NSInteger comments_count;// 评论数量
@property (nonatomic, copy) NSString *ids;// 点击进入下一个界面需要的id
@property (nonatomic, copy) NSString *shared_count;// 分享总数
@property (nonatomic, copy) NSString *created_at;// 创建的时间，用于关注页面按时间将数据分组
@property (nonatomic, assign) BOOL is_favourite;// 判断整本漫画是否被关注
@property (nonatomic, assign) BOOL is_liked;// 判断单集漫画是否被点赞

@property (nonatomic, strong) TopicModel *topicModel;// 整本漫画信息
@property (nonatomic, strong) AuthorUserInfo *authorUserInfo;// 作者信息
@end
