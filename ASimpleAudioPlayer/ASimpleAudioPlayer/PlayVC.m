//
//  PlayVC.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/13.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "PlayVC.h"
#import "SongPlayer.h"
#import "LrcDecode.h"

@interface PlayVC ()<UITableViewDelegate, UITableViewDataSource, SongPlayerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *loopType;

@property (nonatomic, strong) NSDictionary *lrcSentencesDict;
@property (nonatomic, strong) NSArray *allTimesArray;

@end

@implementation PlayVC
static NSString *lrcTableViewCellID = @"lrcCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}

- (void)setupSubView
{
    [SongPlayer sharedSongPlayer].delegate = self;
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:_tableView.frame];
    bgImageView.image = [UIImage imageNamed:@"bg.JPG"];
    _tableView.backgroundView = bgImageView;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [SongPlayer sharedSongPlayer].playType = sequenceLoop;
    [_loopType setImage:[UIImage imageNamed:@"sequent_normal"] forState:UIControlStateNormal];
    
    //    self.navigationItem.title = _SongTitle;
    
    if ([SongPlayer sharedSongPlayer].playOrPause) {
        _playOrPauseBtn.selected = YES;
    }else {
        _playOrPauseBtn.selected = NO;
    }
    
    _volumeSlider.maximumValue = 1.0;
    _volumeSlider.value = [SongPlayer sharedSongPlayer].volume;
    _progressSlider.maximumValue = [SongPlayer sharedSongPlayer].durition;
    _progressSlider.value = [SongPlayer sharedSongPlayer].currentTime;
#if 0
    _progressSlider.maximumValue = self.player.duration;
    _lrcSentencesDict = [NSDictionary dictionary];
    _lrcSentencesDict = [[LrcDecode sharderLrcDecoder] decodeLyricsWithResource:_SongTitle AndType:@"lrc"];
    _allTimesArray = [NSArray array];
    _allTimesArray = [[LrcDecode sharderLrcDecoder] arrayWithResource:_SongTitle AndType:@"lrc"];
#endif
}

#pragma mark - Button Actions

- (IBAction)playOrPauseAction:(UIButton *)sender {
    if ([SongPlayer sharedSongPlayer].playOrPause) {
        [SongPlayer sharedSongPlayer].playOrPause = NO;
        sender.selected = NO;
    }else{
        [SongPlayer sharedSongPlayer].playOrPause = YES;
        sender.selected = YES;
    }
}

- (IBAction)nextSongAction:(UIButton *)sender {
    [[SongPlayer sharedSongPlayer] nextSong];
}

- (IBAction)prevSongAction:(UIButton *)sender {
    [[SongPlayer sharedSongPlayer] prevSong];
}

- (IBAction)maxVolumeAction:(UIButton *)sender {
    _volumeSlider.value = 1.0;
    [SongPlayer sharedSongPlayer].volume = 1.0;
}

- (IBAction)minVolumeAction:(UIButton *)sender {
    _volumeSlider.value = 0.0;
    [SongPlayer sharedSongPlayer].volume = 0.0;
}

- (IBAction)loopTypeAction:(UIButton *)sender {
    switch ([SongPlayer sharedSongPlayer].playType) {
        case sequenceLoop:
        {
            [sender setImage:[UIImage imageNamed:@"repeat_one_normal"] forState:UIControlStateNormal];
            [SongPlayer sharedSongPlayer].playType = singleLoop;
        }
            break;
        case singleLoop:
        {
            [sender setImage:[UIImage imageNamed:@"shuffle_normal"] forState:UIControlStateNormal];
            [SongPlayer sharedSongPlayer].playType = randomLoop;
        }
            break;
        case randomLoop:
        {
            [sender setImage:[UIImage imageNamed:@"sequent_normal"] forState:UIControlStateNormal];
            [SongPlayer sharedSongPlayer].playType = sequenceLoop;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - SliderAction
- (IBAction)volumeAction:(UISlider *)sender {
    [SongPlayer sharedSongPlayer].volume = sender.value;
}

#if 0
- (void)updateSlider
{
    _progressSlider.value = self.player.currentTime;
    
    NSTimeInterval a = self.player.currentTime;
    NSLog(@"%f",a);
    NSUInteger temp = a;
    NSLog(@"%lu",(unsigned long)temp);
    NSInteger row = [self countCellIndexPathWithCurrentTime:(int)temp];
    NSLog(@"%ld",(long)row);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//    [_tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor greenColor];
}

- (NSInteger)countCellIndexPathWithCurrentTime:(int)currentTime
{
    NSInteger temp = currentTime;
    NSInteger value = 0;
    NSInteger first = labs((temp - [_allTimesArray[0] integerValue]));
    
    for (int i = 0; i < _allTimesArray.count; i++) {
        if (i < (_allTimesArray.count - 1)) {
            NSInteger value2 = labs((temp - [_allTimesArray[i + 1] integerValue]));
            if (first <= value2) {
                
            }else{
                first = value2;
                value = i + 1;
            }
        }
    }
    return value;
}

#endif
- (IBAction)progressSlider:(UISlider *)sender {
    [SongPlayer sharedSongPlayer].currentTime = _progressSlider.value;
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
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedTextColor = [UIColor greenColor];
    }
    cell.textLabel.text = _lrcSentencesDict[_allTimesArray[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - SongPlayerDelegate
- (void)sendCurrentTime:(NSTimeInterval)currentTime
{
    _progressSlider.value = currentTime;
}

@end
