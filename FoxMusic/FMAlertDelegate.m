//
//  FMAlertDelegate.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 25/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMAlertDelegate.h"

@implementation FMAlertDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
<<<<<<< HEAD
    if ([self completionHandler]) [self completionHandler](buttonIndex);
=======
    [self completionHandler]();
>>>>>>> 0528d88226e3bdf583d85e97437e45f885aa773a
}

@end
