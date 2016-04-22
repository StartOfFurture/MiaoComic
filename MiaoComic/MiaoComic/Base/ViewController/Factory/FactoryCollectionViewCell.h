//
//  FactoryCollectionViewCell.h
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"
@interface FactoryCollectionViewCell : NSObject

+ (BaseCollectionViewCell *)creatCollectionViewCell:(BaseModel *)model andCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
