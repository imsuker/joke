//
//  MainViewController.h
//  Joke
//
//  Created by Gukw on 7/11/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeViewController.h"
@interface MainViewController : UIViewController{
    NSInteger _visitId;
    JokeViewController *_jokeViewController;
    NSInteger _prev;
    NSInteger _next;
    IBOutlet UIButton *_buttonPrev;
    IBOutlet UIButton *_buttonNext;
    IBOutlet UIView *_viewJoke;
}

@end
