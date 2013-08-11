//
//  UserModel.h
//  Joke
//
//  Created by cao on 13-8-11.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic) NSInteger visitId;

+(UserModel *)shareInstance;
@end
