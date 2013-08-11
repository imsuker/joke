//
//  UIImageView+Joke.h
//  Joke
//
//  Created by cao on 13-8-11.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Joke)
-(void)setImageUrl:(NSString *)url;
-(void)setImageUrl:(NSString *)url contentModel:(UIViewContentMode)contentModel;
@end
