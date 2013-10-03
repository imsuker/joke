//
//  IAP.h
//  Joke
//
//  Created by cao on 13-10-3.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentQueue.h>
#import "ModelLoadingViewController.h"

@interface IAP : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    ModelLoadingViewController *_loadingView;
}

+(IAP *) sharedInstance;
-(void)start;

@end
