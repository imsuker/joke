//
//  CollectJokeViewController.m
//  Joke
//
//  Created by cao on 13-8-21.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "CollectJokeViewController.h"
#import "JokeViewController.h"
#import "AFNetworking.h"
#import "iApi.h"
#import "JokeModel.h"
#import "UserModel.h"
#import "NavigatorBackBar.h"
#import "NavigatorTitleLabel.h"
@interface CollectJokeViewController ()

@end

@implementation CollectJokeViewController

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
    
    //返回按钮
    NavigatorBackBar *backBar = [[NavigatorBackBar alloc] initWithNavigatorController:self.navigationController];
    self.navigationItem.leftBarButtonItem = backBar;
    
    //标题
    NavigatorTitleLabel *titleLabel = [[NavigatorTitleLabel alloc] init];
    titleLabel.text = @"正文";
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    [self fetchJoke];
    
    
    // Do any additional setup after loading the view from its nib.

}
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
        [LoadingViewController Stop:_loadingViewController];
        NSLog(@"==fetchJoke fetch success:%@", [JSON description]);
        JokeModel *jokeModel = [[JokeModel alloc] initWithDictionary:JSON[@"data"]];
        jokeModel.jokeId = _visitId;
        [UserModel shareInstance].visitId = _visitId;
        [[UserModel shareInstance] visitJoke:_visitId];
        [self showJoke:jokeModel];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [LoadingViewController Stop:_loadingViewController];
        NSLog(@"===fetchJoke fetch fail:%@", error);
    }];
    [operation start];
}
-(void)showJoke:(JokeModel *)jokeModel{
    JokeViewController *_jokeViewController = [[JokeViewController alloc] initWithNibName:@"JokeViewController" bundle:nil];
    _jokeViewController.jokeModel = jokeModel;
    [self addChildViewController:_jokeViewController];
//    _jokeViewController.view.frame = _viewJoke.bounds;
    [self.view addSubview:_jokeViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
