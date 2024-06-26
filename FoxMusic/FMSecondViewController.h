//
//  FMSecondViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMSecondViewController : UIViewController <UIWebViewDelegate>

- (IBAction)logIn:(id)sender;

@property IBOutlet UITextField *username;
@property IBOutlet UITextField *password;

@property IBOutlet UIWebView *webView;

@end
