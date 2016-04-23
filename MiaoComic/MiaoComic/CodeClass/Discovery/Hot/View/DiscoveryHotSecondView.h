//
//  DiscoveryHotSecondView.h
//  MiaoComic
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseView.h"

@interface DiscoveryHotSecondView : BaseView
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UILabel *groupTitleLable;
@property (strong, nonatomic) IBOutlet UIImageView *labaImage;
@property (strong, nonatomic) IBOutlet UILabel *chubanLabel;

- (void)setDataModel:(NSString *)string;

@end
