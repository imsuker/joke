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
    NSMutableArray *_arrayLikedIds; //用户所有喜欢的ids
}
@property (nonatomic) NSInteger visitId;  //用户最后一次访问的visitId
@property (nonatomic) NSInteger noticeId;  //最后一次访问的noticeId

//登陆用户的相关信息
@property (nonatomic) BOOL isLogin;  //是否登陆用户
@property (nonatomic) NSInteger userId; //用户的userId
@property (nonatomic) NSString *token; //用户token
@property (nonatomic) NSString *userName;  //用户名
@property (nonatomic) NSString *email; //邮箱
@property (nonatomic, readonly) NSInteger countLikedIds; //喜欢的收藏数，个人中心用

+(UserModel *)shareInstance;
-(void)visitJoke:(NSInteger)visitId;  //访问一个id的时候调用，记录在用户访问的所有ids里，并记录用户当前访问的visitId;
-(BOOL)hasRightToVisit:(NSInteger)visitId;   //是否有权限看下一个
-(void)reCountVisitDate;  //重新计算当前的时间戳，当应用第一次启动，但应用从后台切到前台时 调用
-(void)save; //存储内存的数据到plist  当应用切入到后台时或被关闭时存储
-(void)like:(NSInteger)visitId; //喜欢某个visitId
-(void)unlike:(NSInteger)visitId; //取消喜欢某个 visitId
-(BOOL)isLike:(NSInteger)visitId; // 判断该visitId是否喜欢过了
-(void)reFetchLikedIds; //重新获取用户的收藏ids，用户登陆后操作
-(void)login:(NSDictionary *)info; //登陆
-(void)logout; //登出
@end
