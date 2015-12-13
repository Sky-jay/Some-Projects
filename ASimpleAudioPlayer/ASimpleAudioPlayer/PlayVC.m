//
//  PlayVC.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/13.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "PlayVC.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation PlayVC
static NSString *lrcTableViewCellID = @"lrcCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    _SongTitle = @"演员";
    _volumeSlider.value = self.player.volume;
}

#pragma mark - Setter & Getter
- (AVAudioPlayer *)player {
    if (_player == nil) {
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: _SongTitle withExtension:@"mp3" ] error:nil];
//        [_player prepareToPlay];
    }
    return _player;
}


#pragma mark - Button Actions

- (IBAction)playOrPauseAction:(UIButton *)sender {
    if (self.player.isPlaying) {
        [self.player pause];
        sender.selected = NO;
    }else{
        [self.player play];
        sender.selected = YES;
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lrcTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lrcTableViewCellID];
    }
    cell.textLabel.text = @"";
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
