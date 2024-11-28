//
//  FMLucidaParser.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMLucidaParser : NSObject <NSXMLParserDelegate>
{
     void(^_callback)(NSObject *);
}

- (void)parseData:(NSData *)data withCallback:(void (^)(NSObject *))callback;

+ (FMLucidaParser *)lucidaParser;

@end
