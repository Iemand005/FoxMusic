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
    [self completionHandler]();
}

@end
