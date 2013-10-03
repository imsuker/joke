//
//  ModelLoadingViewController.h
//  Joke
//
//  Created by cao on 13-10-4.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelLoadingViewController : UIViewController{
    IBOutlet UIActivityIndicatorView *_activity;
    IBOutlet UILabel *_label;
    IBOutlet UIView *_blackView;
}
@property (nonatomic) NSString *text;
+(ModelLoadingViewController *) sharedInstance;
-(void)show;
-(void)hide;
@end
