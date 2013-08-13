//
//  NavigatorTitleLabel.m
//  Joke
//
//  Created by cao on 13-8-13.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "NavigatorTitleLabel.h"

@implementation NavigatorTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:20.0];
    self.textColor = JD_FONT_COLOR_fff;
}
@end
