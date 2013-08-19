//
//  Util.m
//  Joke
//
//  Created by Gukw on 8/1/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "Util.h"

@implementation Util

+(CGRect)adjustFrame:(CGRect)frame withX:(NSInteger)x{
    frame.origin.x = x;
    return frame;
}
+(CGRect)adjustFrame:(CGRect)frame withY:(NSInteger)y{
    frame.origin.y = y;
    return frame;
}
+(CGRect)adjustFrame:(CGRect)frame widthX:(NSInteger)x withY:(NSInteger)y{
    frame.origin.x = x;
    frame.origin.y = y;
    return frame;
}
+(CGRect)adjustFrame:(CGRect)frame withHeight:(NSInteger)height{
    frame.size.height = height;
    return frame;
}
+(CGRect)adjustFrame:(CGRect)frame withWidth:(NSInteger)width{
    frame.size.width = width;
    return frame;
}
+(void)adjustBackgroundImage:(UIButton *)button{
    [Util adjustBackgroundImage:button control:UIControlStateNormal];
    [Util adjustBackgroundImage:button control:UIControlStateHighlighted];
    [Util adjustBackgroundImage:button control:UIControlStateSelected];
    [Util adjustBackgroundImage:button control:UIControlStateDisabled];
}
+(void)adjustBackgroundImage:(UIButton *)button control:(UIControlState)control{
    UIImage *image = [button backgroundImageForState:control];
    UIImage *newImage = [Util adjustImage:image];
    [button setBackgroundImage:newImage forState:control];
}
+(UIImage *)adjustImage:(UIImage *)image{
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2/image.scale, image.size.width/2/image.scale, image.size.height/2/image.scale, image.size.width/2/image.scale)];
    return newImage;
}
+(void)adjustTextFieldBackground:(UITextField *)textField{
    UIImage *backgroundImage = textField.background;
    UIImage *resizeImage = [Util adjustImage:backgroundImage];
    textField.background = resizeImage;
}
+(void)adjustTextFieldLeftPadding:(UITextField *)textField{
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    leftLabel.backgroundColor = [UIColor clearColor];
    textField.leftView = leftLabel;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
+(void)logDealloc:(id)object{
    NSLog(@"***************");
    NSLog(@"%@ is dealloc!", NSStringFromClass([object class]));
    NSLog(@"***************");
}
@end
