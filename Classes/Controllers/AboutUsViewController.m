//
//  AboutUsViewController.m
//  Joke
//
//  Created by cao on 13-8-29.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    NSString *name;
    if([[UIScreen mainScreen] bounds].size.height == 480){
        name = @"Default-568h";
    }else{
        name = @"Default";
    }
    _imageView.image = [UIImage imageNamed:name];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBack:)];
    [_imageView addGestureRecognizer:tap];
}

-(IBAction)handleTapBack:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
