//
//  Util.h
//  Joke
//
//  Created by Gukw on 8/1/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
//根据位置改frame
+(CGRect)adjustFrame:(CGRect)frame withX:(NSInteger)x;
+(CGRect)adjustFrame:(CGRect)frame withY:(NSInteger)y;
+(CGRect)adjustFrame:(CGRect)frame widthX:(NSInteger)x withY:(NSInteger)y;
+(CGRect)adjustFrame:(CGRect)frame withHeight:(NSInteger)height;
+(CGRect)adjustFrame:(CGRect)frame withWidth:(NSInteger)width;
//打dealloc的log
+(void)logDealloc:(id)object;
//调增button的背景能够自动伸缩
+(void)adjustBackgroundImage:(UIButton *)button;
+(void)adjustBackgroundImage:(UIButton *)button control:(UIControlState)control;
+(UIImage *)adjustImage:(UIImage *)image;
//调整输入框的背景图片
+(void)adjustTextFieldBackground:(UITextField *)textField;
//调整输入框的左侧边距
+(void)adjustTextFieldLeftPadding:(UITextField *)textField;
@end
