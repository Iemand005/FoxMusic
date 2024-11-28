//
//  FMLucida.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMURLConnection.h"

@interface FMLucidaClient : NSObject

@property NSURL *baseAddress;

@property NSURL *endpoint;

@property NSURL *streamURL;

@property FMURLConnection *urlConnection;

- (void)get:(NSString *)url;

+ (FMLucidaClient *)lucidaClient;

@end
