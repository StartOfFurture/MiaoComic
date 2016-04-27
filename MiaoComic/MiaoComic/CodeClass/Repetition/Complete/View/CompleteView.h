
//  CompleteView.h
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteView : UIView
@property (nonatomic, strong) UIImageView *headerView;// 头部视图
@property (nonatomic, strong) UILabel *titleLabel;// 作品的名字
@property (nonatomic, strong) UILabel *likeLabel;// 点赞数
@property (nonatomic, strong) UILabel *commentLabel;// 评论数
@property (nonatomic, strong) UIButton *introBtn;// 简介
@property (nonatomic, strong) UIButton *contentBtn;// 内容
@property (nonatomic, strong) UIButton *sortBtn;// 排序按钮
@property (nonatomic, strong) UITableView *contentTableV;// 内容表


#pragma mark - 第一组cell 的第一个row
- (UIView *)createSection_One_Row_One;
#pragma mark - 第二组cell 的头部视图（简介、内容、标记图片）
- (UIView *)createSection_Two_Header;
#pragma mark - 第二组cell 的第一个row（作品列表、排序按钮）
- (UIView *)createSection_Two_Row_One;
@end
