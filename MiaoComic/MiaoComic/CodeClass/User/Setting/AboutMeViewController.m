//
//  AboutMeViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于喵";
    self.view.backgroundColor = [UIColor colorWithHue:170/255.0 saturation:5/255.0 brightness:244/255.0 alpha:255/255.0];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 50, 150, 100, 100)];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:@"miao_log"];
    [self.view addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 50, 300, 100, 40)];
    nameLabel.font = [UIFont fontWithName:@"Marker Felt" size:18];
    nameLabel.text = @"喵漫画";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    UILabel *nameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 75, 360, 150, 20)];
    nameLabel1.font = [UIFont systemFontOfSize:14];
    nameLabel1.text = @"喵漫画 v1.0.0(10000)";
    nameLabel1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel1];
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
