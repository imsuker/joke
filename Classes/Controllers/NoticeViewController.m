//
//  NoticeViewController.m
//  Joke
//
//  Created by cao on 13-9-4.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "NoticeViewController.h"
#import "NavigatorTitleLabel.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //标题
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"公告";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmenu"] forBarMetrics:UIBarMetricsDefault];

    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    [self performSelector:@selector(showBackView) withObject:nil afterDelay:3.0];
}
-(void)handleTapBack{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)showBackView{
    //    //返回按钮
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    backView.userInteractionEnabled = YES;
    backView.image = [UIImage imageNamed:@"back"];
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBack)];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBar;
    [backView addGestureRecognizer:tapBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
