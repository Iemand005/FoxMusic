//
//  FMMutableURLQueryDictionary.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMMutableURLQueryDictionary : NSMutableDictionary

- (NSString *)urlString;
- (NSData *)urlEncodedData;

@end
