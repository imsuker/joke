//
//  VipIntroduceViewController.h
//  Joke
//
//  Created by cao on 13-8-12.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAP.h"

@interface VipIntroduceViewController : UIViewController{
    IBOutlet UIButton *_buttonRegistered;
    IBOutlet UIView *_viewContent;
    IBOutlet UILabel *_labelNow;
    IBOutlet UIButton *_buttonBuy;
    IBOutlet UILabel *_labelDesc;
    IAP *_iap;
}

@end
