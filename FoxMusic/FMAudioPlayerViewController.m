//
//  FMAudioPlayerViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMAudioPlayerViewController.h"

#import "FMAppDelegate.h"

@implementation FMAudioPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setAppDelegate:[[UIApplication sharedApplication] delegate]];
}

@end
