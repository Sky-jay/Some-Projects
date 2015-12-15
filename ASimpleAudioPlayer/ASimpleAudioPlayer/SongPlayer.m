//
//  SongPlayer.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/14.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "SongPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "SongListHandle.h"
#import "SongModel.h"

@interface SongPlayer ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SongPlayer
@synthesize playOrPause = _playOrPause, volume = _volume, currentTime = _currentTime;

+ (instancetype)sharedSongPlayer {
    static SongPlayer *songPlayer;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        songPlayer = [[SongPlayer alloc]init];
        songPlayer.currentIndex = -1;
    });
    return songPlayer;
}


#pragma mark - setter &getter

- (BOOL)playOrPause {
    return _player.isPlaying;
}

- (void)setPlayOrPause:(BOOL)playOrPause {
    if (playOrPause) {
        [_player play];
    }else {
        [_player pause];
    }
    _playOrPause = playOrPause;
}

/**
 *
 */
- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex != -1) {
        if (_currentIndex == currentIndex) {
            return;
        }else {
            SongModel *model = [SongListHandle sharedHandle].songList[currentIndex];
            _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:model.sName withExtension:model.sType] error:nil];
            [_player prepareToPlay];
            [_player play];
        }
    }
    _currentIndex = currentIndex;
}

- (void)setVolume:(float)volume {
    _player.volume = volume;
    _volume = volume;
}

- (float)volume {
    return _player.volume;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateCurrent) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (_currentTime != currentTime) {
        _player.currentTime = currentTime;
    }
    _currentTime = currentTime;
}

- (NSTimeInterval)currentTime {
    return _player.currentTime;
}

- (NSTimeInterval)durition {
    return _player.duration;
}

#pragma mark - Method

- (void)nextSong {
    [self nextLoopType];
}

- (void)prevSong {
    self.currentIndex = self.currentIndex > 0 ? self.currentIndex - 1 : 3;
}

- (void)updateCurrent
{
    
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextLoopType];
    }
}

- (void)nextLoopType
{
    switch (_playType) {
        case sequenceLoop:
            self.currentIndex = self.currentIndex < 3 ? self.currentIndex + 1 : 0;
            break;
        case singleLoop:
        {
            NSInteger temp = self.currentIndex;
            self.currentIndex = -1;
            self.currentIndex = temp;
        }
            break;
        case randomLoop:
            self.currentIndex = random()%[SongListHandle sharedHandle].songList.count;
            break;
            
        default:
            break;
    }
}

@end
