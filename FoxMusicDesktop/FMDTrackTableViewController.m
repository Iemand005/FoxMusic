//
//  FMDTrackListViewDelegate.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 22/09/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMDTrackTableViewController.h"

@implementation FMDTrackTableViewController

- (id)init
{
    self = [super init];
    if (self) {
//        [self setTracks:[NSMutableArray array]];
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSArray *tracks = [self tracks];
    return [tracks count];
}

//- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    return [super ]
//}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    FMDTrackTableItem *track = [[self tracks] objectAtIndex:row];
    return [[track URL] absoluteString];
}

- (id<QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index
{
    if (self.tracks.count) {
        NSIndexSet *rows = [[self view] selectedRowIndexes];
        NSArray *selectedTracks = [self.tracks objectsAtIndexes:rows];
        FMDTrackTableItem *track = [selectedTracks objectAtIndex:index];
        return track;
    }
    return nil;
}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
    return self.view.selectedRowIndexes.count;
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
