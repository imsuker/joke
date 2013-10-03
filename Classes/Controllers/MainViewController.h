//
//  MainViewController.h
//  Joke
//
//  Created by Gukw on 7/11/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeViewController.h"
#import "LoadingViewController.h"
#import "LastJokeViewController.h"
#import <StoreKit/StoreKit.h>

@interface MainViewController : UIViewController<UIAlertViewDelegate,SKStoreProductViewControllerDelegate>{
    IBOutlet UIButton *_buttonPrev;
    IBOutlet UIButton *_buttonNext;
    IBOutlet UIView *_viewJoke;
    IBOutlet UIView *_viewLoginedRightBar;
    IBOutlet UIView *_viewNoLoginRightBar;
    NSInteger _visitId;
    JokeViewController *_jokeViewController;
    NSInteger _prev;
    NSInteger _next;
    LoadingViewController *_loadingViewController;
    LastJokeViewController *_lastJokeViewController;
    UIAlertView *_alertViewSupport;
    BOOL _ShareSDKLoading;
}


@property (nonatomic) BOOL isFromLogin;  //如果刚登陆完切回来，则继续下一条
@end
