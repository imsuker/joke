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
#import "MainViewController.h"

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
    
    _textFieldPassword.secureTextEntry = YES;

}
//用户点击登录后动作
-(IBAction)handleTapLogin:(id)sender{
    NSString *acount = _textFieldAcount.text;
    NSString *password = _textFieldPassword.text;
    if([acount isEqualToString:@""] || [password isEqualToString:@""]){
        PopHintViewController *popError = [[PopHintViewController alloc] initWithPopStyle:PopStyleBadInput];
        [self addChildViewController:popError];
        [self.view addSubview:popError.view];
        return;
    }
    if(!_loadingViewController){
        _loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    }
    [self addChildViewController:_loadingViewController];
    [self.view addSubview:_loadingViewController.view];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
        [_loadingViewController stop];
        if(code == 1){
            [[UserModel shareInstance] login:responseObject[@"data"]];  
            NSLog(@"login success");
            MainViewController *main = (MainViewController *)self.navigationController.viewControllers[0];
            main.isFromLogin = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString *error = responseObject[@"error"];
            NSLog(@"error login:%@", error);
            PopHintViewController *popError = [[PopHintViewController alloc] initWithText:error];
            [self addChildViewController:popError];
            [self.view addSubview:popError.view];        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"login fail");
        [_loadingViewController stop];
        PopHintViewController *popError = [[PopHintViewController alloc] initWithPopStyle:PopStyleBadNetWork];
        [self addChildViewController:popError];
        [self.view addSubview:popError.view];
    }];
}
-(IBAction)textfieldTapReturn:(id)sender{
    [sender resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
