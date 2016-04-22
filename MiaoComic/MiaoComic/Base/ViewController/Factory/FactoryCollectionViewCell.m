//
//  FactoryCollectionViewCell.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "FactoryCollectionViewCell.h"

@implementation FactoryCollectionViewCell

+ (BaseCollectionViewCell *)creatCollectionViewCell:(BaseModel *)model andCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    //1、找类名
    NSString *name = NSStringFromClass([model class]);
//    //2、找到cell的类名
//    NSString *nameCell = [name stringByAppendingString:@"Cell"];
//    Class cellClass = NSClassFromString(nameCell);
    //3、创建cell
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
    [cell setDataWithModel:model];
    return cell;
}

@end
