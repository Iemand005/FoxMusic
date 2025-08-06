//
//  FMURLConnection.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 1/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

<<<<<<< HEAD
//@interface FMURLConnectionDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@interface FMURLConnectionDelegate : NSObject <NSURLConnectionDelegate>
=======
@interface FMURLConnectionDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
>>>>>>> 0528d88226e3bdf583d85e97437e45f885aa773a
{
    @private
    NSMutableData *_data;
    void(^_callback)(NSData *);
}

- (id)initWithCallback:(void(^const)(NSData *))callback;

+ (FMURLConnectionDelegate *)urlConnectionDelegate;
+ (FMURLConnectionDelegate *)urlConnectionControllerWithCallback:(void(^const)(NSData *))callback;

@end
