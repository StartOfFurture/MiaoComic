//
//  ReadKeyBoard.h
//  Leisure
//
//  Created by lanou on 16/4/9.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadKeyBoard : UIView<UITextViewDelegate>

@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIButton *sendButton;//发送按钮
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, strong)UILabel *plahchLabel;//占位label

@property (nonatomic, copy)NSString *huifuName;//回复的名字
@property (nonatomic, copy)NSString *huifuID;//回复的id
@property (nonatomic, assign)BOOL isHuiFu;//是否是回复

@end
