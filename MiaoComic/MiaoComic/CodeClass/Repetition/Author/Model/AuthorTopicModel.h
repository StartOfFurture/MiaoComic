//
//  AuthorTopicModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface AuthorTopicModel : BaseModel
@property (nonatomic, copy) NSString *cover_image_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptions;
@property (nonatomic, copy) NSString *ids;
@end
