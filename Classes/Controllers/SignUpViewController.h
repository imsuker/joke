//
//  SignUpViewController.h
//  Joke
//
//  Created by cao on 13-8-15.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"
#import <StoreKit/StoreKit.h>

@interface SignUpViewController : UIViewController{
    IBOutlet UITextField *_textFieldUserName;
    IBOutlet UITextField *_textFieldPassword;
    IBOutlet UITextField *_textFieldEmail;
    IBOutlet UIButton *_buttonSubmit;
    LoadingViewController *_loadingViewController;
}
@property (nonatomic) NSString *receipt;
@property (nonatomic) SKPaymentTransaction *transcation;
@end
