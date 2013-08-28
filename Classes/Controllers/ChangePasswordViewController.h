//
//  ChangePasswordViewController.h
//  Joke
//
//  Created by cao on 13-8-28.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"


@interface ChangePasswordViewController : UIViewController{
    IBOutlet UITextField *_textFieldOldPassword;
    IBOutlet UITextField *_textFieldNewPassword;
    IBOutlet UIButton *_buttonSave;
    LoadingViewController *_loadingViewController;
}

@end
