//
//  PopHintViewController.m
//  Joke
//
//  Created by cao on 13-8-17.
//  Copyright (c) 2013年 iphone. All rights reserved.
//



#import "PopHintViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PopHintViewController ()

@end

@implementation PopHintViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithText:(NSString *)text{
    self = [super initWithNibName:@"PopHintViewController" bundle:nil];
    if(self){
        _text = text;
    }
    return self;
}

-(id)initWithPopStyle:(PopStyle)popStyle{
    self = [super initWithNibName:@"PopHintViewController" bundle:nil];
    if(popStyle == PopStyleNotVip){
        _text = JD_WORD_NOVIP;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _viewBlack.layer.cornerRadius = 10;
    _viewBlack.layer.masksToBounds = YES;
    self.text = _text;
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

-(void)setText:(NSString *)text{
    _text = text;
    if(text){
        _label.text = text;
        [_label sizeToFit];
        _label.frame = [Util adjustFrame:_label.frame withY:(_viewBlack.bounds.size.height - _label.bounds.size.height)/2];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
