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
    backBar.dismiss = YES;
    self.navigationItem.leftBarButtonItem = backBar;
    
    //标题
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"VIP皇冠会员";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmenu"] forBarMetrics:UIBarMetricsDefault];

    
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
    _textFieldPassword.secureTextEntry = YES;
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
                             @"api" : @"signup",
                             @"os" : @"ios",
                             @"receipt" : _receipt?_receipt:@""
                             };
    [client postPath:@"/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"sign up reqeust finish, result = %@", [responseObject description]);
        NSInteger code = [responseObject[@"code"] integerValue];
        [_loadingViewController stop];
        if(code == 1){
            //取消掉交易流程
            [[SKPaymentQueue defaultQueue] finishTransaction: _transcation];
            [[UserModel shareInstance] login:responseObject[@"data"]];
            NSLog(@"sign up success");
            SignUpSuccessViewController *success = [[SignUpSuccessViewController alloc] initWithNibName:@"SignUpSuccessViewController" bundle:nil];
            [self.navigationController pushViewController:success animated:YES];
        }else{
            NSString *error = responseObject[@"error"];
            NSLog(@"error sign up:%@", error);
            PopHintViewController *popError = [[PopHintViewController alloc] initWithText:error];
            [self addChildViewController:popError];
            [self.view addSubview:popError.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_loadingViewController stop];
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
