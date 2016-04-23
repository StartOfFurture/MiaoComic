//
//  MessageMoldeCell.h
//  MiaoComic
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MessageMoldeCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *myContentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLaebl;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
