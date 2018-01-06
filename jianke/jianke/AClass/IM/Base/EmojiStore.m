//
//  EmojiStore.m
//  ShiJianKe
//
//  Created by hlw on 15/4/12.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "EmojiStore.h"
#import "WDConst.h"

@interface EmojiStore()
{
    NSArray* _emojis;
    NSArray* _emojis2;
}

@end

@implementation EmojiStore

Impl_SharedInstance(EmojiStore);



////////////////////////////////////

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
- (NSString *)emojiWithCode:(int)code {
    //    int sym = EMOJI_CODE_TO_SYMBOL(code);
    //    int sym = code;
    //    NSData* data = [NSData dataWithBytes:&code length:sizeof(code)];
    //    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    Byte byte_src[4];
    byte_src[0] = (Byte) ((code & 0xFF000000)>>24);
    byte_src[1] = (Byte) ((code & 0x00FF0000)>>16);
    byte_src[2] = (Byte) ((code & 0x0000FF00)>>8);
    byte_src[3] = (Byte) ((code & 0x000000FF));
    
    return [[NSString alloc] initWithBytes:&byte_src length:sizeof(byte_src) encoding:NSUTF8StringEncoding];
}

- (NSArray *)allEmoticons2 {
    
    if (_emojis2) {
        return _emojis2;
    }
    
    int emojis[] =
    {
        0xF09F9881,
        0xF09F9882,
        0xF09F9883,
        0xF09F9884,
        0xF09F9885,
        0xF09F9886,
        0xF09F9889,
        0xF09F988A,
        0xF09F988B,
        0xF09F988C,
        0xF09F988D,
        0xF09F988F,
        0xF09F9892,
        0xF09F9893,
        0xF09F9894,
        0xF09F9896,
        0xF09F9898,
        0xF09F989A,
        0xF09F989C,
        0xF09F989D,
        0xF09F989E,
        0xF09F98A0,
        0xF09F98A1,
        0xF09F98A2,
        0xF09F98A3,
        0xF09F98A4,
        0xF09F98A5,
        0xF09F98A8,
        0xF09F98A9,
        0xF09F98AA,
        0xF09F98AB,
        0xF09F98AD,
        0xF09F98B0,
        0xF09F98B1,
        0xF09F98B2,
        0xF09F98B3,
        0xF09F98B5,
        0xF09F98B7,
        0xF09F98B8,
        0xF09F98B9,
        0xF09F98BA,
        0xF09F98BB,
        0xF09F98BC,
        0xF09F98BD,
        0xF09F98BE,
        0xF09F98BF,
        0xF09F9980,
        0xF09F9985,
        0xF09F9986,
        0xF09F9987,
        0xF09F9988,
        0xF09F9989,
        0xF09F998A,
        0xF09F998B,
        0xF09F998C,
        0xF09F998D,
        0xF09F998E,
        0xF09F998F,
        0xF09F9880,
        0xF09F9887,
        0xF09F9888,
        0xF09F988E,
        0xF09F9890,
        0xF09F9891,
        0xF09F9895,
        0xF09F9897,
        0xF09F9899,
        0xF09F989B,
        0xF09F989F,
        0xF09F98A6,
        0xF09F98A7,
        0xF09F98AC,
        0xF09F98AE,
        0xF09F98AF,
        0xF09F98B4,
        0xF09F98B6,
    };
    NSMutableArray *array = [NSMutableArray new];
    int length = sizeof(emojis) / sizeof(emojis[0]);
    for (int i = 0; i < length; i++) {
        //        if (i < 0x1F641 || i > 0x1F644) {
        int code = emojis[i];
        id obj = [self emojiWithCode:code];
        if(obj)
            [array addObject:obj];
        //        }
    }
    //    NSMutableArray *array = [NSMutableArray new];
    //    for (int i=0x1F600; i<=0x1F64F; i++) {
    //        if (i < 0x1F641 || i > 0x1F644) {
    //            [array addObject:[self emojiWithCode:i]];
    //        }
    //    }
    _emojis = array;
    
    return array;
}
////////////////////////////////////




