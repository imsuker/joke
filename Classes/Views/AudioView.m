//
//  AudioView.m
//  Joke
//
//  Created by Gukw on 7/12/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "AudioView.h"

@implementation AudioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initUI{
    self.frame = CGRectMake(0, 0, 100, 50);
    self.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}
-(IBAction)tap:(id)sender{
    if(!_player) {
      return;
    }
    if(_player.playing){
        [self endPlay];
        _player.currentTime = 0;
        [_player stop];
    }else{
        [self startPlay];
        [_player play];
    }
}
-(void)loadPlayer{
    NSString *sUrl = [self.delegate resourceForAudioView:self];
    NSURL *url = [NSURL URLWithString:sUrl];
    //如果本地有了，才加载
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(error != nil){
        NSLog(@"==AudioView play audio error:%@", [error description]);
        return;
    }
    [self showDuration];
    _player.delegate = self;
}
-(void)showDuration{
    if(!_labelDuration){
        _labelDuration = [[UILabel alloc] init];
        [self addSubview:_labelDuration];
        _labelDuration.frame = CGRectMake(self.bounds.size.width, 0, 0, 0);
    }
    _labelDuration.text = [NSString stringWithFormat:@"%d''",(NSInteger)_player.duration];
    [_labelDuration sizeToFit];
    if(!_imageViewVoice){
        _imageViewVoice = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        [self addSubview:_imageViewVoice];
        _imageVoiceDefault = [UIImage imageNamed:@""];
        _imageViewVoice.image = _imageVoiceDefault;
        _imageViewVoice.backgroundColor = [UIColor whiteColor];
    }
}

-(void)showResource{
    [self startFetchResource];
    NSString *sUrl = [self.delegate resourceForAudioView:self];
    NSURL *url = [NSURL URLWithString:sUrl];
    if(url == nil) {
        NSLog(@"==AudioView 获取音频的filePath出错");
        return;
    }
    //检查本地是否有该资源
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:sUrl]){
        [self.delegate fetchRemoteResourceOfAudioView:self];
        return;
    }
    [self endFetchResource];
}
-(void)startFetchResource{
    self.backgroundColor = [UIColor blackColor];
    NSLog(@"==AudioView startFetchResource");
}
-(void)endFetchResource{
    NSLog(@"==AudioView endFetchResource");
    self.backgroundColor = [UIColor greenColor];
    [self loadPlayer];
}
-(void)errorFetchResource{
    self.backgroundColor = [UIColor redColor];
}
-(void)startPlay{
    NSLog(@"==AudioView startPlay");
    _indexVoice = 1;
    _timerVoice = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(voiceChanged) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timerVoice forMode:NSDefaultRunLoopMode];
}
-(void)endPlay{
    [_timerVoice invalidate];
    _imageViewVoice.backgroundColor = [UIColor whiteColor];
    NSLog(@"==AudioView endPlay");
}
-(void)voiceChanged{
    if(!_imageVoice1){
        _imageVoice1 = [UIImage imageNamed:@""];
        _imageVoice2 = [UIImage imageNamed:@""];
        _imageVoice3 = [UIImage imageNamed:@""];
    }
    if(_indexVoice == 1){
        _imageViewVoice.image = _imageVoice1;
        _imageViewVoice.backgroundColor = [UIColor redColor];
    }
    if(_indexVoice == 2){
        _imageViewVoice.image = _imageVoice2;
        _imageViewVoice.backgroundColor = [UIColor purpleColor];
    }
    if(_indexVoice == 3){
        _imageViewVoice.image = _imageVoice3;
        _imageViewVoice.backgroundColor = [UIColor blueColor];
    }
    _indexVoice++;
    if(_indexVoice >3){
        _indexVoice = 1;
    }
}
@end
