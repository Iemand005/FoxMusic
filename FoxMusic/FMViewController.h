//
//  FMViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 17/07/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMAppDelegate.h"

@protocol FMAppDelegateProvider <NSObject>

@required
@property FMAppDelegate *appDelegate;

@end

@interface FMViewController : UIViewController <FMAppDelegateProvider>
{
    FMAppDelegate *_appDelegate;
}

@property FMAppDelegate *appDelegate;

@end
