//
//  FMLucidaParser.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMLucidaParserDelegate.h"

@interface FMLucidaParser : NSObject
{
     void(^_callback)(NSObject *);
    FMLucidaParserDelegate *_delegate;
    
}

- (void)parseData:(NSData *)data withCallback:(void (^)(NSObject *))callback;

+ (FMLucidaParser *)lucidaParser;

@end
