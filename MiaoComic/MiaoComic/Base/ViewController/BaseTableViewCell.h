//
//  BaseTableViewCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
@interface BaseTableViewCell : UITableViewCell

- (void)creatTableViewCell:(BaseModel *)model;

- (void)setDataWithModel:(BaseModel *)model;

@end
