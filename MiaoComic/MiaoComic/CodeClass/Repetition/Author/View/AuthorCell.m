//
//  AuthorCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AuthorCell.h"
#import "AuthorTopicModel.h"

@interface AuthorCell ()
@property (strong, nonatomic) IBOutlet UIImageView *coverImgV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation AuthorCell

- (void)setDataWithModel:(BaseModel *)model {
    AuthorTopicModel *myModel = (AuthorTopicModel *)model;
    dispatch_async(dispatch_get_main_queue(), ^{

        if ([myModel.cover_image_url rangeOfString:@".jpg"].location == NSNotFound) {
            [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",myModel.cover_image_url]] placeholderImage:[UIImage imageNamed:@"pheader"]];
        } else {
            [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:myModel.cover_image_url] placeholderImage:[UIImage imageNamed:@"pheader"]];
        }
    });
    self.titleLabel.text = myModel.title;
    self.descriptionLabel.text = myModel.descriptions;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cxt, 1);
    CGContextSetStrokeColorWithColor(cxt, [UIColor colorWithWhite:0.910 alpha:1.000].CGColor);
    CGContextMoveToPoint(cxt, 0.0 , self.frame.size.height - 1);
    CGContextAddLineToPoint(cxt,self.frame.size.width , self.frame.size.height - 1);
    CGContextStrokePath(cxt);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
