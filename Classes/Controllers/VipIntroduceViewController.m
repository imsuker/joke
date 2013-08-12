//
//  VipIntroduceViewController.m
//  Joke
//
//  Created by cao on 13-8-12.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "VipIntroduceViewController.h"

@interface VipIntroduceViewController ()

@end

@implementation VipIntroduceViewController

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
    
    [Util adjustBackgroundImage:_buttonRegistered];
    _viewContent.backgroundColor = [UIColor colorWithPatternImage:[Util adjustImage:[UIImage imageNamed:@"contentbox"]]];
}
;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
