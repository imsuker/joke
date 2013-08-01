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

#define key_default_visit_id 1

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
    NSUserDefaults *storage =  [NSUserDefaults standardUserDefaults];
    _visitId = [storage stringForKey:@"visit_joke_id"];
    if(!_visitId){
        _visitId = key_default_visit_id;
    }
    [self fetchJoke];
}
//获取joke
-(void)fetchJoke{
    NSString *urlString = [iApi sharedInstance].content;
    urlString = [iApi addUrl:urlString key:@"id" value:[NSString stringWithFormat:@"%d",_visitId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"==fetchJoke fetch begin:%@", [url description]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"==fetchJoke fetch success:%@", [JSON description]);
        _jokeModel = [[JokeModel alloc] initWithDictionary:JSON[@"data"]];
        _jokeModel.jokeId = _visitId;
        [self showJoke];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"===fetchJoke fetch fail:%@", error);
    }];
    [operation start];
}
-(void)showJoke{
    _yFree = _labelTitle.bounds.size.height;
    NSArray *audios = _jokeModel.audios;
    [audios enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AudioViewController *audio = [[AudioViewController alloc] initWithNibName:nil bundle:nil];
        audio.urlAudio = obj;
        audio.nameSource = [NSString stringWithFormat:@"/%d_%d.mp3",_visitId, idx];
        audio.y = _yFree;
        _yFree += audio.heightView;
        NSLog(@"====AudioViewController prepared!!!");
        [self addChildViewController:audio];
        [self.view addSubview:audio.view];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
