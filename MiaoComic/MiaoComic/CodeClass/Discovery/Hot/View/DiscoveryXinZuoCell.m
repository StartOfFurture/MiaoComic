//
//  DiscoveryXinZuoCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DiscoveryXinZuoCell.h"
#import "DiscoveryHotListModel.h"

@interface DiscoveryXinZuoCell ()

@property (nonatomic, strong)UIImageView *MyimageView;

@end

@implementation DiscoveryXinZuoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.MyimageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth - 16, 120)];
        [self.contentView addSubview:self.MyimageView];
    }
    return self;
}

- (void)setDataWithModel:(DiscoveryHotListModel *)model{
    [_MyimageView sd_setImageWithURL:[NSURL URLWithString:[ImageURL ImageStrWithString:model.cover_image_url]]];
    NSLog(@"22222%@",model.cover_image_url);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
