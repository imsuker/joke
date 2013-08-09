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


#define default_value_key_visit_joke_id 1
#define key_visit_joke_id @"key_visit_joke_id"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置背景样式
    self.navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topmenu"]];
    
    //设置rightbar样式
    UIImageView *viewRightBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 30, 30)];
    viewRightBar.image = [UIImage imageNamed:@"login-icon"];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:viewRightBar];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    //设置左侧logo
    UIView *viewLeftBar = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 127, 30)];
    viewLeftBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"logo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewLeftBar];
    
    //初始化visitId
    NSUserDefaults *storage =  [NSUserDefaults standardUserDefaults];
    _visitId = [[storage stringForKey:key_visit_joke_id] integerValue];
    if(!_visitId){
        _visitId = default_value_key_visit_joke_id;
        _next = 0;
        _prev = 0;
    }
    [self fetchJoke];
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
    if(_jokeViewController){
        [_jokeViewController.view removeFromSuperview];
        [_jokeViewController removeFromParentViewController];
    }
    _jokeViewController = [[JokeViewController alloc] initWithNibName:@"JokeViewController" bundle:nil];
    _prev = jokeModel.prev;
    _next = jokeModel.next;
    _jokeViewController.jokeModel = jokeModel;
    [self addChildViewController:_jokeViewController];
    _jokeViewController.view.frame = _viewJoke.bounds;
    [_viewJoke addSubview:_jokeViewController.view];
}
-(IBAction)tapButtonPrev:(id)sender{
    _visitId = _prev;
    if(_visitId){
        [self fetchJoke];
    }
}
-(IBAction)tapButtonNext:(id)sender{
    _visitId = _next;
    if(_visitId){
        [self fetchJoke];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
