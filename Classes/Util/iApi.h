//
//  iApi.h
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iApi : NSObject

@property (nonatomic, readonly) NSString *content;





+(iApi *) sharedInstance;
+(NSString *)addUrl:(NSString *)url key:(NSString *)key value:(NSString *)value;
+(NSString *)addUrl:(NSString *)url params:(NSDictionary *)params;
-(NSString *)baseUrl:(NSString *)base_url prefix:(NSString *)prefix;
+(NSString *)addCommonUrl:(NSString *)base_url;


@end
