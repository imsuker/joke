//
//  LastJokeViewController.m
//  Joke
//
//  Created by cao on 13-8-16.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "LastJokeViewController.h"
#import "UserModel.h"

@interface LastJokeViewController ()

@end

@implementation LastJokeViewController

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
    NSInteger price = [UserModel shareInstance].price;
    _labelBuy.text = [NSString stringWithFormat:_labelBuy.text, price];
    _buttonBuy.titleLabel.text = [NSString stringWithFormat:_buttonBuy.titleLabel.text, price];
}

- (IBAction)handleTapBuy:(id)sender{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
