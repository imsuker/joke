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
    if(popStyle == PopStyleBadNetWork){
        _text = JD_WORD_BADNETWORK;
    }
    if(popStyle == PopStyleBadInput){
        _text = JD_WORD_BADINPUT;
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
    if(_text == nil){
        _text = JD_WORD_BADNETWORK;
    }
    [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
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
        CGFloat width = _label.frame.size.width;
        [_label sizeToFit];
        _label.textAlignment = UITextAlignmentCenter;
        _label.frame = CGRectMake(_label.frame.origin.x, (_viewBlack.bounds.size.height - _label.bounds.size.height)/2, width, _label.frame.size.height);
//        _label.frame = [Util adjustFrame:_label.frame wi withY:(_viewBlack.bounds.size.height - _label.bounds.size.height)/2];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
