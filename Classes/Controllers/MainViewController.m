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
#import "SettingsViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "NoticeViewController.h"

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
//        if(_lastJokeViewController){
//            [self tapButtonNext:nil];
//        }
        [self showLoadingView];
        [self fetchLastid];
    }
}

-(void)showSupportDialog{
    _alertViewSupport = [[UIAlertView alloc] initWithTitle:nil message:JD_WORD_SUPPORT_MESSAGE delegate:self cancelButtonTitle:JD_WORD_SUPPORT_REFUSE otherButtonTitles:JD_WORD_SUPPORT_GO, nil];
    [_alertViewSupport show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(_alertViewSupport == alertView){
        if([buttonTitle isEqualToString:JD_WORD_SUPPORT_GO]){
            if(NSClassFromString(@"SKStoreProductViewController") == nil){
                [self supportAppStore];
                return;
            }
            SKStoreProductViewController *sk = [[SKStoreProductViewController alloc] init];
            sk.delegate = self;
            LoadingViewController *loadingView = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
            [self addChildViewController:loadingView];
            [self.view addSubview:loadingView.view];
            __weak LoadingViewController *weakLoadingView = loadingView;
            [sk loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:JD_CONFIG_APPLE_ID} completionBlock:^(BOOL result, NSError *error) {
                [weakLoadingView stop];
                if(error){
                    [self supportAppStore];
                }else{
                    [self presentModalViewController:sk animated:YES];
                }
            }];
        }
    }
}
-(void)supportAppStore{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",JD_CONFIG_APPLE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}
-(void)showSupportGuide{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSString *storageVersion = [storage stringForKey:@"key_storage_bundle_version"];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if(![bundleVersion isEqualToString:storageVersion]){
        [storage setValue:bundleVersion forKey:@"key_storage_bundle_version"];
        [storage setInteger:0 forKey:@"key_storage_support_times"];
        [storage synchronize];
        return;
    }
    NSInteger times = [storage integerForKey:@"key_storage_support_times"];
    if(times == 5 || times == 15){
        [self showSupportDialog];
    }
    NSLog(@"times:%d",times);
    times ++;
    [storage setInteger:times forKey:@"key_storage_support_times"];
    [storage synchronize];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showButtonsEnable];
    [self performSelector:@selector(showSupportGuide) withObject:nil afterDelay:10.0];
    //设置左侧logo
    UIImageView *viewLeftBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 127, 30)];
    viewLeftBar.image = [UIImage imageNamed:@"logo"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewLeftBar];
    
    [self showLoadingView];
    
    NSString *urlString = [iApi sharedInstance].constant;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSInteger code = [JSON[@"code"] integerValue];
        NSDictionary *data = JSON[@"data"];
        if(code == 1){
            [UserModel shareInstance].price = data[@"vipPrice"];
            [UserModel shareInstance].maxCountShouldVisit = [data[@"freeShow"] integerValue];
        }
        [self fetchLastid];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [_loadingViewController stop];
        [self fetchLastid];
    }];
    [operation start];
    //预读取shareSDK配置
    [ShareSDK waitAppSettingComplete:^{
        
    }];
}

