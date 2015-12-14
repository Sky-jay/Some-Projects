//
//  SongListHandle.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/14.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "SongListHandle.h"
#import "SongModel.h"

@implementation SongListHandle

+ (instancetype)sharedHandle {
    static SongListHandle *handle;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handle = [[SongListHandle alloc]init];
        [handle changeModels];
    });
    return handle;
}

- (void)changeModels {
    //将PList文件内容读到数组
    NSArray *songs = [[NSArray alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"SongsInfos" withExtension:@"plist"]];
    //初始化_songList数组
    _songList = [NSMutableArray array];
    //转换成Model
    for (NSDictionary *dict in songs) {
        [_songList addObject:[SongModel songModelWithDict:dict]];
    }
}

@end
