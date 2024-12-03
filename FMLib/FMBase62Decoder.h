//
//  FMBase62Decoder.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 03/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMBase62Decoder : NSObject

@property NSString *string;

@property NSString *charset;

- (NSString *)toHex;

- (UInt64)decodeBase62StringToHexString:(NSString *)base62String;

+ (FMBase62Decoder *)decoder;
+ (FMBase62Decoder *)decoderWithString:(NSString *)string;

@end
