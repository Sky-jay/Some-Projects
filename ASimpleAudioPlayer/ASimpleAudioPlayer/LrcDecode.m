//
//  LrcDecode.m
//  ASimpleAudioPlayer
//
//  Created by qingyun on 15/12/13.
//  Copyright © 2015年 Sky-jay. All rights reserved.
//

#import "LrcDecode.h"

@implementation LrcDecode

+ (instancetype)sharderLrcDecoder {
    static LrcDecode *lrcDecoder;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        lrcDecoder = [[LrcDecode alloc]init];
    });
    return lrcDecoder;
}

- (NSDictionary *)decodeLyricsWithResource:(NSString *)name AndType:(NSString *)ext
{
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSString *lrc = [[NSString alloc]
                     initWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"lrc-->%@",lrc);
    NSArray *lrcArray = [lrc componentsSeparatedByString:@"\n"];
//    NSLog(@"lrcArray-->%@",lrcArray);
    
    NSMutableDictionary *lrcSentencesDict = [NSMutableDictionary dictionary];
    for (NSString *lrcSentenceStr in lrcArray) {
//        NSLog(@"lrcSentenceStr-->%@",lrcSentenceStr);
        NSArray *subLrcStr = [lrcSentenceStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[:]"]];
//        NSLog(@"subLrcStr-->%@",subLrcStr);
        if ([subLrcStr[1] hasPrefix:@"0"]) {
            float sentenceTime = [subLrcStr[1] floatValue] * 60 + [subLrcStr[2] floatValue];
            [lrcSentencesDict setObject:subLrcStr[3] forKey:@(sentenceTime)];
        }
    }
//    NSLog(@"lrcSentencesDict-->%@",lrcSentencesDict);
    
    return lrcSentencesDict;
}

- (NSArray *)arrayWithResource:(NSString *)name AndType:(NSString *)ext
{
    NSDictionary *lrcSentencesDict = [self decodeLyricsWithResource:name AndType:ext];
    NSArray *AllTimes = [lrcSentencesDict allKeys];
    NSArray *orderedArray = [AllTimes sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@"%@",orderedArray);
    return orderedArray;
}

@end
