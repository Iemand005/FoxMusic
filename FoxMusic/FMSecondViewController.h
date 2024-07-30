//
//  FMSecondViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMAppDelegate.h"
#import "FMTouch.h"

@interface FMSecondViewController : UIViewController
{
    FMAppDelegate *appDelegate;
    BOOL loginPrompted;
}

- (IBAction)promptLogin:(id)sender;

- (void)dismissLogin;

@end
