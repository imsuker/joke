//
//  UserModel.m
//  Joke
//
//  Created by cao on 13-8-11.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#define default_value_key_visit_joke_id 1
#define key_visit_joke_id @"key_visit_joke_id"

#import "UserModel.h"
static UserModel *shareInstance;
@implementation UserModel
+(UserModel *)shareInstance{
    if(!shareInstance){
        shareInstance = [[UserModel alloc] init];
        [shareInstance initData];
    }
    return shareInstance;
}
-(void)initData{
    //初始化visitId
    NSUserDefaults *storage =  [NSUserDefaults standardUserDefaults];
    _visitId = [[storage stringForKey:key_visit_joke_id] integerValue];
    if(!_visitId){
        _visitId = default_value_key_visit_joke_id;
    }
}
@end
