//
//  DiscoveryHotRenQiCellCollectCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "DiscoveryHotListModel.h"
@interface DiscoveryHotRenQiCellCollectCell : BaseCollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (void)setDataModel:(DiscoveryHotListModel *)model;



@end
