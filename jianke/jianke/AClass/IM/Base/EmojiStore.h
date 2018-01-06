//
//  EmojiStore.h
//  ShiJianKe
//
//  Created by hlw on 15/4/12.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiStore : NSObject

+ (EmojiStore*)sharedInstance;

- (NSArray *)allEmoticons;

@end
