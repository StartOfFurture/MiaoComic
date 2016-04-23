//
//  HomeCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "HomeCell.h"
#import "ComicsModel.h"

@interface HomeCell ()

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;// 漫画类型
@property (strong, nonatomic) IBOutlet UILabel *comicNameLabel;// 漫画名
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;// 作者名
@property (strong, nonatomic) IBOutlet UILabel *thisComicTitleLabel;// 本集漫画名
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;// 喜欢数
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;// 评论数
@property (strong, nonatomic) IBOutlet UIImageView *coverImgV;// 封面

@end


@implementation HomeCell


- (void)setDataWithModel:(BaseModel *)model {
    ComicsModel *comicsModel = (ComicsModel *)model;
    _typeLabel.text = comicsModel.label_text;
    _typeLabel.backgroundColor = [self colorWithHexString:comicsModel.label_color];
//    _typeLabel.layer.cornerRadius = 10;
//    _typeLabel.layer.masksToBounds = YES;
    
    _comicNameLabel.text = comicsModel.topicModel.title;
    
    _authorNameLabel.text = comicsModel.authorUserInfo.nickname;
    [_authorNameLabel sizeThatFits:CGSizeMake(40, 15)];
    
    _thisComicTitleLabel.text = comicsModel.title;
    
    if (comicsModel.likes_count > 100000) {
        _likeLabel.text = [NSString stringWithFormat:@"%ld万", comicsModel.likes_count / 10000];
    } else {
        _likeLabel.text = [NSString stringWithFormat:@"%ld", comicsModel.likes_count];
    }
    if (comicsModel.comments_count > 100000) {
        _commentLabel.text = [NSString stringWithFormat:@"%ld万", comicsModel.comments_count / 10000];
    } else {
        _commentLabel.text = [NSString stringWithFormat:@"%ld", comicsModel.comments_count];
    }
    
    [_coverImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg", comicsModel.cover_image_url]]];
}

// 颜色转换
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (void)awakeFromNib {
    // Initialization code
}

@end
