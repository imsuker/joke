//
//  UIImageView+Joke.m
//  Joke
//
//  Created by cao on 13-8-11.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "UIImageView+Joke.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (Joke)
-(void)setImageUrl:(NSString *)url{
    self.contentMode = UIViewContentModeScaleAspectFit;
    __weak UIImageView *this = self;
    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img-loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        UIImageView *tthis = this;
        if(tthis){
            if(image){
                tthis.image = image;
            }else{
                tthis.image = [UIImage imageNamed:@"img-error"];
                
            }
        }
    }];
}
-(void)setImageUrl:(NSString *)url contentModel:(UIViewContentMode)contentModel{
    self.contentMode = UIViewContentModeScaleAspectFit;
    __weak UIImageView *this = self;
    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img-loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        UIImageView *tthis = this;
        if(tthis){
            if(image){
                tthis.contentMode = contentModel;
                tthis.image = image;
            }else{
                tthis.image = [UIImage imageNamed:@"img-error"];
                
            }
        }
    }];
}
@end
