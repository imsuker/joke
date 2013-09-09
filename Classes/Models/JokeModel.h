//
//  JokeModel.h
//  Joke
//
//  Created by Gukw on 7/31/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface JokeModel : JSONModel
@property (nonatomic) NSInteger jokeId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSDictionary *picDefault;
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger visit;
@property (nonatomic) NSInteger collect;
@property (nonatomic) NSInteger prev;
@property (nonatomic) NSInteger next;
@property (nonatomic) NSArray *pics;
@property (nonatomic) NSArray *audios;
@end
