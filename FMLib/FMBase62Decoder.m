//
//  FMBase62Decoder.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 03/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMBase62Decoder.h"

@implementation FMBase62Decoder

- (id)init
{
    self = [super init];
    if (self) {
        [self setCharset:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    }
    return self;
}

- (NSString *)toHex
{
    UInt64 num = [self decodeBase62String:[self string]];
    NSString *hexString = [NSString stringWithFormat:@"%llX", num];
    NSMutableString *paddedHexString = [NSMutableString string];
    NSUInteger remainder = 32 - [hexString length]; // this doesn't work  yet dang it
    while ([paddedHexString length] < remainder)
        paddedHexString = [NSMutableString stringWithString:[paddedHexString stringByAppendingString:@"0"]];

    [paddedHexString appendString:hexString];
    return hexString;
}

- (UInt64)decodeBase62String:(NSString *)base62String
{
    UInt64 num = 0, len = [base62String length];

    for (int i = 0; i < len; i++)
    {
        NSRange range = [[self charset] rangeOfString:[base62String substringWithRange:NSMakeRange(len - i - 1, 1)]];
        num += range.location * pow(62, i);
    }

    return num;
}

+ (FMBase62Decoder *)decoder
{
    return [[FMBase62Decoder alloc] init];
}

+ (FMBase62Decoder *)decoderWithString:(NSString *)string
{
    FMBase62Decoder *decoder = [FMBase62Decoder decoder];
    [decoder setString:string];
    return decoder;
}

@end
