//
//  NavigatorBackBar.h
//  Joke
//
//  Created by cao on 13-8-13.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigatorBackBar : UIBarButtonItem{
    __weak UINavigationController *_navigatorController;
}
@property (nonatomic) BOOL dismiss;
-(id)initWithNavigatorController:(UINavigationController *)navigatorController;
@end
