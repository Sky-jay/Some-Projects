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

@interface PlayVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (nonatomic, strong) NSDictionary *lrcSentencesDict;
@property (nonatomic, strong) NSArray *allTimesArray;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PlayVC
static NSString *lrcTableViewCellID = @"lrcCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    _SongTitle = @"演员";
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
//        [_player prepareToPlay];
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
}

- (IBAction)prevSongAction:(UIButton *)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
