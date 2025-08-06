//
//  FMTableViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 17/07/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMViewController.h"

@interface FMTableViewController : UITableViewController <FMAppDelegateProvider>
{
    FMAppDelegate *_appDelegate;
}

@property FMAppDelegate *appDelegate;

@end
