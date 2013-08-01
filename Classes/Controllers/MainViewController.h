//
//  MainViewController.h
//  Joke
//
//  Created by Gukw on 7/11/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeView.h"
#import "JokeModel.h"
@interface MainViewController : UIViewController{
    NSInteger _visitId;
    JokeModel *_jokeModel;
    JokeView *_jokeView;
    NSInteger _yFree;  //当前可以画内容的y值
    IBOutlet UILabel *_labelTitle;
}

@end
