//
//  CollectModelCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CollectModelCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coveImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
