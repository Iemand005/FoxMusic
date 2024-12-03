//
//  FMLucidaParserDelegate.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMLucidaParserDelegate : NSObject <NSXMLParserDelegate>

+ (FMLucidaParserDelegate *)delegate;

@end
