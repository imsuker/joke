//
//  SettingsModel.m
//  Joke
//
//  Created by cao on 13-8-19.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "SettingsModel.h"
#import "UserModel.h"

@implementation SettingsModel
-(id)init{
    self = [super init];
    if(self){
        [self initData];
    }
    return self;
}
-(void)initData{
    NSDictionary *account = @{
                              @"id" : JD_KEY_SETTINGS_Account,
                              @"name" : @"我的账号"
                              };
    NSDictionary *collect = @{
                              @"id": JD_KEY_SETTINGS_Collect,
                              @"name" : @"我喜欢的"
                              };
    NSDictionary *about = @{
                            @"id": JD_KEY_SETTINGS_About,
                            @"name" : @"关于我们"
                            };
    NSDictionary *feedback = @{
                               @"id":JD_KEY_SETTINGS_feedback,
                               @"name":@"提个建议"
                               };
    NSDictionary *support = @{
                              @"id": JD_KEY_SETTINGS_support,
                              @"name": @"给个评分"
                              };
    NSDictionary *logout = @{
                             @"id": JD_KEY_SETTINGS_logout,
                             @"name":@"退出登录"
                             };
    if([UserModel shareInstance].isLogin){
        _allItems = @[
                      @[account,collect],
                      @[about,feedback,support],
                      @[logout]
                      ];
    }else{
        _allItems = @[
                      @[account],
                      @[about,feedback,support]
                      ];
    }
}
-(NSInteger)numberOfSections{
    return _allItems.count;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)_allItems[section]).count;
}
-(NSString *)idOfRow:(NSInteger)row section:(NSInteger)section{
    NSArray *items = _allItems[section];
    return items[row][@"id"];
}
-(NSString *)nameOfRow:(NSInteger)row section:(NSInteger)section{
    NSArray *items = _allItems[section];
    return items[row][@"name"];
}
-(NSIndexPath *)indexPathOfFeedback{
    NSIndexPath *path;
    if([UserModel shareInstance].isLogin){
       
    }else{
    }
     path = [NSIndexPath indexPathForRow:1 inSection:1];
    return path;
}
@end
