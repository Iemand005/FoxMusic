//
//  FMHTTPServer.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMHTTPServer.h"
#import <sys/socket.h>
#import <netinet/in.h>

@implementation FMHTTPServer

- (void)start
{
    int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket == -1) {
        NSLog(@"Failed to open socket!");
        return;
    }
    
    struct sockaddr_in serverAddr;
    
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    serverAddr.sin_port = htons(self.port);
    
    if (bind(serverSocket, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) == -1) {
        NSLog(@"failed to bind socket");
        return;
    }
    
    if (listen(serverSocket, 5) == -1) {
        NSLog(@"failed to listen on socket");
        return;
    }
    
    NSLog(@"started");
    
    NSFileHandle *fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:serverSocket closeOnDealloc:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveIncomingConnection:) name:NSFileHandleConnectionAcceptedNotification object:nil];
    
    [fileHandle acceptConnectionInBackgroundAndNotify];
    
    [[NSRunLoop currentRunLoop] run];
}

- (void)receiveIncomingConnection:(NSNotification *)notification
{
    NSFileHandle *fileHandle = [notification userInfo][NSFileHandleNotificationFileHandleItem];
    if (fileHandle) {
        NSData *incomingData = [fileHandle availableData];
        if ([incomingData length] == 0) {
            return;
        }
        
        NSString *request = [[NSString alloc] initWithData:incomingData encoding:NSUTF8StringEncoding];
        
        NSLog(@"received request: %@", request);
        
        [fileHandle acceptConnectionInBackgroundAndNotify];
    }
}

- (id)initWithPort:(int)port
{
    self = [super init];
    if (self) {
        self.port = port;
    }
    return self;
}

+ httpServerWithPort:(int)port
{
    return [[FMHTTPServer alloc] initWithPort:port];
}

@end