-(void)fetchLastid{
    if(![UserModel shareInstance].isLogin){
        [self showMainFlow];
        return;
    }
    NSString *urlString = [iApi sharedInstance].lastid;
    urlString = [iApi addUrl:urlString key:@"token" value:[UserModel shareInstance].token];
    urlString = [iApi addUrl:urlString key:@"userid" value:[NSString stringWithFormat:@"%d",[UserModel shareInstance].userId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSInteger code = [JSON[@"code"] integerValue];
        NSDictionary *data = JSON[@"data"];
        if(code == 1){
            NSInteger lastId = [data[@"id"] integerValue];
            [[UserModel shareInstance] saveLastId:lastId];
        }
        [self showMainFlow];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self showMainFlow];
    }];
    [operation start];
}
-(void)showMainFlow{
    [_loadingViewController stop];
    //获取公告
    [self fetchNotice];
    
    //设置rightbar样式
    [self showRightBar];
    
    _visitId = [UserModel shareInstance].visitId;
    _next = 0;
    _prev = 0;
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
-(void)showLoadingView{
    if(!_loadingViewController){
        _loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    }
    [_loadingViewController stop];
    [self addChildViewController:_loadingViewController];
    [self.view addSubview:_loadingViewController.view];
}
//获取joke
-(void)fetchJoke{
    [self showLoadingView];
    NSString *urlString = [iApi sharedInstance].content;
    urlString = [iApi addUrl:urlString key:@"id" value:[NSString stringWithFormat:@"%d",_visitId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"==fetchJoke fetch begin:%@", [url description]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [_loadingViewController stop];
        NSLog(@"==fetchJoke fetch success:%@", [JSON description]);
        JokeModel *jokeModel = [[JokeModel alloc] initWithDictionary:JSON[@"data"]];
        jokeModel.jokeId = _visitId;
        [UserModel shareInstance].visitId = _visitId;
        [[UserModel shareInstance] visitJoke:_visitId];
        [self showJoke:jokeModel];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [_loadingViewController stop];
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
    SettingsViewController *set = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:set animated:YES];
}

-(IBAction)handleTapShare:(id)sender{
    NSLog(@"====shareSDK getAppSettings!");
    [ShareSDK waitAppSettingComplete:^{
        NSLog(@"====shareSDK getAppSettings success!");
        NSString *url = [NSString stringWithFormat:@"http://www.yuyinxiaohua.com/archives/%d", _visitId];
        NSString *content = [NSString stringWithFormat:@"我在【语音笑话网】听的这个笑话《%@》很搞笑，你也来听听吧 %@",_jokeViewController.jokeModel.title, url];
        
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:@"语音笑话网"
                                                    image:nil
                                                    title:@"语音笑话网"
                                                      url:url
                                              description:@"最用心讲笑话的语音笑话网站，真人语音讲笑话、语音笑话大全"
                                                mediaType:SSPublishContentMediaTypeNews];
        //添加QQ空间分享内容
        NSString *urlPic = _jokeViewController.urlPicQQ;
        if(urlPic == nil) {
            urlPic = @"";
        }
        [publishContent addQQSpaceUnitWithTitle:INHERIT_VALUE url:INHERIT_VALUE site:INHERIT_VALUE fromUrl:INHERIT_VALUE comment:INHERIT_VALUE summary:INHERIT_VALUE image:[ShareSDK imageWithUrl:urlPic] type:INHERIT_VALUE playUrl:INHERIT_VALUE nswb:INHERIT_VALUE];
        
        //添加微博分享内容
        id<ISSCAttachment> imageWeibo;
        if(_jokeViewController.imageViewPicWeibo){
            imageWeibo = [ShareSDK jpegImageWithImage:_jokeViewController.imageViewPicWeibo.image quality:1.0];
        }
        NSString *contentWeibo = [NSString stringWithFormat:@"我在【语音笑话网】听的这个笑话《%@》很搞笑，你也来听听吧 （分享自 @语音笑话网） http://www.yuyinxiaohua.com/archives/%d",_jokeViewController.jokeModel.title,_visitId];
        [publishContent addSinaWeiboUnitWithContent:contentWeibo image:imageWeibo];
        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"分享到"
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
                             shareList:[ShareSDK getShareListWithType:ShareTypeWeixiTimeline, ShareTypeQQSpace, ShareTypeSinaWeibo, ShareTypeWeixiSession, ShareTypeQQ, nil]
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
-(void)fetchNotice{
    NSInteger noticeId = [UserModel shareInstance].noticeId;
    NSString *urlString = [iApi sharedInstance].notice;
    urlString = [iApi addUrl:urlString key:@"id" value:[NSString stringWithFormat:@"%d",noticeId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSInteger code = [JSON[@"code"] integerValue];
        if(code == 1){
            [UserModel shareInstance].noticeId = [JSON[@"data"][@"id"] integerValue];
            [self showNotice:JSON[@"data"][@"url"]];
        }else{

        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

    }];
    [operation start];
}
- (void)showNotice:(NSString *)url{
    NoticeViewController *notice = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:notice];
    notice.url = url;
    [self.navigationController presentModalViewController:nav animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
