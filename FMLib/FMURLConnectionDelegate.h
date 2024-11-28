//
//  FMURLConnection.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 1/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMURLConnectionDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    @private
    NSData *_data;
    void(^_callback)(NSData *);
}

- (id)initWithCallback:(void(^const)(NSData *))callback;

+ (FMURLConnectionDelegate *)urlConnectionDelegate;
+ (FMURLConnectionDelegate *)urlConnectionControllerWithCallback:(void(^const)(NSData *))callback;

@end
