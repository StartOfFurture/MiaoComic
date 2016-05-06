//
//  DiscoveryHotPaiHangCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotPaiHangCell.h"
#import "DiscoveryHotPaiHangCellCollectionViewCell.h"
#import "DiscoveryHotListModel.h"

@interface DiscoveryHotPaiHangCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DiscoveryHotPaiHangCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ScreenWidth - 30, (ScreenWidth - 30) / 4);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 2, ScreenWidth - 8, layout.itemSize.height * 3) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"DiscoveryHotPaiHangCellCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DiscoveryHotPaiHangCellCollectionViewCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"DiscoveryHotPaiHangCellCollectionViewCell";
    DiscoveryHotPaiHangCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    
    if (indexPath.row < self.array.count) {
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
        [cell setDataModel:self.array[indexPath.row]];
        return cell;
    }else{
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(10, 20, 100, 40);
        _button.layer.cornerRadius = 10;
        _button.layer.masksToBounds = YES;
        [_button setTitle:@"全部榜单" forState:UIControlStateNormal];
        [_button setTintColor:[UIColor blackColor]];
        _button.backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.62 alpha:1];
        UICollectionViewCell *cell11 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        __block id delegeta = self.delegate;
        _button.block = (id)^(id button){
            if (delegeta != nil && [delegeta respondsToSelector:@selector(jump)]) {
                [delegeta jump];
            }
            return nil;
        };
        [cell11.contentView addSubview:_button];
        return cell11;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiscoveryHotListModel *model = self.array[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:model.ID];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
