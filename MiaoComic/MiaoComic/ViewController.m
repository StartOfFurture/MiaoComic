//
//  ViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "DiscoveryViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *naVC2 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    naVC2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"index"] selectedImage:[[UIImage imageNamed:@"index_change"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //发现
    DiscoveryViewController *discoverVC = [[DiscoveryViewController alloc] init];
    UINavigationController *naVC1 = [[UINavigationController alloc] initWithRootViewController:discoverVC];
    naVC1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"find"] selectedImage:[[UIImage imageNamed:@"find_change"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //用户
    UserViewController *userVC = [[UserViewController alloc] init];
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"用户" image:[UIImage imageNamed:@"user"] selectedImage:[[UIImage imageNamed:@"user_change"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //tabbar
//    UITabBarController *contrllerVC = [[UITabBarController alloc] init];
    self.viewControllers = @[naVC2, naVC1, userVC];
    self.selectedIndex = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
