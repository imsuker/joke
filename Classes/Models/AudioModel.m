//
//  AudioModel.m
//  Joke
//
//  Created by Gukw on 7/12/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "AudioModel.h"
#import "AFHTTPRequestOperation.h"

@implementation AudioModel

-(void)fectchResourceWithBlock:(void (^)(id, NSError *))block{
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:_filePath append:NO];
    NSLog(@"==AudioModel fetch begin");
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"==AudioModel fetch success");
        if(block){
            block(@{}, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"==AudioModel fetch fail");
        if(block){
            block(nil, error);
        }
    }];
    [operation start];
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
@end
