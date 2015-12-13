//
//  LrcDecode.h
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/13.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcDecode : NSObject

+ (instancetype)sharderLrcDecoder;
- (NSDictionary *)decodeLyricsWithResource:(NSString *)name AndType:(NSString *)ext;
- (NSArray *)arrayWithResource:(NSString *)name AndType:(NSString *)ext;

@end
