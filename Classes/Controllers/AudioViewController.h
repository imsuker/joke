//
//  AudioViewController.h
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioModel.h"
#import "AudioView.h"

@interface AudioViewController : UIViewController<AudioViewDelegate>{
    AudioModel *_audioModel;
    AudioView *_audioView;
}
@property (nonatomic) NSInteger y; //audioView所在纵坐标
@property (nonatomic) NSString *urlAudio; //mp3的url
@property (nonatomic) NSString *nameSource; //mp3的文件名
@property (nonatomic) NSInteger heightView; //音频的高度

@end
