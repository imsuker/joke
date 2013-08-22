//
//  LoadingViewController.h
//  Joke
//
//  Created by cao on 13-8-10.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoadingViewController : UIViewController{
    IBOutlet UIView *_blackView;
}
+(void)Stop:(LoadingViewController *)loadingViewController;

@end
