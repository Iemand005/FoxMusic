//
//  FMAlertDelegate.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 25/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMAlertDelegate : NSObject <UIAlertViewDelegate>

@property (strong) void(^completionHandler)();

@end
