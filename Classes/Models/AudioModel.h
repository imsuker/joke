//
//  AudioModel.h
//  Joke
//
//  Created by Gukw on 7/12/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject{
    NSString *_filePath; //音频文件存在本地时的路径
}
@property (nonatomic) NSURL *url; //音频文件的远程地址
@property (nonatomic) NSString *nameResource; //音频文件存在本地时的名字
@property (nonatomic) NSString *filePath; //音频文字在本地的路径
//获取远程资源
-(void)fectchResourceWithBlock:(void (^)(id result, NSError *error))block;

@end
