//
//  SettingsModel.h
//  Joke
//
//  Created by cao on 13-8-19.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#define JD_KEY_SETTINGS_Account @"account"
#define JD_KEY_SETTINGS_Collect @"collect"
#define JD_KEY_SETTINGS_About @"about"
#define JD_KEY_SETTINGS_feedback @"feedback"
#define JD_KEY_SETTINGS_support @"support"
#define JD_KEY_SETTINGS_logout @"logout"


@interface SettingsModel : NSObject{
    NSArray *_allItems;
}
-(NSInteger)numberOfSections;
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(NSString *)idOfRow:(NSInteger)row section:(NSInteger)section;
-(NSString *)nameOfRow:(NSInteger)row section:(NSInteger)section;
@end
