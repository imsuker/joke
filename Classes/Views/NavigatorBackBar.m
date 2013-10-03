//
//  NavigatorBackBar.m
//  Joke
//
//  Created by cao on 13-8-13.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "NavigatorBackBar.h"

@implementation NavigatorBackBar
-(id)initWithNavigatorController:(UINavigationController *)navigatorController{
    self = [super init];
    if(self){
        _navigatorController = navigatorController;
        [self initUI];
    }
    return self;
}
-(void)initUI{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    backView.userInteractionEnabled = YES;
    backView.image = [UIImage imageNamed:@"back"];
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBack)];
    self.customView = backView;
    [backView addGestureRecognizer:tapBack];
}
-(void)handleTapBack{
    if(_dismiss){
        [_navigatorController dismissModalViewControllerAnimated:YES];
    }else{
        [_navigatorController popViewControllerAnimated:YES];
    }
}
@end
