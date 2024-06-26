//
//  FMFirstViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMFirstViewController : UIViewController <UIDocumentInteractionControllerDelegate>

- (IBAction)installCertificates:(id)sender;

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end
