//
//  FMNavigationController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 17/07/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMNavigationController.h"

@implementation FMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (FMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
