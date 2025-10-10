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
    FMTrack *track = [[self tracks] objectAtIndex:row];
    return [[track URL] absoluteString];
}

@end
