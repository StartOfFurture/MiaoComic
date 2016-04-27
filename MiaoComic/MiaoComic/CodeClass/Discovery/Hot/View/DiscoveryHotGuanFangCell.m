//
//  DiscoveryHotGuanFangCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryHotGuanFangCell.h"
#import "DiscoveryHotGuanFangColletionCell.h"
#import "DiscoveryHotListModel.h"
@interface DiscoveryHotGuanFangCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DiscoveryHotGuanFangCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((ScreenWidth - 24)/2, 120);
        layout.minimumInteritemSpacing = 8;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 2, ScreenWidth - 16, layout.itemSize.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        //        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"DiscoveryHotGuanFangColletionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DiscoveryHotGuanFangColletionCell"];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.array.count;
    return 2;//官方外面只显示2个
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"DiscoveryHotGuanFangColletionCell";
    DiscoveryHotGuanFangColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    [cell setDataWithModel:self.array[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiscoveryHotListModel *model = self.array[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"guanfang" object:model.target_id];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
