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



@end

@implementation DiscoveryHotRenQiCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((ScreenWidth - 24)/3, 120);
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 2, ScreenWidth - 16, frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"DiscoveryHotRenQiCellCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DiscoveryHotRenQiCellCollectCell"];
        [self addSubview:_collectionView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"DiscoveryHotRenQiCellCollectCell";
    DiscoveryHotRenQiCellCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    [cell setDataModel:self.array[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"lala1111");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"lala");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
