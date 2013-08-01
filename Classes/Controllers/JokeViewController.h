//
//  JokeViewController.h
//  Joke
//
//  Created by Gukw on 8/1/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"
@interface JokeViewController : UIViewController{
    NSInteger _yFree;  //当前可以画内容的y值
    IBOutlet UILabel *_labelTitle;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UILabel *_labelWord;
    IBOutlet UIButton *_buttonLike;
    IBOutlet UILabel *_labelPassed;
}
@property (nonatomic) JokeModel *jokeModel;
@end
