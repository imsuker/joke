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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay) name:NOTIFICATION_STOP_PLAYER object:nil];
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
    self.frame = CGRectMake(0, 0, 190, 44);
    _imageVoiceBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
    [self addSubview:_imageVoiceBackground];
    [self setStatusBackgroundLoading:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}
-(void)setStatusBackgroundLoading:(BOOL)statusBackgroundLoading{
    NSLog(@"statusBackgroundLoading:%d", statusBackgroundLoading);
    _statusBackgroundLoading = statusBackgroundLoading;
    if(statusBackgroundLoading == YES){
        _imageVoiceBackground.image = [UIImage imageNamed:@"sound-loading"];
    }else{
        _imageVoiceBackground.image = [UIImage imageNamed:@"sound-normal"];
    }
}
-(IBAction)tap:(id)sender{
    if(!_player) {
      return;
    }
    if(_player.playing){
        [self endPlay];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STOP_PLAYER object:nil];
        [self startPlay];
    }
}

-(void)loadPlayer{
    NSString *sUrl = [self.delegate resourceForAudioView:self];
    NSURL *url = [NSURL fileURLWithPath:sUrl];
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
        _labelDuration.font = [UIFont systemFontOfSize:14.0];
        _labelDuration.textColor = JD_FONT_COLOR_999;
        _labelDuration.frame = CGRectMake(self.bounds.size.width + 6, 10, 0, 0);
    }
    _labelDuration.text = [NSString stringWithFormat:@"%d''",(NSInteger)_player.duration];
    [_labelDuration sizeToFit];
    if(!_imageViewVoice){
        _imageViewVoice = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [self addSubview:_imageViewVoice];
        [self voiceToNomarl];
    }
}

-(void)showResource{
    NSString *sUrl = [self.delegate resourceForAudioView:self];
    if(sUrl == nil) {
        NSLog(@"==AudioView 获取音频的filePath出错:%@", sUrl);
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
-(void)voiceLoading{
    [self setStatusBackgroundLoading:!_statusBackgroundLoading];
}
-(void)startFetchResource{
    [self setStatusBackgroundLoading:YES];
    NSLog(@"==AudioView startFetchResource");
    _timerVoiceLoading = [NSTimer timerWithTimeInterval:0.6f target:self selector:@selector(voiceLoading) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timerVoiceLoading forMode:NSDefaultRunLoopMode];
}
-(void)endFetchResource{
    NSLog(@"==AudioView endFetchResource");
    [self setStatusBackgroundLoading:NO];
    [_timerVoiceLoading invalidate];
    [self loadPlayer];
}
-(void)errorFetchResource{
    NSLog(@"errorFetchAudio:%@", [self.delegate resourceForAudioView:self]);
    [self setStatusBackgroundLoading:NO];
    [_timerVoiceLoading invalidate];
}
-(void)startPlay{
    if(_player && !_player.playing){
        NSLog(@"==AudioView startPlay");
        _indexVoice = 1;
        _timerVoice = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(voiceChanged) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timerVoice forMode:NSDefaultRunLoopMode];
        [_player play];
    }
}
-(void)endPlay{
    if(_player && _player.playing){
        [_timerVoice invalidate];
        [self voiceToNomarl];
        _player.currentTime = 0;
        [_player stop];
        NSLog(@"==AudioView endPlay");
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(_player == player){
        [_timerVoice invalidate];
        [self voiceToNomarl];
    }
}
-(void)voiceChanged{
    if(!_imageVoice1){
        _imageVoice1 = [UIImage imageNamed:@"playingwave-a"];
        _imageVoice2 = [UIImage imageNamed:@"playingwave-b"];
        _imageVoice3 = [UIImage imageNamed:@"playingwave-c"];
    }
    if(_indexVoice == 1){
        _imageViewVoice.image = _imageVoice1;
    }
    if(_indexVoice == 2){
        _imageViewVoice.image = _imageVoice2;
    }
    if(_indexVoice == 3){
        _imageViewVoice.image = _imageVoice3;
    }
    _indexVoice++;
    if(_indexVoice >3){
        _indexVoice = 1;
    }
}
-(void)voiceToNomarl{
    _imageViewVoice.image = [UIImage imageNamed:@"wave-normal"];
}
-(void)dealloc{
    [Util logDealloc:self];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    NSLog(@"willMoveTosuperView");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_STOP_PLAYER object:nil];
    [_timerVoiceLoading invalidate];
    [_timerVoice invalidate];
}
@end
