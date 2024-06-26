//
//  FMSecondViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSecondViewController.h"
#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>

@interface FMSecondViewController ()

@end

@implementation FMSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logIn:(id)sender
{
    NSString *spotifyAccountsURL = @"https://accounts.spotify.com/login/password";
    
    NSLog(@"Logging in...");
    
    NSString *username = [[self username] text];
    NSString *password = [[self password] text];
    
    NSLog(@"Username: %@, Password: %@", username, password);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:spotifyAccountsURL]];
    NSURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket == -1) {
        NSLog(@"Failed to open socket!");
        return;
    }
    
    struct sockaddr_in serverAddr;
    
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    serverAddr.sin_port = htons(6969);
    
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

@end
