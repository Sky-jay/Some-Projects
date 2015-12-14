//
//  SongModel.h
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/14.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongModel : NSObject
@property (nonatomic, strong) NSString *sName;
@property (nonatomic, strong) NSString *sType;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)songModelWithDict:(NSDictionary *)dict;

@end
