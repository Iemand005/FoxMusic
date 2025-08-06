//
//  FMLucidaParserDelegate.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMLucidaParserDelegate.h"

@implementation FMLucidaParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"Parsing Initiated.");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"found tag %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"found chqrqctes %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

+ (FMLucidaParserDelegate *)delegate
{
    return [[FMLucidaParserDelegate alloc] init];
}

@end
