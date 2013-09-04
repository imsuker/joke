//
//  NoticeViewController.h
//  Joke
//
//  Created by cao on 13-9-4.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController{
    IBOutlet UIWebView *_webView;
}

@property (nonatomic) NSString *url;
@end
