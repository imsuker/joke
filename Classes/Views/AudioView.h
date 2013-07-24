//
//  AudioView.h
//  Joke
//
//  Created by Gukw on 7/12/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AudioView;

@protocol AudioViewDelegate <NSObject>

@required
-(NSString *)resourceForAudioView:(AudioView *)viewAudio;  //获取该video的播放资源
-(void)fetchRemoteResourceOfAudioView:(AudioView *) viewAudio; //当本地没有资源时，则从网络获取资源
@end


@interface AudioView : UIView<AVAudioPlayerDelegate>{
    AVAudioPlayer *_player;
    UILabel *_labelDuration;
    UIImageView *_imageViewVoice;
    UIImage *_imageVoiceDefault;
    UIImage *_imageVoice1;
    UIImage *_imageVoice2;
    UIImage *_imageVoice3;
    NSTimer *_timerVoice;
    NSInteger _indexVoice;
}
@property (nonatomic,weak) id <AudioViewDelegate> delegate;



//加载资源
-(void)showResource;//在绑定resource资源后，开始加载并展示

//以下为ui相关

-(void)startFetchResource;//开始获取资源
-(void)endFetchResource;//结束获取资源
-(void)errorFetchResource;//获取资源失败
-(void)startPlay;//开始播放
-(void)endPlay;//结束播放
@end
