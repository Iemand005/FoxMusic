//
//  FMLucidaParser.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMLucidaParser.h"

@implementation FMLucidaParser

- (void)parseData:(NSData *)data withCallback:(void (^)(NSObject *))callback
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:response];
    [xmlParser setDelegate:_parser];
    [xmlParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"Parsing Initiated.");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"found chqrqctes %@", string);
}

+ (FMLucidaParser *)lucidaParser
{
    return [[FMLucidaParser alloc] init];
}

@end
