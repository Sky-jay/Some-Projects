//
//  ViewController.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/12.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableDictionary *lrcSentencesDict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decodeLyricsWithResource:@"红颜劫" AndType:@"lrc"];
}

- (void)decodeLyricsWithResource:(NSString *)name AndType:(NSString *)ext
{
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSString *lrc = [[NSString alloc]
                     initWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"lrc-->%@",lrc);
    NSArray *lrcArray = [lrc componentsSeparatedByString:@"\n"];
    NSLog(@"lrcArray-->%@",lrcArray);
    _lrcSentencesDict = [NSMutableDictionary dictionary];
    for (NSString *lrcSentenceStr in lrcArray) {
        NSLog(@"lrcSentenceStr-->%@",lrcSentenceStr);
        NSArray *subLrcStr = [lrcSentenceStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[:]"]];
        NSLog(@"subLrcStr-->%@",subLrcStr);
        if ([subLrcStr[1] hasPrefix:@"0"]) {
            float sentenceTime = [subLrcStr[1] floatValue] * 60 + [subLrcStr[2] floatValue];
            [_lrcSentencesDict setObject:subLrcStr[3] forKey:@(sentenceTime)];
        }
    }
    NSLog(@"lrcSentencesDict-->%@",_lrcSentencesDict);
    NSArray *AllTimes = [_lrcSentencesDict allKeys];
    NSArray *orderedArray = [AllTimes sortedArrayUsingSelector:@selector(compare:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
