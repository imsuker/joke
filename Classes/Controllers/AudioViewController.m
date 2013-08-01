//
//  AudioViewController.m
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#define HEIGHT_AUDIO_VIEW 44

#import "AudioViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _heightView = HEIGHT_AUDIO_VIEW;
        _audioView = [[AudioView alloc] init];
        _audioView.delegate = self;
        _audioModel = [[AudioModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"====AudioViewController viewDidLoad");
    [self.view addSubview:_audioView];
    self.view.frame = CGRectMake(0, _y, 320, HEIGHT_AUDIO_VIEW);
    [_audioView showResource];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUrlAudio:(NSString *)urlAudio{
    _audioModel.url = [NSURL URLWithString:urlAudio];
    NSLog(@"=== audioviewController setUrlAudio:%@", urlAudio);
}
-(void)setNameSource:(NSString *)nameSource{
    _audioModel.nameResource = nameSource;
}
-(NSString *)resourceForAudioView:(AudioView *)viewAudio{
    return _audioModel.filePath;
}
-(void)fetchRemoteResourceOfAudioView:(AudioView *)viewAudio{
    [_audioView startFetchResource];
    [_audioModel fectchResourceWithBlock:^(id result, NSError *error) {
        if(result != nil){
            if(viewAudio){
                [viewAudio endFetchResource];
            }
        }else{
            if(viewAudio){
                [viewAudio errorFetchResource];
            }
        }
    }];
}
@end
