//
//  CollectJokeViewController.h
//  Joke
//
//  Created by cao on 13-8-21.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"
@interface CollectJokeViewController : UIViewController{
    LoadingViewController *_loadingViewController;
}
@property (nonatomic) NSInteger visitId;

@end
