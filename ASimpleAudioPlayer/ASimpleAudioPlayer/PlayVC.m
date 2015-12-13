//
//  PlayVC.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/13.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "PlayVC.h"
#import <AVFoundation/AVFoundation.h>
#import "LrcDecode.h"

@interface PlayVC ()<UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (nonatomic, strong) NSDictionary *lrcSentencesDict;
@property (nonatomic, strong) NSArray *allTimesArray;
@property (nonatomic, strong) NSArray *songList;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PlayVC
static NSString *lrcTableViewCellID = @"lrcCellID";
static int songIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    songIndex = 0;
    _songList = @[@"演员", @"时间都去哪儿了", @"红颜劫", @"当你老了"];
    _SongTitle = _songList[songIndex];
    self.navigationItem.title = _SongTitle;
    _volumeSlider.maximumValue = 1.0;
    _volumeSlider.value = self.player.volume;
    _progressSlider.maximumValue = self.player.duration;
    _lrcSentencesDict = [NSDictionary dictionary];
    _lrcSentencesDict = [[LrcDecode sharderLrcDecoder] decodeLyricsWithResource:_SongTitle AndType:@"lrc"];
    _allTimesArray = [NSArray array];
    _allTimesArray = [[LrcDecode sharderLrcDecoder] arrayWithResource:_SongTitle AndType:@"lrc"];
}

#pragma mark - Setter & Getter
- (AVAudioPlayer *)player {
    if (_player == nil) {
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: _SongTitle withExtension:@"mp3" ] error:nil];
        [_player prepareToPlay];
    }
    return _player;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - Button Actions

- (IBAction)playOrPauseAction:(UIButton *)sender {
    if (self.player.isPlaying) {
        [self.player pause];
        sender.selected = NO;
        self.timer.fireDate = [NSDate distantFuture];
    }else{
        [self.player play];
        sender.selected = YES;
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (IBAction)nextSongAction:(UIButton *)sender {
    songIndex = songIndex < 3 ? songIndex + 1 : 0;
    _SongTitle = _songList[songIndex];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: _SongTitle withExtension:@"mp3" ] error:nil];
    if (self.player.isPlaying) {
        [self.player pause];
        sender.selected = NO;
        self.timer.fireDate = [NSDate distantFuture];
    }else{
        [self.player play];
        sender.selected = YES;
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (IBAction)prevSongAction:(UIButton *)sender {
    songIndex = songIndex > 0 ? songIndex - 1 : 3;
    _SongTitle = _songList[songIndex];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: _SongTitle withExtension:@"mp3" ] error:nil];
    if (self.player.isPlaying) {
        [self.player pause];
        sender.selected = NO;
        self.timer.fireDate = [NSDate distantFuture];
    }else{
        [self.player play];
        sender.selected = YES;
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (IBAction)maxVolumeAction:(UIButton *)sender {
    self.player.volume = 1.0;
    _volumeSlider.value = 1.0;
}

- (IBAction)minVolumeAction:(UIButton *)sender {
    self.player.volume = 0.0;
    _volumeSlider.value = 0.0;
}

#pragma mark - SliderAction
- (IBAction)volumeAction:(UISlider *)sender {
    self.player.volume = sender.value;
}

- (void)updateSlider
{
    _progressSlider.value = self.player.currentTime;
    NSInteger temp = self.player.currentTime;
    
    NSString *row = [self countCellIndexPathWithCurrentTime:(int)temp];
    NSLog(@"%@",row);
    self.navigationItem.title = row;
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
//    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    [_tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor greenColor];
}

- (NSString *)countCellIndexPathWithCurrentTime:(int)currentTime
{
    int temp = currentTime;
    float value = 0.00f;
    
    for (int i = 0; i < _allTimesArray.count; i++) {
        if (i < (_allTimesArray.count - 1)) {
            if (fabs(temp - [_allTimesArray[i] floatValue]) < fabs(temp - [_allTimesArray[i + 1] floatValue])) {
                value = [_allTimesArray[i] floatValue];
            }else{
                value = [_allTimesArray[i + 1] floatValue];
            }
        }
    }
    NSString *str = [_lrcSentencesDict objectForKey:@(value)];
    
    return str;
}

- (IBAction)progressSlider:(UISlider *)sender {
    self.player.currentTime = sender.value;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allTimesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lrcTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lrcTableViewCellID];
    }
    cell.textLabel.text = _lrcSentencesDict[_allTimesArray[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    songIndex = songIndex < 3 ? songIndex + 1 : 0;
    _SongTitle = _songList[songIndex];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: _SongTitle withExtension:@"mp3" ] error:nil];
    [self.player play];
}


@end
