//
//  UserModel.h
//  Joke
//
//  Created by cao on 13-8-11.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject{
    NSMutableArray *_arrayVisitedIds;  //用户访问过的所有ids串
    NSInteger _visitedCountToday;   //今天访问的总量
}
@property (nonatomic) NSInteger visitId;  //用户最后一次访问的visitId


@property (nonatomic) BOOL isVIP; //是否是VIP;

+(UserModel *)shareInstance;
-(void)visitJoke:(NSInteger)visitId;  //访问一个id的时候调用，记录在用户访问的所有ids里，并记录用户当前访问的visitId;
-(BOOL)hasRightToVisit:(NSInteger)visitId;   //是否有权限看下一个
-(void)reCountVisitDate;  //重新计算当前的时间戳，当应用第一次启动，但应用从后台切到前台时 调用
-(void)save; //存储内存的数据到plist  当应用切入到后台时或被关闭时存储
@end
