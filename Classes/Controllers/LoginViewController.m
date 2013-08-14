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
    
    //输入框背景图
    UIImage *backgroundImage = _textFieldAcount.background;
    UIImage *resizeBackgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(backgroundImage.size.height/2, backgroundImage.size.width/2, backgroundImage.size.height/2, backgroundImage.size.width/2)];
    _textFieldAcount.background = resizeBackgroundImage;
    _textFieldPassword.background = resizeBackgroundImage;
    
    //输入框内部左侧边距
    UILabel *leftLabelAccount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    leftLabelAccount.backgroundColor = [UIColor clearColor];
    _textFieldAcount.leftView = leftLabelAccount;
    _textFieldAcount.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *leftLabelPassword = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    leftLabelPassword.backgroundColor = [UIColor clearColor];
    _textFieldPassword.leftView = leftLabelPassword;
    _textFieldPassword.leftViewMode = UITextFieldViewModeAlways;
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
            //TODO show success
            NSLog(@"login success");
        }else{
            NSString *errmsg = responseObject[@"data"][@"errmsg"];
            NSLog(@"error login:%@", errmsg);
            //TODO show error
        }
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
