//
//  MainViewController.m
//  Joke
//
//  Created by Gukw on 7/11/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "AudioViewController.h"
#import "JokeModel.h"
#import "UserModel.h"
#import "VipIntroduceViewController.h"
#import "SettingsViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUser) name:JD_NOTIFICATION_RELOADUSER object:nil];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_isFromLogin){
        _isFromLogin = NO;
        if(_lastJokeViewController){
            [self tapButtonNext:nil];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置rightbar样式
    [self showRightBar];
    
    
    //设置左侧logo
    UIImageView *viewLeftBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 127, 30)];
    viewLeftBar.image = [UIImage imageNamed:@"logo"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewLeftBar];
    
    _visitId = [UserModel shareInstance].visitId;
    _next = 0;
    _prev = 0;
    [self showButtonsEnable];
    [self fetchJoke];
}
-(void)showRightBar{
    UIBarButtonItem *rightBar;
    if([UserModel shareInstance].isLogin){
        _viewLoginedRightBar.backgroundColor = [UIColor clearColor];
        UILabel *labelName = (UILabel *)[_viewLoginedRightBar viewWithTag:1];
        labelName.text = [UserModel shareInstance].userName;
        [labelName sizeToFit];
        rightBar = [[UIBarButtonItem alloc] initWithCustomView:_viewLoginedRightBar];
        _viewLoginedRightBar.frame = [Util adjustFrame:_viewLoginedRightBar.frame withWidth:30 + 10 + labelName.bounds.size.width];
        [_viewNoLoginRightBar setHidden:YES];
        [_viewLoginedRightBar setHidden:NO];
    }else{
        _viewNoLoginRightBar.backgroundColor = [UIColor clearColor];
        rightBar = [[UIBarButtonItem alloc] initWithCustomView:_viewNoLoginRightBar];
        [_viewNoLoginRightBar setHidden:NO];
        [_viewLoginedRightBar setHidden:YES];
    }
    self.navigationItem.rightBarButtonItem = rightBar;
    UITapGestureRecognizer *tapRightBar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLookUser)];
    [rightBar.customView addGestureRecognizer:tapRightBar];
}
//获取joke
-(void)fetchJoke{
    if(!_loadingViewController){
        _loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    }
    [self addChildViewController:_loadingViewController];
    [self.view addSubview:_loadingViewController.view];
    NSString *urlString = [iApi sharedInstance].content;
    urlString = [iApi addUrl:urlString key:@"id" value:[NSString stringWithFormat:@"%d",_visitId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"==fetchJoke fetch begin:%@", [url description]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [LoadingViewController stop:_loadingViewController];
        NSLog(@"==fetchJoke fetch success:%@", [JSON description]);
        JokeModel *jokeModel = [[JokeModel alloc] initWithDictionary:JSON[@"data"]];
        jokeModel.jokeId = _visitId;
        [UserModel shareInstance].visitId = _visitId;
        [[UserModel shareInstance] visitJoke:_visitId];
        [self showJoke:jokeModel];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [LoadingViewController stop:_loadingViewController];
        NSLog(@"===fetchJoke fetch fail:%@", error);
    }];
    [operation start];
}

-(void)showJoke:(JokeModel *)jokeModel{
    if(_lastJokeViewController){
        [_lastJokeViewController.view removeFromSuperview];
        [_lastJokeViewController removeFromParentViewController];
        _lastJokeViewController = nil;
    }
    if(_jokeViewController){
        [_jokeViewController.view removeFromSuperview];
        [_jokeViewController removeFromParentViewController];
    }
    _jokeViewController = [[JokeViewController alloc] initWithNibName:@"JokeViewController" bundle:nil];
    _prev = jokeModel.prev;
    _next = jokeModel.next;
    [self showButtonsEnable];
    _jokeViewController.jokeModel = jokeModel;
    [self addChildViewController:_jokeViewController];
    _jokeViewController.view.frame = _viewJoke.bounds;
    [_viewJoke addSubview:_jokeViewController.view];
}
-(void)showButtonsEnable{
    [_buttonPrev setEnabled:_prev?YES:NO];
    [_buttonNext setEnabled:_next?YES:NO];
}
-(IBAction)tapButtonPrev:(id)sender{
    if(!_lastJokeViewController){  // 如果当前非笑话内容，则上一条依然显示当前内容
        _visitId = _prev;
    }
    if(_visitId){
        [self fetchJoke];
    }
}
-(IBAction)tapButtonNext:(id)sender{
    if(_next && [[UserModel shareInstance] hasRightToVisit:_next]){
        _visitId = _next;
        [self fetchJoke];
    }else{
        NSLog(@"====can 't next");
        _buttonNext.enabled = NO;
        //todo has no right and show
        if(!_lastJokeViewController){
            _lastJokeViewController = [[LastJokeViewController alloc] initWithNibName:@"LastJokeViewController" bundle:nil];
            [self addChildViewController:_lastJokeViewController];
            _lastJokeViewController.view.frame = _viewJoke.bounds;
            [_viewJoke addSubview:_lastJokeViewController.view];
        }
    }
}
-(void)handleTapLookUser{
    if ([UserModel shareInstance].isLogin) {
        SettingsViewController *set = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:set animated:YES];
    }else{
        VipIntroduceViewController *vip = [[VipIntroduceViewController alloc] initWithNibName:@"VipIntroduceViewController" bundle:nil];
        [self.navigationController pushViewController:vip animated:YES];
    }
}

-(IBAction)handleTapShare:(id)sender{
    [ShareSDK waitAppSettingComplete:^{
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"
                                                              ofType:@"jpg"];
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:@"ShareSDK"
                                                      url:@"http://www.sharesdk.cn"
                                              description:@"这是一条测试信息"
                                                mediaType:SSPublishContentMediaTypeNews];
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                                  oneKeyShareList:nil
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:nil
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        [shareOptions setCameraButtonHidden:YES];
        [shareOptions setTopicButtonHidden:YES];
        [ShareSDK showShareActionSheet:nil
                             shareList:[ShareSDK getShareListWithType:ShareTypeQQ, ShareTypeSinaWeibo, ShareTypeWeixiSession, ShareTypeWeixiTimeline, nil]
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: shareOptions
                                result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSPublishContentStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSPublishContentStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                                }];
    }];
}
-(void)reloadUser{
    [self showRightBar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
