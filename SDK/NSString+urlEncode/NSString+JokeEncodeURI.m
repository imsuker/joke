//
//  NSString+JokeEncodeURI.m
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "NSString+JokeEncodeURI.h"

@implementation NSString (JokeEncodeURI)

//    http://stackoverflow.com/questions/8086584/objective-c-url-encoding
- (NSString*)encodeURIComponent {
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        NULL,
       (__bridge CFStringRef) self,
        NULL,
        CFSTR("!*'();:@&=+$,/?%#[]"),
        kCFStringEncodingUTF8));
    return escapedString;
}


@end