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
//打dealloc的log
+(void)logDealloc:(id)object;
@end
