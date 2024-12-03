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
    return [self decodeBase62StringToHexString:[self string]];
}

- (UInt64)decodeBase62StringToHexString:(NSString *)base62String
{
//    const char *charset = [[self charset] UTF8String];
//    NSArray *charset = [[self charset] componentsSeparatedByString:@""];
    
//    NSArray *base62Strings = [base62String componentsSeparatedByString:@""];
    
    UInt64 num = 0;
    
//    [base62String enumerateSubstringsInRange:NSMakeRange(0, [base62String length]) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//        NSInteger index = substringRange.location;
//        NSRange range = [[self charset] rangeOfString:[base62String substringWithRange:NSMakeRange(index, 1)]];
//        num = num * 62 + range.location;
//    }];
    
//    [base62Strings enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *character, NSUInteger index, BOOL *stop) {
//        NSRange range = [[self charset] rangeOfString:[base62String substringWithRange:NSMakeRange(index, 1)]];
//        num = num * 62 + range.location;
//    }];
    
//    NSLog(@"%i", num);
    
//    for (NSString *characterString in [base62Strings reverseObjectEnumerator]) {
//        NSRange range = [[self charset] rangeOfString:[base62String substringWithRange:NSMakeRange(i,1)]];
//        num = num * 62 + range.location;
//    }
//    
    for (UInt64 i = 0, len = [base62String length]; i < len; i++)
    {
        NSRange range = [[self charset] rangeOfString:[base62String substringWithRange:NSMakeRange(len - i - 1, 1)]];
        long long a = range.location * pow(62, i);
        num += a;
    }
    
//    NSLog(@"%i", num);
    
//    for (NSInteger i = [[self charset] length]; i >= 0; --i) {
//        std::reverse
//    }
    return num;//@"ok";
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
