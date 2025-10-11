//
//  FMDTrackTableView.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 22/09/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMDTrackTableView.h"

#import "FMDTrackTableViewController.h"
#import "FMTrackTableViewDelegate.h"

@implementation FMDTrackTableView

- (void)keyDown:(NSEvent *)theEvent
{
    int keyCode = [theEvent keyCode];
    if (keyCode == 49)
        [self quickLook];
}

- (void)quickLook:(id)sender
{
    [self quickLook];
}

- (void)quickLook
{
    QLPreviewPanel *panel = [QLPreviewPanel sharedPreviewPanel];
    
    [panel makeKeyAndOrderFront:nil];
    [panel reloadData];
}

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    [panel setDataSource:(id)[self controller]];
//    [panel setDelegate:(id)[self delegate]];
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    panel.dataSource = nil;
    panel.delegate = nil;
}

//
//- (id<QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index
//{
//    
//}

@end
