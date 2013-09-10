//
//  VipIntroduceViewController.m
//  Joke
//
//  Created by cao on 13-8-12.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "VipIntroduceViewController.h"
#import "LoginViewController.h"
#import "NavigatorBackBar.h"
#import "NavigatorTitleLabel.h"
#import "UserModel.h"

//TODO test
#import "SignUpViewController.h"

@interface VipIntroduceViewController ()

@end

@implementation VipIntroduceViewController

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
    
    [Util adjustBackgroundImage:_buttonRegistered];
    
    
    //返回按钮
    NavigatorBackBar *backBar = [[NavigatorBackBar alloc] initWithNavigatorController:self.navigationController];
    self.navigationItem.leftBarButtonItem = backBar;
    
    //标题
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"VIP皇冠会员";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    //内容区域的圆框背景
    UIImage *imageViewContentBackground = [Util adjustImage:[UIImage imageNamed:@"contentbox"]];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:imageViewContentBackground];
    backgroundImage.frame = _viewContent.bounds;
    [_viewContent addSubview:backgroundImage];
    _viewContent.backgroundColor = [UIColor clearColor];
    [_viewContent sendSubviewToBack:backgroundImage];
    NSInteger price = [UserModel shareInstance].price;
    _labelNow.text = [NSString stringWithFormat:_labelNow.text, price];
    NSString *registerText = [_buttonBuy titleForState:UIControlStateNormal];
    NSString *registerTextWithPrice = [NSString stringWithFormat:registerText, price];
    [_buttonBuy setTitle:registerTextWithPrice forState:UIControlStateNormal];
    
    _labelDesc.text = [NSString stringWithFormat:_labelDesc.text, [UserModel shareInstance].maxCountShouldVisit];
    
}
- (IBAction)handleTapToLogin:(id)sender{
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
}
- (IBAction)handleTapToBuy:(id)sender{
    //TODO  buy
    SignUpViewController *signup = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:signup animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
