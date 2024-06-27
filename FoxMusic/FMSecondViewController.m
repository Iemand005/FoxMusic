//
//  FMSecondViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSecondViewController.h"


@interface FMSecondViewController ()

@end

@implementation FMSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    loginPrompted = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    if (storyboard) {
        if ((loginPrompted = !loginPrompted)) {
            UIViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"accountPage"];
            [self presentViewController:dest animated:YES completion:nil];
        } else {
//            [[self mainTabBarController] setSelectedIndex:0];
//            UIViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"home"];
//            [self.mainTabBarController setSelectedViewController:dest];
        }
    }
}

- (void)dismissLogin
{
//    [self dis]
}

@end
