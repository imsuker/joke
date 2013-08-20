//
//  LoginViewController.m
//  Joke
//
//  Created by cao on 13-8-14.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "LoginViewController.h"
#import "NavigatorTitleLabel.h"
#import "NavigatorBackBar.h"
#import "AFNetworking.h"
#import "PopHintViewController.h"
#import "UserModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    titleLabel.text = @"VIP皇冠会员";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    //返回按钮
    NavigatorBackBar *backBar = [[NavigatorBackBar alloc] initWithNavigatorController:self.navigationController];
    self.navigationItem.leftBarButtonItem = backBar;
    
    //提交按钮
    [Util adjustBackgroundImage:_buttonSubmit];
    
    //输入框背景图
    [Util adjustTextFieldBackground:_textFieldAcount];
    [Util adjustTextFieldBackground:_textFieldPassword];
    
    //输入框内部左侧边距
    [Util adjustTextFieldLeftPadding:_textFieldAcount];
    [Util adjustTextFieldLeftPadding:_textFieldPassword];

}
//用户点击登录后动作
-(IBAction)handleTapLogin:(id)sender{
    NSString *acount = _textFieldAcount.text;
    NSString *password = _textFieldPassword.text;
    if([acount isEqualToString:@""] || [password isEqualToString:@""]){
        //TODO  showerror 
        return;
    }
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[iApi sharedInstance].baseUrl];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = @{
                             @"username" : acount,
                             @"password" : password,
                             @"api" : @"signin"
                             };
    [client postPath:@"/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"login reqeust finish, result = %@", [responseObject description]);
        NSInteger code = [responseObject[@"code"] integerValue];
        if(code == 1){
            [[UserModel shareInstance] login:responseObject[@"data"]];  
            NSLog(@"login success");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString *errmsg = responseObject[@"data"][@"errmsg"];
            NSLog(@"error login:%@", errmsg);
            PopHintViewController *popError = [[PopHintViewController alloc] initWithText:errmsg?errmsg:@""];
            [self addChildViewController:popError];
            [self.view addSubview:popError.view];        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"login fail");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end