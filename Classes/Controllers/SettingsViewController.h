//
//  SettingsViewController.h
//  Joke
//
//  Created by cao on 13-8-19.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsModel.h"
#import "UMFeedback.h"
#import <StoreKit/StoreKit.h>


@interface SettingsViewController : UITableViewController<SKStoreProductViewControllerDelegate>{
    SettingsModel *_settingModel;
    NSInteger _newFeedback;
}
@end
