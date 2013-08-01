//
//  JokeViewController.m
//  Joke
//
//  Created by Gukw on 8/1/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "JokeViewController.h"
#import "AudioViewController.h"

@interface JokeViewController ()

@end

@implementation JokeViewController

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
    
    _labelTitle.text = _jokeModel.title;
    [_labelTitle sizeToFit];
    _yFree = _labelTitle.bounds.size.height;
    NSArray *audios = _jokeModel.audios;
    [audios enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AudioViewController *audio = [[AudioViewController alloc] initWithNibName:nil bundle:nil];
        audio.urlAudio = obj;
        audio.nameSource = [NSString stringWithFormat:@"/%d_%d.mp3",_jokeModel.jokeId, idx];
        audio.y = _yFree;
        _yFree += audio.heightView;
        NSLog(@"====AudioViewController prepared!!!");
        [self addChildViewController:audio];
        [_scrollView addSubview:audio.view];
    }];
    _labelWord.text = _jokeModel.content;
    [_labelWord sizeToFit];
    _labelWord.frame = [Util adjustFrame:_labelWord.frame withY:_yFree];
    _yFree += _labelWord.bounds.size.height;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _yFree);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [Util logDealloc:self];
}
@end
