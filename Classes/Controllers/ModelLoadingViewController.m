//
//  ModelLoadingViewController.m
//  Joke
//
//  Created by cao on 13-10-4.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "ModelLoadingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ModelLoadingViewController ()

@end

@implementation ModelLoadingViewController

static ModelLoadingViewController * instance;
+ (ModelLoadingViewController *) sharedInstance {
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[ModelLoadingViewController alloc] initWithNibName:@"ModelLoadingViewController" bundle:Nil];
                [[UIApplication sharedApplication].keyWindow addSubview:instance.view];
                instance.view.hidden = YES;
            }
        }
    }
    return instance;
}


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
-(void)setText:(NSString *)text{
    _label.text = text;
}

-(void)show{
    self.view.hidden = NO;
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
    [_activity startAnimating];
}
-(void)hide{
    [_activity stopAnimating];
    self.view.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
