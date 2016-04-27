//
//  DetailsModelCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailsModelCell.h"
#import "DetailsModel.h"

@implementation DetailsModelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.comicImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.comicImage.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self.contentView addSubview:self.comicImage];
}




@end
