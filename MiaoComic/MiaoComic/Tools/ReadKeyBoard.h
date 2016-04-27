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

@end
