//
//  MainViewController.m
//  Joke
//
//  Created by Gukw on 7/11/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

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
    _arrayAudioModels = [NSMutableArray array];
    _arrayAudioViews = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    AudioView *viewAudio = [[AudioView alloc] init];
    viewAudio.delegate = self;
    [self.view addSubview: viewAudio];
    AudioModel *modelAudio = [[AudioModel alloc] init];
//http://yuyin.oss.aliyuncs.com/meiyifuchuan.mp3
//http://yuyin.oss.aliyuncs.com/shangren.mp3
//http://yuyin.oss.aliyuncs.com/tuixiaoyuan.mp3
//http://yuyin.oss.aliyuncs.com/xiangwen.mp3
    modelAudio.url = [NSURL URLWithString:@"http://yuyin.oss.aliyuncs.com/meiyifuchuan.mp3"];
    modelAudio.nameResource = @"meiyifuchuan.mp3";
    [_arrayAudioModels addObject:modelAudio];
    [_arrayAudioViews addObject:viewAudio];
    
    AudioView *viewAudio1 = [[AudioView alloc] initWithFrame:CGRectMake(0, 50, 0, 0)];
    viewAudio1.delegate = self;
    [self.view addSubview: viewAudio1];
    AudioModel *modelAudio1 = [[AudioModel alloc] init];
    modelAudio1.url = [NSURL URLWithString:@"http://yuyin.oss.aliyuncs.com/shangren.mp3"];
    modelAudio1.nameResource = @"shangren.mp3";
    [_arrayAudioModels addObject:modelAudio1];
    [_arrayAudioViews addObject:viewAudio1];
    
    
    [viewAudio showResource];
    [viewAudio1 showResource];
    
}


-(NSString *)resourceForAudioView:(AudioView *)viewAudio{
    NSInteger index = [_arrayAudioViews indexOfObject:viewAudio];
    if(index != NSNotFound){
        AudioModel *audioModel = (AudioModel *)_arrayAudioModels[index];
        return audioModel.filePath;
    }
    return nil;
}
-(void)fetchRemoteResourceOfAudioView:(AudioView *)viewAudio{
    NSInteger index = [_arrayAudioViews indexOfObject:viewAudio];
    if(index != NSNotFound){
        AudioModel *audioModel = (AudioModel *)_arrayAudioModels[index];
        [viewAudio startFetchResource];
        [audioModel fectchResourceWithBlock:^(id result, NSError *error) {
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
