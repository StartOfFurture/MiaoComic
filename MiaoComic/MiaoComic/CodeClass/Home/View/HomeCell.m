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

@end


@implementation HomeCell


- (void)setDataWithModel:(BaseModel *)model {
    ComicsModel *comicsModel = (ComicsModel *)model;
    _typeLabel.text = comicsModel.label_text;
    _typeLabel.backgroundColor = [self colorWithHexString:comicsModel.label_color];
    
    [_comicNameBtn setTitle:comicsModel.topicModel.title forState:UIControlStateNormal];
    _comicNameBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;//设置文字位置，现设为居左，默认的是居中
    
    
    [_authorNameBtn setTitle:comicsModel.authorUserInfo.nickname forState:UIControlStateNormal];
   _authorNameBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    [_authorNameBtn sizeThatFits:CGSizeMake(40, 15)];

    
    [_thisComicTitleBtn setTitle:comicsModel.title forState:UIControlStateNormal];
    _thisComicTitleBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    
    
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
    
    [_coverImgV sd_setImageWithURL:[NSURL URLWithString:comicsModel.cover_image_url]];
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
