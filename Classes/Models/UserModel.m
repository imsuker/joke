//
//  UserModel.m
//  Joke
//
//  Created by cao on 13-8-11.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#define default_value_key_visit_joke_id 1
#define key_visit_joke_id @"key_visit_joke_id"
#define default_value_notice_id -1
#define key_notice_id @"key_notice_id"
#define key_array_visited_ids @"key_array_visited_ids"
#define word_separated_visited_ids @","
#define key_last_visited_date_timeinterval @"key_last_visited_date_timeinterval"
#define key_vistied_count_today @"key_visited_count_today"
#define value_last_visited_id @"value_last_visited_id"
#define key_array_liked_ids @"key_array_liked_ids"
#define key_logined_info @"key_logined_info"
#define key_max_count_should_visit @"key_max_count_should_visit"
#define key_price @"key_price"
#define key_purchase_id @"key_purchase_id"

#import "UserModel.h"
#import "AFNetworking.h"
static UserModel *shareInstance;
@implementation UserModel
+(UserModel *)shareInstance{
    if(!shareInstance){
        shareInstance = [[UserModel alloc] init];
        [shareInstance initData];
        [shareInstance initLoginedInfo];  
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
    
    //初始化noticeId
    _noticeId = [[storage stringForKey:key_notice_id] integerValue];
    if(!_noticeId){
        _noticeId = default_value_notice_id;
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
    
    //初始化用户所有喜欢的ids串
    _arrayLikedIds = [storage mutableArrayValueForKey:key_array_liked_ids];
}
-(NSInteger)maxCountShouldVisit{
    if(!_maxCountShouldVisit) {
        _maxCountShouldVisit = [[NSUserDefaults standardUserDefaults] integerForKey:key_max_count_should_visit];
    }
    return _maxCountShouldVisit;
}
-(void)setMaxCountShouldVisit:(NSInteger)maxCountShouldVisit{
    _maxCountShouldVisit = maxCountShouldVisit;
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setInteger:maxCountShouldVisit forKey:key_max_count_should_visit];
    [storage synchronize];
}
-(NSString *)price{
    if(!_price){
        _price = [[NSUserDefaults standardUserDefaults] stringForKey:key_price];
    }
    return _price;
}
-(void)setPrice:(NSString *)price{
    _price = price;
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setValue :price forKey:key_price];
    [storage synchronize];
}
-(NSString *)purchaseId{
    if(!_purchaseId){
        _purchaseId = [[NSUserDefaults standardUserDefaults] stringForKey:key_purchase_id];
    }
    return _purchaseId;
}
-(void)setPurchaseId:(NSString *)purchaseId{
    _purchaseId = purchaseId;
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setValue :purchaseId forKey:key_purchase_id];
    [storage synchronize];
}
-(BOOL)isFree{
    NSInteger intPrice = [_price integerValue];
    CGFloat floatPrice = [_price floatValue];
    if(intPrice == floatPrice && intPrice == 0){
        return YES;
    }
    return NO;
}
-(NSInteger)countLikedIds{
    return _arrayLikedIds.count;
}
-(void)initLoginedInfo{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSDictionary *info = [storage objectForKey:key_logined_info];
    if(!info){
        return;
    }
    _userId = [info[@"userId"] integerValue];
    _userName = info[@"userName"];
    _token = info[@"token"];
    _email = info[@"email"];
    _isLogin = YES;
    [[UserModel shareInstance] reFetchLikedIds];
}
-(void)login:(NSDictionary *)info{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:@{
     @"userId" : info[@"userid"],
     @"token" : info[@"token"],
     @"userName" : info[@"username"],
     @"email" : info[@"email"]?info[@"email"]:@""
     } forKey:key_logined_info];
    [storage synchronize];
    [self initLoginedInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:JD_NOTIFICATION_RELOADUSER object:nil];
}
-(void)logout{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage removeObjectForKey:key_logined_info];
    _isLogin = NO;
    _userId = 0;
    _userName = nil;
    _token = nil;
    [storage synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:JD_NOTIFICATION_RELOADUSER object:nil];

}
-(void)visitJoke:(NSInteger)visitId{
    if(![_arrayVisitedIds containsObject:@(visitId)]){
        [_arrayVisitedIds addObject:@(visitId)];
        _visitedCountToday ++;
        NSLog(@"visitedCount today:%d", _visitedCountToday);
    }
}
-(BOOL)hasRightToVisit:(NSInteger)visitId{
    if(_isLogin){
        return YES;
    }
    if([_arrayVisitedIds containsObject:@(visitId)]){
        NSLog(@"has RightToVisit:YES,because visited");
        return YES;
    }
    if(_visitedCountToday < _maxCountShouldVisit){
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
-(void)saveLastId:(NSInteger)lastId{
    _visitId = lastId;
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setInteger:lastId forKey:key_visit_joke_id];
    [storage synchronize];
}
-(void)setNoticeId:(NSInteger)noticeId{
    _noticeId = noticeId;
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setInteger:noticeId forKey:key_notice_id];
    [storage synchronize];
}
-(void)like:(NSInteger)visitId{
    //本地添加
    if(![_arrayLikedIds containsObject:[NSString stringWithFormat:@"%d", visitId]]){
        [_arrayLikedIds addObject:[NSString stringWithFormat:@"%d", visitId]];
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        [storage setObject:_arrayLikedIds forKey:key_array_liked_ids];
        [storage synchronize];
    }

    
    //往服务器添加
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[iApi sharedInstance].baseUrl];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = @{
                             @"api" : @"collect",
                             @"userid" : @(_userId),
                             @"token" : _token,
                             @"id" : @(visitId)
                             };
    [client postPath:@"/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if(code == 1){
            //TODO
            NSLog(@"collect post success:%d", visitId);
        }else{
            NSLog(@"collect post fail");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"collect post fail");
        //TODO
    }];
    
    
}
-(void)unlike:(NSInteger)visitId{
    [_arrayLikedIds removeObject:[NSString stringWithFormat:@"%d", visitId]];
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:_arrayLikedIds forKey:key_array_liked_ids];
    [storage synchronize];
    
    //往服务器添加
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[iApi sharedInstance].baseUrl];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = @{
                             @"api" : @"uncollect",
                             @"userid" : @(_userId),
                             @"token" : _token,
                             @"id" : @(visitId)
                             };
    [client postPath:@"/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if(code == 1){
            //TODO
            NSLog(@"collect post success:%d", visitId);
        }else{
            NSLog(@"collect post fail");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"collect post fail");
        //TODO
    }];
}
-(BOOL)isLike:(NSInteger)visitId{
    BOOL bLike = NO;
    if(_isLogin && [_arrayLikedIds containsObject:[NSString stringWithFormat:@"%d", visitId]]){
        bLike = YES;
    }
    return bLike;
}
-(void)reFetchLikedIds{
    //TODO
    NSString *urlStr = [iApi sharedInstance].allCollects;
    urlStr = [iApi addUrl:urlStr key:@"userid" value:[NSString stringWithFormat:@"%d", _userId]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //TODO
        NSInteger code = [JSON[@"code"] integerValue];
        if(code == 1){
            NSString *sIds = JSON[@"data"][@"ids"];
            NSArray *ids = @[];
            if([sIds rangeOfString:@","].location != NSNotFound){
                ids = [JSON[@"data"][@"ids"] componentsSeparatedByString:@","];
            }
            _arrayLikedIds = [ids mutableCopy];
            NSLog(@"get all collect success:%@", [_arrayLikedIds description]);
        }else{
            NSLog(@"get all collect fail");
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //TODO
        NSLog(@"get all collect fail");
    }];
    [operation start];
}

+(void)saveLastIdToBackend{
    NSInteger visitId = [UserModel shareInstance].visitId;
    NSString *urlString = [iApi sharedInstance].savelastid;
    urlString = [iApi addUrl:urlString key:@"id" value:[NSString stringWithFormat:@"%d",visitId]];
    urlString = [iApi addUrl:urlString key:@"token" value:[UserModel shareInstance].token];
    urlString = [iApi addUrl:urlString key:@"userid" value:[NSString stringWithFormat:@"%d",[UserModel shareInstance].userId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"savevisitid to backend finished");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"savevisitid to backend failure");
    }];
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        NSLog(@"savevistid backgroundTaskWithExpirationHandler");
    }];
    [operation start];
}
@end
