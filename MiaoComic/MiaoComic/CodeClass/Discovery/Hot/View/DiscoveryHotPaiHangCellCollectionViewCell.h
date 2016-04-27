//
//  DiscoveryHotPaiHangCellCollectionViewCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "DiscoveryHotListModel.h"
@interface DiscoveryHotPaiHangCellCollectionViewCell : BaseCollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cover_imageView;

@property (strong, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;

- (void)setDataModel:(DiscoveryHotListModel *)model;

@end
