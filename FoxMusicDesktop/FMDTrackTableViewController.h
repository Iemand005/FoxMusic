//
//  FMDTrackListViewDelegate.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 22/09/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

#import "FMDAppDelegate.h"
#import "FMDTrackTableItem.h"

@interface FMDTrackTableViewController : NSObject <NSTableViewDelegate, NSTableViewDataSource, QLPreviewPanelDataSource>

//@property (assign) IBOutlet FMD *app;

@property (assign) IBOutlet NSMutableArray *tracks;
@property (assign) IBOutlet NSTableView *view;

- (void)quickLook;
- (IBAction)quickLook:(id)sender;



@end
