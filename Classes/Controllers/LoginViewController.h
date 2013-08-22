//
//  LoginViewController.h
//  Joke
//
//  Created by cao on 13-8-14.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"

@interface LoginViewController : UIViewController{
    IBOutlet UITextField *_textFieldAcount;
    IBOutlet UITextField *_textFieldPassword;
    IBOutlet UIButton *_buttonSubmit;
    LoadingViewController *_loadingViewController;
}

@end
