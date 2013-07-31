//
//  MainViewController.h
//  Joke
//
//  Created by Gukw on 7/11/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioModel.h"
#import "AudioView.h"
#import "JokeModel.h"
@interface MainViewController : UIViewController<AudioViewDelegate>{
    NSMutableArray *_arrayAudioModels;
    NSMutableArray *_arrayAudioViews;
    NSString *_visitId;
    JokeModel *_jokemodel;
}

@end
