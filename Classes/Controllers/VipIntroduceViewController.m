//
//  VipIntroduceViewController.m
//  Joke
//
//  Created by cao on 13-8-12.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "VipIntroduceViewController.h"

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
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    backView.image = [UIImage imageNamed:@"back"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBack)];
    [backView addGestureRecognizer:tapBack];
    
    //标题
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"VIP皇冠会员";
    [labelTitle sizeToFit];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = [UIFont systemFontOfSize:20.0];
    labelTitle.textColor = JD_FONT_COLOR_fff;
    self.navigationItem.titleView = labelTitle;
    
    //内容区域的圆框背景
    UIImage *imageViewContentBackground = [Util adjustImage:[UIImage imageNamed:@"contentbox"]];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:imageViewContentBackground];
    backgroundImage.frame = _viewContent.bounds;
    [_viewContent addSubview:backgroundImage];
    _viewContent.backgroundColor = [UIColor clearColor];
    [_viewContent sendSubviewToBack:backgroundImage];
}
;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
