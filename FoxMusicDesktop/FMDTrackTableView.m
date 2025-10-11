//
//  FMDTrackTableView.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 22/09/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMDTrackTableView.h"

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

@end
