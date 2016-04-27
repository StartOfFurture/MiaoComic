//
//  DiscoveryHotRenQiCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DiscoveryHotRenQiCell : BaseTableViewCell

@property (nonatomic, strong)NSMutableArray *array;//人气

@property (nonatomic, strong)NSMutableArray *zhubianArray;//主编

@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic)NSString *identent;//标识

@end
