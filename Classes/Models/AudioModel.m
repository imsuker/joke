//
//  AudioModel.m
//  Joke
//
//  Created by Gukw on 7/12/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "AudioModel.h"

@implementation AudioModel

-(void)fectchResourceWithBlock:(void (^)(id, NSError *))block{
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    _operation.outputStream = [NSOutputStream outputStreamToFileAtPath:_filePath append:NO];
    NSLog(@"==AudioModel fetch begin:%@", [_url description]);
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"==AudioModel fetch success");
        if(block){
            NSLog(@"block is doing!!!");
            block(@{}, nil);
        }
        NSLog(@"=====block ~~");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"==AudioModel fetch fail:%@", [error description]);
        if(block){
            block(nil, error);
        }
    }];
    [_operation start];
}
-(void)setNameResource:(NSString *)nameResource{
    _nameResource = nameResource;
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:@"com.iphone.jokeVideoCache"];
    NSString *filePath = [path stringByAppendingPathComponent:nameResource];
    _filePath = filePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSLog(@"createDirectory");
        NSError *error;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(error != nil){
            NSLog(@"==AudioModel 创建文件夹失败:%@",[error description]);
        }
    }
}
-(void)dealloc{
    if(![_operation isFinished]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:_filePath error:nil];
        [_operation cancel];
    }
    [Util logDealloc:self];
    
}
@end
