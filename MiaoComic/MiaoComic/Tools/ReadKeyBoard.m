//
//  ReadKeyBoard.m
//  Leisure
//
//  Created by lanou on 16/4/9.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ReadKeyBoard.h"
#import "LoginViewController.h"
@interface ReadKeyBoard()

@property (nonatomic, assign)BOOL isresult;
@property (nonatomic, assign)BOOL ischang;
@property (nonatomic, assign)CGRect orginFrame;
@property (nonatomic, assign)CGRect orginTextView;


@end

@implementation ReadKeyBoard

//发表评论网络请求
- (void)requestData:(NSString *)content{
    [NetWorkRequestManager requestWithType:POST urlString:[NSString stringWithFormat:COMMENT_Published, self.ID] dic:@{@"content":content} successful:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin" object:nil];
        });
    } errorMessage:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.ischang = YES;
    self.isresult= NO;
    //输入框
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, frame.size.width - 60,frame.size.height - 10)];
    self.textView.returnKeyType = UIReturnKeyNext;
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:15.0];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    [self addSubview:self.textView];
    
    //为输入框添加占位符
    _plahchLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.textView.frame.size.width - 10, self.textView.frame.size.height - 10)];
    _plahchLabel.text = @"来吐槽把～～～";
    _plahchLabel.enabled = NO;//lable必须设置为不可用
    _plahchLabel.backgroundColor = [UIColor clearColor];
    _plahchLabel.font = [UIFont systemFontOfSize:14];
    [self.textView addSubview:_plahchLabel];
    
    //按钮
    _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sendButton.frame = CGRectMake(frame.size.width - 40, 5, 30, frame.size.height - 10);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    __block UITextView *textView = self.textView;
    __block UILabel *label = _plahchLabel;
    __block ReadKeyBoard *keyBoard = self;
    _sendButton.block = (id)^(id button){
        if (![textView.text isEqualToString:@""]&&![[UserInfoManager getUserID] isEqual:@" "]) {
            if (_isHuiFu == NO) {
                [keyBoard requestData:textView.text];
            }else{
                NSLog(@"回复");
            }
            textView.text = @"";
            label.text = @"来吐槽把～～～";
            [textView resignFirstResponder];
        }else if ([[UserInfoManager getUserID] isEqual:@" "]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nouser" object:nil];
            [textView resignFirstResponder];
        }
        return nil;
    };
    [self addSubview:_sendButton];
    
    self.backgroundColor = [UIColor colorWithRed:233.0/255 green:232.0/255 blue:250.0/255 alpha:1.0];
    return self;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
    CGSize size = [textView.text sizeWithAttributes:dic];
    if (size.width > self.textView.frame.size.width) {
        if (_ischang == YES) {
            _orginFrame = self.frame;
            CGRect frame = self.frame;
            frame.size.height = self.frame.size.height * 2 - 10;
            frame.origin.y = frame.origin.y - (frame.size.height - _orginFrame.size.height);
            self.frame = frame;
            
            _orginTextView = self.textView.frame;
            CGRect textViewFrame = self.textView.frame;
            textViewFrame.size.height = self.textView.frame.size.height * 2;
            self.textView.frame = textViewFrame;
            
            _ischang = NO;
            _isresult = YES;
        }
    }if (size.width <= self.textView.frame.size.width) {
        if (_isresult) {
            _ischang = YES;
            self.frame = _orginFrame;
            self.textView.frame = _orginTextView;
        }if (textView.text.length == 0) {
            self.plahchLabel.text = @"来吐槽把～～～";
        }else{
            self.plahchLabel.text = @"";
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
