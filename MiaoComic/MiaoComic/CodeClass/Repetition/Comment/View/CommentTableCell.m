//
//  CommentTableCell.m
//  MiaoComic
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CommentTableCell.h"
#import "CommentModel.h"
@implementation CommentTableCell

- (void)setDataWithModel:(CommentModel *)model{
    self.cover_imageView.layer.cornerRadius = 17.5;
    self.cover_imageView.layer.masksToBounds = YES;
    [self.cover_imageView sd_setImageWithURL:[NSURL URLWithString:[ImageURL ImageStrWithString:model.avatar_url]]];
    self.nickNameLabel.text = model.nickname;
    self.timeLabel.text = [NSString stringWithString:[GetTime getTimeFromSecondString:model.created_at timeFormatType:Month_Day_Hour_Minute]];
    self.contentLabel.text = model.content;
    //判断点赞数是否为0
    if ([[NSString stringWithFormat:@"%@",model.likes_count] isEqualToString:@"0"]) {
        self.likeCountLabel.text = @"";
    }else{
        self.likeCountLabel.text = [NSString stringWithFormat:@"%@",model.likes_count];
    }
    NSLog(@"%@",model.is_liked);
//    model.is_liked = @"1";
    //判断是否已经点赞
    /*
    if ([[NSString stringWithFormat:@"%@",model.is_liked] isEqualToString:@"1"]) {
        [self.zanButton setBackgroundImage:[[UIImage imageNamed:@"zan-change"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    __block CommentTableCell *cell = self;
    self.zanButton.block = (id)^(id button){
        [cell requestData:[NSString stringWithFormat:@"%@",model.ID]];
        return nil;
    };*/
    __block ReadKeyBoard *key = self.keyBoard;
    self.huifuButton.block = (id)^(id button){
        key.plahchLabel.text = [NSString stringWithFormat:@"回复：%@",model.nickname];
        key.isHuiFu = YES;
        return nil;
    };
    
}

//数据请求点赞
/*
- (void)requestData:(NSString *)IDstr{
    [NetWorkRequestManager requestWithType:POST urlString:[NSString stringWithFormat:LIKE_URL,IDstr] dic:nil successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",IDstr);
        NSLog(@"dicccccc%@",dic);
        NSLog(@"%@",[NSString stringWithFormat:LIKE_URL,IDstr]);
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
