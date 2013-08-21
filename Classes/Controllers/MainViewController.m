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
        [self addChildViewController:_loadingViewController];
        [self.view addSubview:_loadingViewController.view];
    }
    
    NSString *urlString = [iApi sharedInstance].content;
    urlString = [iApi addUrl:urlString key:@"id" value:[NSString stringWithFormat:@"%d",_visitId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"==fetchJoke fetch begin:%@", [url description]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self stopLoadingViewController];
        NSLog(@"==fetchJoke fetch success:%@", [JSON description]);
        JokeModel *jokeModel = [[JokeModel alloc] initWithDictionary:JSON[@"data"]];
        jokeModel.jokeId = _visitId;
        [UserModel shareInstance].visitId = _visitId;
        [[UserModel shareInstance] visitJoke:_visitId];
        [self showJoke:jokeModel];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self stopLoadingViewController];
        NSLog(@"===fetchJoke fetch fail:%@", error);
    }];
    [operation start];
}
-(void)stopLoadingViewController{
    [_loadingViewController.view removeFromSuperview];
    [_loadingViewController removeFromParentViewController];
    _loadingViewController = nil;
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
    _visitId = _prev;
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

-(void)reloadUser{
    [self showRightBar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
