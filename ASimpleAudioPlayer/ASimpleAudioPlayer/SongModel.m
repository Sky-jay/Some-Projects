//
//  SongModel.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/14.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "SongModel.h"

@implementation SongModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        //KVC 赋值
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)songModelWithDict:(NSDictionary *)dict {
    return [[SongModel alloc]initWithDict:dict];
}

@end
