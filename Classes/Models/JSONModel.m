//
//  JSONModel.m
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel

- (id)initWithDictionary:(NSMutableDictionary *)jsonObject{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"***************************************");
    NSLog(@"====undefiend key :%@", key);
    NSLog(@"***************************************");
}
@end
