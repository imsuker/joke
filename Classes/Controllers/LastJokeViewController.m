//
//  LastJokeViewController.m
//  Joke
//
//  Created by cao on 13-8-16.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "LastJokeViewController.h"
#import "UserModel.h"
#import "SignUpViewController.h"
#import "PopHintViewController.h"

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
    NSString *price = [UserModel shareInstance].price;
    NSInteger maxCount = [UserModel shareInstance].maxCountShouldVisit;
    _labelBuy.text = [NSString stringWithFormat:_labelBuy.text, price];
    [_buttonBuy setTitle:[NSString stringWithFormat:_buttonBuy.titleLabel.text, price] forState:UIControlStateNormal];
    _labelTitle.text = [NSString stringWithFormat:_labelTitle.text, maxCount];
}

- (IBAction)handleTapBuy:(id)sender{
    if([UserModel shareInstance].isFree){
        SignUpViewController *signup = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
        [self.navigationController pushViewController:signup animated:YES];
    }else{
        //TODO tobuy
        PopHintViewController *pop = [[PopHintViewController alloc] initWithText:JD_WORD_NOSUPPORT_ALIPAY];
        [self addChildViewController:pop];
        [self.view addSubview:pop.view];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