- (NSArray *)allEmoticons {
    
    if (_emojis) {
        return _emojis;
    }
    

    NSArray *utf32CodeStringArray = @[
                                      @"1f60a",
                                      @"1f60c",
                                      @"1f60f",
                                      @"1f601",
                                      @"1f604",
                                      @"1f609",
                                      @"1f612",
                                      @"1f614",
                                      @"1f616",
                                      @"1f618",
                                      @"1f621",
                                      @"1f628",
                                      @"1f630",
                                      @"1f631",
                                      @"1f633",
                                      @"1f637",
                                      @"1f603",
                                      @"1f61e",
                                      @"1f620",
                                      @"1f61c",
                                      @"1f60d",
                                      @"1f613",
                                      @"1f61d",
                                      @"1f62d",
                                      @"1f602",
                                      @"1f622",
                                      @"1f61a",
                                      @"1f623",
                                      @"1f632",
                                      @"1f62a",
                                      @"263a",
                                      @"1f47f",
                                      @"1f4aa",
                                      @"1f44a",
                                      @"1f44d",
                                      @"1f44e",
                                      @"1f44f",
                                      @"1f64f",
                                      @"1f446",
                                      @"1f447",
                                      @"261d",
                                      @"270c",
                                      @"1f448",
                                      @"1f449",
                                      @"1f44c",
                                      @"270b",
                                      @"270a",
                                      @"1f440",
                                      @"1f443",
                                      @"1f444",
                                      @"1f442",
                                      @"1f35a",
                                      @"1f35d",
                                      @"1f35c",
                                      @"1f35e",
                                      @"1f35f",
                                      @"1f359",
                                      @"1f363",
                                      @"1f382",
                                      @"1f367",
                                      @"1f37a",
                                      @"1f366",
                                      @"1f34e",
                                      @"1f34a",
                                      @"1f353",
                                      @"1f349",
                                      @"1f354",
                                      @"1f37b",
                                      @"1f48a",
                                      @"1f378",
                                      @"1f373",
                                      @"2615",
                                      @"1f6ac",
                                      @"1f384",
                                      @"1f389",
                                      @"1f380",
                                      @"1f388",
                                      @"1f451",
                                      @"1f494",
                                      @"1f334",
                                      @"1f49d",
                                      @"1f339",
                                      @"1f31f",
                                      @"2728",
                                      @"1f48d",
                                      @"1f462",
                                      @"1f3c0",
                                      @"1f3ca",
                                      @"1f4a3",
                                      @"1f4a6",
                                      @"1f4a8",
                                      @"1f4a4",
                                      @"1f4a2",
                                      @"1f004",
                                      @"1f469",
                                      @"1f468",
                                      @"1f467",
                                      @"1f466",
                                      @"1f437",
                                      @"1f435",
                                      @"1f419",
                                      @"1f42e",
                                      @"1f414",
                                      @"1f438",
                                      @"1f424",
                                      @"1f428",
                                      @"1f41b",
                                      @"1f420",
                                      @"1f436",
                                      @"1f42f",
                                      @"1f3b5",
                                      @"1f3b8",
                                      @"1f3be",
                                      @"1f484",
                                      @"1f40d",
                                      @"1f42c",
                                      @"1f42d",
                                      @"1f427",
                                      @"1f433",
                                      @"1f457",
                                      @"1f452",
                                      @"1f455",
                                      @"1f459",
                                      @"2614",
                                      @"2601",
                                      @"2600",
                                      @"26a1",
                                      @"1f319",
                                      @"2b55",
                                      @"274c",
                                      @"1f463",
                                      @"1f525",
                                      @"1f691",
                                      @"1f692",
                                      @"1f693",
                                      @"00a9",
                                      @"00ae",
                                      @"1f493",
                                      @"1f47b",
                                      @"1f480",
                                      @"303d",
                                      @"1f489",
                                      @"1f460",
                                      @"1f3e0",
                                      @"1f3e5",
                                      @"1f3e6",
                                      @"1f3ea",
                                      @"1f3e8",
                                      @"1f3e7",
                                      @"1f4a9",
                                      @"1f4b0",
                                      @"1f6b9",
                                      @"1f6ba",
                                      @"1f6bd",
                                      @"1f6c0",
                                      @"1f41a",
                                      @"1f45c",
                                      @"1f45f",
                                      @"1f47c",
                                      @"1f197",
                                      @"1f340",
                                      @"1f683",
                                      @"1f684",
                                      @"1f697",
                                      @"26ea",
                                      @"2122",
                                      @"2708",
                                      @"1f47e",
                                      @"2755",
                                      @"1f52b",
                                      @"26a0",
                                      @"1f488",
                                      @"1f4bb",
                                      @"1f4f1",
                                      @"2668",
                                      @"1f4f7",
                                      @"1f4de",
                                      @"1f3c6",
                                      @"1f3b0",
                                      @"1f40e",
                                      @"1f6a4",
                                      @"1f6b2",
                                      @"1f6a7",
                                      @"1f3a5",
                                      @"1f4e0",
                                      @"1f6a5",
                                      @"1f302",
                                      @"1f512",
                                      @"26c4",
                                      @"26bd",
                                      @"1f4eb",
                                      @"1f4bf",
                                      @"1f3a4",
                                      @"1f680",
                                      @"26f5",
                                      @"1f511",
                                      @"2663",
                                      @"3297"
    ];
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSString *utf32CodeString in utf32CodeStringArray) {
        
        NSString *utf8String = [self utf8StringFromUtf32CodeString:utf32CodeString];
        [array addObject:utf8String];
    }
    
    _emojis = array;
    
    return array;
}


- (NSString *)utf8StringFromUtf32CodeString:(NSString *)utf32CodeString
{
    // 转成数字
    const char * unicodeChar = [utf32CodeString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long num = strtoul(unicodeChar, NULL, 16);
    
    // 数字转utf32 data
    Byte longByte[4];
    longByte[0] = (Byte)((num & 0xFF000000) >> 24);
    longByte[1] = (Byte)((num & 0xFF0000) >> 16);
    longByte[2] = (Byte)((num & 0xFF00) >> 8);
    longByte[3] = (Byte)(num & 0x00FF);
    
    // utf32 data 转 utf8 字符串
    NSString *utf8Str = [[NSString alloc] initWithBytes:longByte length:4 encoding:NSUTF32StringEncoding];
    
    return utf8Str;
}



@end
