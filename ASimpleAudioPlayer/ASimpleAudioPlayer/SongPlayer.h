//
//  SongPlayer.h
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/14.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    sequenceLoop,
    singleLoop,
    randomLoop,
} PLAYTYPE;

@interface SongPlayer : NSObject

@property (readonly) NSTimeInterval durition;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) BOOL playOrPause;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) PLAYTYPE playType;


+ (instancetype)sharedSongPlayer;

- (void)nextSong;

- (void)prevSong;

@end
