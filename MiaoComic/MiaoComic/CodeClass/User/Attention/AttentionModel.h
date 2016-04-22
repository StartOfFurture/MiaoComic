//
//  AttentionModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface AttentionModel : BaseModel

@property (nonatomic, copy) NSString *cover_image_url;// 封面图片
@property (nonatomic, copy) NSString *cid;// id
@property (nonatomic, copy) NSString *latest_comic_title;// 最新的标题
@property (nonatomic, copy) NSString *title;// 漫画的标题
@property (nonatomic, strong) UserModel *user;// 作者

@end
