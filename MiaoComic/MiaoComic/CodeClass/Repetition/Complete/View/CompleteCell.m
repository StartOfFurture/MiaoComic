//
//  CompleteCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CompleteCell.h"
#import "ComicsModel.h"


@interface CompleteCell ()
@property (strong, nonatomic) IBOutlet UIImageView *covImgV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;

@end

@implementation CompleteCell

-(void)setDataWithModel:(BaseModel *)model {
    ComicsModel *mymodel = (ComicsModel *)model;
    [self.covImgV sd_setImageWithURL:[NSURL URLWithString:mymodel.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = mymodel.title;
    self.timeLabel.text = [GetTime getTimeFromSecondString:mymodel.created_at timeFormatType:MonthMDayDHour_Minute];
    self.likeLabel.text = [NSString stringWithFormat:@"%ld", mymodel.likes_count];
    if (mymodel.likes_count > 100000) {
       self.likeLabel.text = [NSString stringWithFormat:@"%ld 万", mymodel.likes_count / 10000];
    } else {
        self.likeLabel.text = [NSString stringWithFormat:@"%ld", mymodel.likes_count];
    }
  
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
