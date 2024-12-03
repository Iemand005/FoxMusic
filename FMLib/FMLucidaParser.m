//
//  FMLucidaParser.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMLucidaParser.h"

@implementation FMLucidaParser

- (id)init
{
    self = [super init];
    if (self) {
        _delegate = [FMLucidaParserDelegate delegate];
    }
    return self;
}

- (void)parseData:(NSData *)data withCallback:(void (^)(NSObject *))callback
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:_delegate];
    [xmlParser parse];
}



+ (FMLucidaParser *)lucidaParser
{
    return [[FMLucidaParser alloc] init];
}

@end
