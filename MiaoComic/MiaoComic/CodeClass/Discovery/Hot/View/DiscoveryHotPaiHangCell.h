//
//  DiscoveryHotPaiHangCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol DiscoveryHotPaiHangCellDelegate <NSObject>

- (void)jump;

@end

@interface DiscoveryHotPaiHangCell : BaseTableViewCell

@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIButton *button;

@property (nonatomic, assign)id<DiscoveryHotPaiHangCellDelegate>delegate;

@end
