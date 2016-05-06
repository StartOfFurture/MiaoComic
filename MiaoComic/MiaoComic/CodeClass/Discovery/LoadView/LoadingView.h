//
//  LoadingView.h
//  MiaoComic
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseView.h"

@interface LoadingView : BaseView

@property (strong, nonatomic) IBOutlet UIImageView *MyImageView;

@property (strong, nonatomic) IBOutlet UILabel *LabelState;

@property (nonatomic, assign)NSInteger countImage;//图片数量
@property (nonatomic, copy)NSString *nameImage;//图片名称
@property (nonatomic, assign)NSTimeInterval timeInter;//一次动画的时间

- (void)createAnimationWithCountImage:(NSInteger)countImage nameImage:(NSString *)nameImage timeInter:(NSTimeInterval)timeInterval labelText:(NSString *)text;

@end
