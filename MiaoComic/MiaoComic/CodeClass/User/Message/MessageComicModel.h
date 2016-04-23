//
//  ComicModel.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface MessageComicModel : BaseModel

@property (nonatomic, copy) NSString *cover_image_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *topic_title;
@property (nonatomic, copy) NSString *tid;


@end
