//
//  ChangePasswordViewController.m
//  Joke
//
//  Created by cao on 13-8-28.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NavigatorTitleLabel.h"
#import "NavigatorBackBar.h"
#import "PopHintViewController.h"
#import "AFNetworking.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
    
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"修改密码";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    //返回按钮
    NavigatorBackBar *backBar = [[NavigatorBackBar alloc] initWithNavigatorController:self.navigationController];
    self.navigationItem.leftBarButtonItem = backBar;
    
    //提交按钮
    [Util adjustBackgroundImage:_buttonSave];
    
    //输入框背景图
    [Util adjustTextFieldBackground:_textFieldOldPassword];
    [Util adjustTextFieldBackground:_textFieldNewPassword];
    
    //输入框内部左侧边距
    [Util adjustTextFieldLeftPadding:_textFieldOldPassword];
    [Util adjustTextFieldLeftPadding:_textFieldNewPassword];
}
-(IBAction)handleTapSave:(id)sender{
    NSString *oldPassword = _textFieldOldPassword.text;
    NSString *newpssword = _textFieldNewPassword.text;
    if([oldPassword isEqualToString:@""] || [newpssword isEqualToString:@""]){
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
                             @"oldpassword" : oldPassword,
                             @"newpassword" : newpssword,
                             @"api" : @"changepassword"
                             };
    [client postPath:@"/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"login reqeust finish, result = %@", [responseObject description]);
        NSInteger code = [responseObject[@"code"] integerValue];
        [LoadingViewController stop:_loadingViewController];
        if(code == 1){
            PopHintViewController *popSuccess = [[PopHintViewController alloc] initWithText:@"修改成功"];
            [self addChildViewController:popSuccess];
            [self.view addSubview:popSuccess.view];
        }else{
            NSString *error = responseObject[@"error"];
            NSLog(@"error login:%@", error);
            PopHintViewController *popError = [[PopHintViewController alloc] initWithText:error];
            [self addChildViewController:popError];
            [self.view addSubview:popError.view];        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"login fail");
        [LoadingViewController stop:_loadingViewController];
        PopHintViewController *popError = [[PopHintViewController alloc] initWithPopStyle:PopStyleBadNetWork];
        [self addChildViewController:popError];
        [self.view addSubview:popError.view];
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
