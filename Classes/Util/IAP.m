//
//  IAP.m
//  Joke
//
//  Created by cao on 13-10-3.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "IAP.h"
#import "SignUpViewController.h"
#import "Base64.h"
#import "UserModel.h"

@implementation IAP
-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
static IAP * instance;
+ (IAP *) sharedInstance {
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[IAP alloc] init];
                [[SKPaymentQueue defaultQueue] addTransactionObserver:instance];
            }
        }
    }
    return instance;
}
-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}
-(void)start{
    if(!_loadingView){
        _loadingView = [ModelLoadingViewController sharedInstance];
    }
    if([SKPaymentQueue canMakePayments]){
        _loadingView.text = @"正在连接苹果公司获取信息...";
        [_loadingView show];
        [self getProductInfo];
    }else{
        NSLog(@"不支持应用内购买");
        [[[UIAlertView alloc] initWithTitle:@"你禁止了应用内购买" message:@"你可以在\"设置》通用》访问限制》允许》App 内购买项目\"打开，并重新尝试购买" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
-(void)getProductInfo{
    NSString *purchaseId = [UserModel shareInstance].purchaseId;
    NSSet * set = [NSSet setWithArray:@[purchaseId]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        [_loadingView hide];
        NSLog(@"无法获取产品信息，购买失败。");
        [[[UIAlertView alloc] initWithTitle:nil message:@"无法获取产品信息，购买失败。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"transaction.transactionState : %d", transaction.transactionState);
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"交易成功...");
                [self finishBuy:transaction];
                [_loadingView hide];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(@"交易失败");
                [[[UIAlertView alloc] initWithTitle:nil message:@"交易失败，请重新尝试。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [_loadingView hide];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                NSLog(@"已购买过");
                [_loadingView hide];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}
-(void)finishBuy:(SKPaymentTransaction *)transaction{
    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSData * receipt = transaction.transactionReceipt;
    NSString *str = [receipt base64EncodedString];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        SignUpViewController *signup = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signup];
        signup.receipt = str;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:nav animated:YES];
    }
}
@end
