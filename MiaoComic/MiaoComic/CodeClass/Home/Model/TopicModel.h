//
//  topicModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface TopicModel : BaseModel
@property (nonatomic, copy) NSString *title;// 漫画名称
@property (nonatomic, copy) NSString *ids;// 点击漫画名称要传入的id
@end
