//
//  SignUpViewController.m
//  Joke
//
//  Created by cao on 13-8-15.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "SignUpViewController.h"
#import "NavigatorTitleLabel.h"
#import "NavigatorBackBar.h"
#import "AFNetworking.h"
#import "SignUpSuccessViewController.h"
#import "PopHintViewController.h"
#import "UserModel.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    //标题
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"VIP皇冠会员";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    //提交按钮
    [Util adjustBackgroundImage:_buttonSubmit];
    
    //输入框背景图
    [Util adjustTextFieldBackground:_textFieldUserName];
    [Util adjustTextFieldBackground:_textFieldPassword];
    [Util adjustTextFieldBackground:_textFieldEmail];
    
    //输入框内部左侧边距
    [Util adjustTextFieldLeftPadding:_textFieldUserName];
    [Util adjustTextFieldLeftPadding:_textFieldPassword];
    [Util adjustTextFieldLeftPadding:_textFieldEmail];
}

-(IBAction)handleTapSignUp:(id)sender{
    NSString *userName = _textFieldUserName.text;
    NSString *password = _textFieldPassword.text;
    NSString *email = _textFieldEmail.text;
    if([@"" isEqual:userName] || [@"" isEqual:password] || [@"" isEqual:email]){
        //TODO pop
        return;
    }
    _loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    [self addChildViewController:_loadingViewController];
    [self.view addSubview:_loadingViewController.view];
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[iApi sharedInstance].baseUrl];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = @{
                             @"username" : userName,
                             @"password" : password,
                             @"email" : email,
                             @"api" : @"signup"
                             };
    [client postPath:@"/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"sign up reqeust finish, result = %@", [responseObject description]);
        NSInteger code = [responseObject[@"code"] integerValue];
        [LoadingViewController Stop:_loadingViewController];
        if(code == 1){
            [[UserModel shareInstance] login:responseObject[@"data"]];
            NSLog(@"sign up success");
            SignUpSuccessViewController *success = [[SignUpSuccessViewController alloc] initWithNibName:@"SignUpSuccessViewController" bundle:nil];
            [self.navigationController pushViewController:success animated:YES];
        }else{
            NSString *errmsg = responseObject[@"data"][@"errmsg"];
            NSLog(@"error sign up:%@", errmsg);
            PopHintViewController *popError = [[PopHintViewController alloc] initWithText:errmsg?errmsg:@""];
            [self addChildViewController:popError];
            [self.view addSubview:popError.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LoadingViewController Stop:_loadingViewController];
        NSLog(@"sign up fail");
        //TODO
    }];

}


-(IBAction)handleTapResignKeyBoard:(id)sender{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
