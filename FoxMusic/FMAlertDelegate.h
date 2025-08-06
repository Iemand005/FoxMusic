//
//  FMAlertDelegate.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 25/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMAlertDelegate : NSObject <UIAlertViewDelegate>

<<<<<<< HEAD
@property (strong, atomic) void(^completionHandler)(int buttonIndex);
=======
@property (strong) void(^completionHandler)();
>>>>>>> 0528d88226e3bdf583d85e97437e45f885aa773a

@end
