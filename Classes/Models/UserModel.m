//
//  UserModel.m
//  Joke
//
//  Created by cao on 13-8-11.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#define default_value_key_visit_joke_id 1
#define key_visit_joke_id @"key_visit_joke_id"
#define key_array_visited_ids @"key_array_visited_ids"
#define word_separated_visited_ids @","
#define key_last_visited_date_timeinterval @"key_last_visited_date_timeinterval"
#define key_vistied_count_today @"key_visited_count_today"
#define value_last_visited_id @"value_last_visited_id";

#import "UserModel.h"
static UserModel *shareInstance;
@implementation UserModel
+(UserModel *)shareInstance{
    if(!shareInstance){
        shareInstance = [[UserModel alloc] init];
        [shareInstance initData];
    }
    return shareInstance;
}
-(void)initData{
    //初始化visitId
    NSUserDefaults *storage =  [NSUserDefaults standardUserDefaults];
    _visitId = [[storage stringForKey:key_visit_joke_id] integerValue];
    if(!_visitId){
        _visitId = default_value_key_visit_joke_id;
    }
    
    //初始化用户所有访问过的ids串
    NSString *visited_ids =[storage stringForKey:key_array_visited_ids];
    if(visited_ids == nil){
        _arrayVisitedIds = [NSMutableArray array];
    }else{
        _arrayVisitedIds = [[visited_ids componentsSeparatedByString:word_separated_visited_ids] mutableCopy];
    }
    _visitedCountToday = [storage integerForKey:key_vistied_count_today];
    [self reCountVisitDate];
    NSLog(@"userModel initData, _visitid=%d, _visitedCountToday:%d,%d", _visitId, [storage integerForKey:key_vistied_count_today],_visitedCountToday);

}
-(void)visitJoke:(NSInteger)visitId{
    if(![_arrayVisitedIds containsObject:@(visitId)]){
        [_arrayVisitedIds addObject:@(visitId)];
        _visitedCountToday ++;
        NSLog(@"visitedCount today:%d", _visitedCountToday);
    }
}
-(BOOL)hasRightToVisit:(NSInteger)visitId{
    if([_arrayVisitedIds containsObject:@(visitId)]){
        NSLog(@"has RightToVisit:YES,because visited");
        return YES;
    }
    if(_visitedCountToday < 10){
        NSLog(@"has RightToVisit:YES, and _visitedCountToday :%d",  _visitedCountToday);
        return YES;
    }
    NSLog(@"====has no RightToVisit;");
    return NO;
}
-(void)reCountVisitDate{
    NSLog(@"begin reCountVisitDate");
    //获取当天0点的时间戳
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:today];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *today0Clock = [calendar dateFromComponents:components];
    NSInteger interval0Clock = [today0Clock timeIntervalSince1970];
    
    
    //初始化当天的时间戳和访问总量
    NSUserDefaults *storage =  [NSUserDefaults standardUserDefaults];
    NSInteger timeinterval = [storage integerForKey:key_last_visited_date_timeinterval];
    NSLog(@"saved timeinterval:%d, today : %d", timeinterval, interval0Clock);
    //如果存数的数据已经不是当天，则重算访问总量
    if(interval0Clock != timeinterval){
        _visitedCountToday = 0;
        [storage setInteger:interval0Clock forKey:key_last_visited_date_timeinterval];
        [storage setInteger:_visitedCountToday forKey:key_vistied_count_today];
        [storage synchronize];
        NSLog(@"visitedCountToday has success reset");
    }else{
        NSLog(@"reCountVisitDate no need!");
    }
    
}
-(void)save{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setInteger:_visitedCountToday forKey:key_vistied_count_today];
    [storage setInteger:_visitId forKey:key_visit_joke_id];
    [storage setValue:[_arrayVisitedIds componentsJoinedByString:@","] forKey:key_array_visited_ids];
    [storage synchronize];
    NSLog(@"UserModel has cussess store！");
}
@end