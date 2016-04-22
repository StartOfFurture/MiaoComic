//
//  ClassifyListModelCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ClassifyListModelCell.h"
#import "ClassifyListModel.h"

@implementation ClassifyListModelCell


- (void)setDataWithModel:(ClassifyListModel *)model{
    [self.coverimageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    self.titleLabel.text = model.title;
    self.nickNameLabel.text = model.nickname;
    //判断点赞数，大于10万的显示万
    NSInteger likeCount = [model.likes_count integerValue];
    if (likeCount >= 100000) {
        NSString *likeC = [[NSString stringWithFormat:@"%@",model.likes_count] substringToIndex:2];
        self.likeLabel.text = [NSString stringWithFormat:@"%@万",likeC];
    }else{
        self.likeLabel.text = [NSString stringWithFormat:@"%@",model.likes_count];
    }
    
    //判断评论数,大于10万，显示万
    NSInteger commentsCount = [model.comments_count integerValue];
    if (commentsCount >= 100000) {
        NSString *commentsC = [[NSString stringWithFormat:@"%@",model.comments_count] substringToIndex:2];
        self.commentsLabel.text = [NSString stringWithFormat:@"%@万",commentsC];
    }else{
        self.commentsLabel.text = [NSString stringWithFormat:@"%@",model.comments_count];
    }
    //关注按钮
    self.favouriteButton.layer.cornerRadius = 10;
    self.favouriteButton.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
