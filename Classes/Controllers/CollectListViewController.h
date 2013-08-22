//
//  CollectViewController.h
//  Joke
//
//  Created by cao on 13-8-21.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"
#import "PullRefreshTableViewController.h"
@interface CollectListViewController : PullRefreshTableViewController{
    LoadingViewController *_loadingViewController;
    NSMutableArray *_collects;
    NSInteger _flag;
}

@end
