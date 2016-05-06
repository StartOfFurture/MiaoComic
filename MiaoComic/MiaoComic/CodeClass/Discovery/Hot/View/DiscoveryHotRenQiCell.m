//
//  DiscoveryHotRenQiCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotRenQiCell.h"
#import "DiscoveryHotRenQiCellCollectCell.h"

@interface DiscoveryHotRenQiCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionViewFlowLayout *layout;


@end

@implementation DiscoveryHotRenQiCell

//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.itemSize = CGSizeMake((ScreenWidth - 24)/3, 120);
//        layout.minimumInteritemSpacing = 2;
//        layout.minimumLineSpacing = 2;
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 2, ScreenWidth - 16, frame.size.height) collectionViewLayout:layout];
//        _collectionView.backgroundColor = [UIColor clearColor];
//        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
//        _collectionView.userInteractionEnabled = YES;
//        [_collectionView registerNib:[UINib nibWithNibName:@"DiscoveryHotRenQiCellCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DiscoveryHotRenQiCellCollectCell"];
//        [self.contentView addSubview:_collectionView];
////        self.userInteractionEnabled = YES;
//    }
//    return self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
//        _layout.itemSize = CGSizeMake((ScreenWidth - 24)/3, 120);
        _layout.minimumInteritemSpacing = 2;
        _layout.minimumLineSpacing = 2;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"DiscoveryHotRenQiCellCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DiscoveryHotRenQiCellCollectCell"];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([_identent isEqualToString:@"renqi"]) {
        _layout.itemSize = CGSizeMake((ScreenWidth - 24)/3, self.contentView.frame.size.height);
    }else{
        _layout.itemSize = CGSizeMake((ScreenWidth - 24)/3, (self.contentView.frame.size.height - 6) / 2);
    }
    _collectionView.frame = CGRectMake(8, 2, ScreenWidth - 16, _layout.itemSize.height * 2);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_identent isEqualToString:@"renqi"]) {
        return 3;//人气外面只显示3个
    }else{
        return self.zhubianArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"DiscoveryHotRenQiCellCollectCell";
    DiscoveryHotRenQiCellCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    if ([_identent isEqualToString:@"renqi"]) {
        [cell setDataModel:self.array[indexPath.row]];
    }else{
        [cell setDataModel:self.zhubianArray[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"lala1111");
    DiscoveryHotListModel *model = nil;
    if ([_identent isEqualToString:@"renqi"]) {
        model = self.array[indexPath.row];
    }else{
        model = self.zhubianArray[indexPath.row];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:model.ID];
    NSLog(@"%@",model.title);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
