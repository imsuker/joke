//
//  PopHintViewController.h
//  Joke
//
//  Created by cao on 13-8-17.
//  Copyright (c) 2013年 iphone. All rights reserved.
//
enum PopStyle {
    PopStyleNotVip,
    PopStyleBadNetWork,
    PopStyleBadInput
};
typedef enum PopStyle PopStyle;

#import <UIKit/UIKit.h>

@interface PopHintViewController : UIViewController{
    IBOutlet UIView *_viewBlack;
    IBOutlet UILabel *_label;
}
@property (nonatomic) NSString *text;

- (id)initWithText:(NSString *)text;
- (id)initWithPopStyle:(PopStyle)popStyle;
@end
