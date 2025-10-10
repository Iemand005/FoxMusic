//
//  FMDTrackListViewDelegate.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 22/09/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDAppDelegate.h"

@interface FMDTrackTableViewController : NSObject <NSTableViewDelegate, NSTableViewDataSource>

//@property (assign) IBOutlet FMD *app;

@property (assign) IBOutlet NSMutableArray *tracks;

@end
