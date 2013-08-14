//
//  SignUpSuccessViewController.m
//  Joke
//
//  Created by cao on 13-8-15.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "SignUpSuccessViewController.h"
#import "NavigatorBackBar.h"
#import "NavigatorTitleLabel.h"

@interface SignUpSuccessViewController ()

@end

@implementation SignUpSuccessViewController

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
    
    //返回按钮
    NavigatorBackBar *backBar = [[NavigatorBackBar alloc] initWithNavigatorController:self.navigationController];
    self.navigationItem.leftBarButtonItem = backBar;
    
    //返回按钮点击，直接回首页
    UIView *leftView =  self.navigationItem.leftBarButtonItem.customView;
    UITapGestureRecognizer *tapLeftView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBackBar)];
    [leftView addGestureRecognizer:tapLeftView];
    //标题
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"VIP皇冠会员";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
}

-(void)handleTapBackBar{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
