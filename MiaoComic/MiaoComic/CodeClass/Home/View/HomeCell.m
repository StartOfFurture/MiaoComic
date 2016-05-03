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

@property (nonatomic, strong) ComicsModel *myModel;

@end


@implementation HomeCell


- (void)setDataWithModel:(BaseModel *)model {
    _myModel = (ComicsModel *)model;
    ComicsModel *comicsModel = (ComicsModel *)model;
    _typeLabel.text = comicsModel.label_text;
    _typeLabel.backgroundColor = [self colorWithHexString:comicsModel.label_color];
//    _typeLabel.layer.cornerRadius = 10;
//    _typeLabel.layer.masksToBounds = YES;
 

    [_comicNameBtn setTitle:comicsModel.topicModel.title forState:UIControlStateNormal];
    _comicNameBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;//设置文字位置，现设为居左，默认的是居中
    
    
    [_authorNameBtn setTitle:comicsModel.authorUserInfo.nickname forState:UIControlStateNormal];
   _authorNameBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
//    if(comicsModel.authorUserInfo.nickname.length > 5) {
//        _authorNameBtn.frame = CGRectMake(110 + ScreenWidth / 2, 10, ScreenWidth / 2 - 110, 20);
//    } else {
//        [_authorNameBtn sizeThatFits:CGSizeMake(40, 1)];
//    }
    

    
    [_thisComicTitleBtn setTitle:comicsModel.title forState:UIControlStateNormal];
    _thisComicTitleBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;

    _likeBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    if (comicsModel.likes_count > 100000) {
        
        [_likeBtn setTitle:[NSString stringWithFormat:@"%ld万", comicsModel.likes_count / 10000] forState:UIControlStateNormal];
        _likeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//        _likeLabel.text = [NSString stringWithFormat:@"%ld万", comicsModel.likes_count / 10000];
    } else {
        [_likeBtn setTitle:[NSString stringWithFormat:@"%ld", comicsModel.likes_count] forState:UIControlStateNormal];
//        _likeLabel.text = [NSString stringWithFormat:@"%ld", comicsModel.likes_count];
    }
    
    _commentBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    if (comicsModel.comments_count > 100000) {
        [_commentBtn setTitle:[NSString stringWithFormat:@"%ld万", comicsModel.comments_count / 10000] forState:UIControlStateNormal];
//        _commentLabel.text = [NSString stringWithFormat:@"%ld万", comicsModel.comments_count / 10000];
    } else {
        [_commentBtn setTitle:[NSString stringWithFormat:@"%ld", comicsModel.comments_count] forState:UIControlStateNormal];
//        _commentLabel.text = [NSString stringWithFormat:@"%ld", comicsModel.comments_count];
    }
    
    [_coverImgV sd_setImageWithURL:[NSURL URLWithString:comicsModel.cover_image_url]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(_myModel.authorUserInfo.nickname.length > 6) {
        _authorNameBtn.frame = CGRectMake(100 + ScreenWidth / 2, 10, ScreenWidth / 2 - 110, 20);
        _authorImgV.frame = CGRectMake(80 + ScreenWidth / 2, 10, 20, 20);
    }
    else {
        [_authorNameBtn sizeThatFits:CGSizeMake(40, 1)];
    }
    
    
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
