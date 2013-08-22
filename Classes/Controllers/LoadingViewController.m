//
//  LoadingViewController.m
//  Joke
//
//  Created by cao on 13-8-10.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "LoadingViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _blackView.layer.cornerRadius = 10;
    _blackView.layer.masksToBounds = YES;
}
+(void)stop:(LoadingViewController *)loadingViewController{
    [loadingViewController.view removeFromSuperview];
    [loadingViewController removeFromParentViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
