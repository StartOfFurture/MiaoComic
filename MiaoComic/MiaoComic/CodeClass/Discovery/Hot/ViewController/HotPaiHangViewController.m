//
//  HotPaiHangViewController.m
//  MiaoComic
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "HotPaiHangViewController.h"

@interface HotPaiHangViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation HotPaiHangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"作品榜单" attributes:dic];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = string;
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:Discover_zuopin_more]]];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    // Do any additional setup after loading the view.
}

//返回
- (void)back{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//webView协议
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    if (navigationType == UIWebViewNavigationTypeOther) {
//        NSURL *url = [request URL];
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication]openURL:url];
//        }
//        NSLog(@"nihaoaaaaa");
//        return NO;
//    }
    NSLog(@"%@",request);
    NSLog(@"%ld",(long)navigationType);
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
