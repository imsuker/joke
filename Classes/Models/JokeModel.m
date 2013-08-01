//
//  JokeModel.m
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "JokeModel.h"

@implementation JokeModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [super setValue:value forUndefinedKey:key];
}
-(void)dealloc{
    [Util logDealloc:self];
}
@end
