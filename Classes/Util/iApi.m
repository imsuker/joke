//
//  iApi.m
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "iApi.h"

//baseURl
#define API_BASE @"http://yuyinxiaohua.com"

@implementation iApi
#pragma mark - private method
-(NSString *)prefix:(NSString *)prefix{
    return [self baseUrl:API_BASE prefix:prefix];
}

-(NSString *)baseUrl:(NSString *)base_url prefix:(NSString *)prefix{
    NSString *baseUrl = [@"" stringByAppendingString:base_url];
    if(prefix!=nil){
        baseUrl = [baseUrl stringByAppendingString:prefix];
    }
    NSString *url = [iApi addCommonUrl:baseUrl];
    return url;
}


#pragma mark - static method
static iApi * instance;
+ (iApi *) sharedInstance {
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[iApi alloc] init];
            }
        }
    }
    return instance;
}
+(NSString *)addCommonUrl:(NSString *)base_url{
    NSString *url = [iApi addUrl:base_url params:@{
    }];
    return url;
}
+(NSString *)addUrl:(NSString *)url key:(NSString *)key value:(NSString *)value{
    if(value == nil || [@"" isEqual:value]){
        value = @"";
    }
    if(![value isKindOfClass:[NSObject class]]){
        NSLog(@"*************************************************************");
        NSLog(@"*************************************************************");
        NSLog(@"*************************************************************");
        NSLog(@"value is wrong, url is %@, key is %@", url ,key);
        return url;
    }else{
        value = [NSString stringWithFormat:@"%@", value];
    }
    NSRange range = [url rangeOfString:@"?"];
    if(range.location == NSNotFound){
        url = [url stringByAppendingString:@"?"];
    }
    if([url hasSuffix:@"?"]){
        return [url stringByAppendingFormat:@"%@=%@", key, [value encodeURIComponent]];
    }else{
        return [url stringByAppendingFormat:@"&%@=%@", key, [value encodeURIComponent]];
    }
}
+(NSString *)addUrl:(NSString *)url params:(NSDictionary *)params{
    NSArray *keys = [params allKeys];
    for(NSString *key in keys){
        url = [iApi addUrl:url key:key value:params[key]];
    }
    return url;
}
-(NSURL *)baseUrl{
    return [NSURL URLWithString:API_BASE];
}

-(NSString *)content{
    NSString *url = [self prefix:nil];
    url = [iApi addUrl:url key:@"api" value:@"content"];
    return url;
}
-(NSString *)login{
    NSString *url = [self prefix:nil];
    url = [iApi addUrl:url key:@"api" value:@"signin"];
    return url;
}
-(NSString *)allCollects{
    NSString *url = [self prefix:nil];
    url = [iApi addUrl:url key:@"api" value:@"allcollects"];
    return url;
}
-(NSString *)collects{
    NSString *url = [self prefix:nil];
    url = [iApi addUrl:url key:@"api" value:@"collects"];
    return url;
}
-(NSString *)notice{
    NSString *url = [self prefix:nil];
    url = [iApi addUrl:url key:@"api" value:@"notice"];
    return url;
}
-(NSString *)constant{
    NSString *url = [self prefix:nil];
    url = [iApi addUrl:url key:@"api" value:@"constant"];
    return url;
}
@end
