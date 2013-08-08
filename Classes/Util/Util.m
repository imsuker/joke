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
+(void)logDealloc:(id)object{
    NSLog(@"***************");
    NSLog(@"%@ is dealloc!", NSStringFromClass([object class]));
    NSLog(@"***************");
}
@end
