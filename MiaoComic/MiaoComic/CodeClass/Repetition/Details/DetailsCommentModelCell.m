//
//  DetailsCommentModelCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailsCommentModelCell.h"

@implementation DetailsCommentModelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.crossLine = [[UIView alloc] initWithFrame:CGRectZero];
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.previousLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.likeButton.frame = CGRectMake(ScreenWidth / 4 - 25, 20, 50, 50);
    [self.contentView addSubview:self.likeButton];
    self.likeLabel.frame = CGRectMake(ScreenWidth / 4 - 25, 75, 50, 20);
    [self.contentView addSubview:self.likeLabel];
    self.commentButton.frame = CGRectMake(ScreenWidth / 2 - 25, 20, 50, 50);
    [self.contentView addSubview:self.commentButton];
    self.commentLabel.frame = CGRectMake(ScreenWidth / 2 - 25, 75, 50, 20);
    [self.contentView addSubview:self.commentLabel];
    self.shareButton.frame = CGRectMake(ScreenWidth * 3 / 4 - 25, 20, 50, 50);
    [self.contentView addSubview:self.shareButton];
    self.shareLabel.frame = CGRectMake(ScreenWidth * 3 / 4 - 25, 75, 50, 20);
    [self.contentView addSubview:self.shareLabel];
    self.crossLine.frame = CGRectMake(0, self.frame.size.height / 2, ScreenWidth, 1);
    [self.contentView addSubview:self.crossLine];
    self.verticalLine.frame = CGRectMake(ScreenWidth / 2, self.frame.size.height / 2 + 10, 1, self.frame.size.height / 2 - 20);
    [self.contentView addSubview:self.verticalLine];
    self.previousButton.frame = CGRectMake(ScreenWidth / 4 - 45, self.frame.size.height * 3 / 4 , 20, 20);
    [self.contentView addSubview:self.previousButton];
    self.previousLabel.frame = CGRectMake(ScreenWidth / 4, self.frame.size.height * 3 / 4, 45, 20);
    [self.contentView addSubview:self.previousLabel];
    self.nextLabel.frame = CGRectMake(ScreenWidth * 3 / 4 - 45, self.frame.size.height * 3 / 4 , 45, 20);
    [self.contentView addSubview:self.nextLabel];
    self.nextButton.frame = CGRectMake(ScreenWidth * 3 / 4 + 20, self.frame.size.height * 3 / 4, 20, 20);
    [self.contentView addSubview:self.nextButton];
}

@end
