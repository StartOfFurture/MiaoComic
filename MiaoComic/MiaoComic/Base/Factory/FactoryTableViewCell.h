//
//  FactoryTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "BaseTableViewCell.h"

@interface FactoryTableViewCell : NSObject

+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model;

+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model tableView:(UITableView *)tabelView indexPath:(NSIndexPath *)indexPath;

@end
