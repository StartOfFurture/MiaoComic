//
//  DiscoveryHotPaiHangCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotPaiHangCell.h"

@interface DiscoveryHotPaiHangCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DiscoveryHotPaiHangCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ScreenWidth - 30, 70);
//        layout.minimumInteritemSpacing = 2;
//        layout.minimumLineSpacing = 2;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 2, ScreenWidth - 8, layout.itemSize.height * 3) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"DiscoveryHotRenQiCellCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DiscoveryHotRenQiCellCollectCell"];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *str = @"DiscoveryHotRenQiCellCollectCell";
//    DiscoveryHotRenQiCellCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
//    [cell setDataModel:self.array[indexPath.row]];
//    return cell;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
