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
    
    loginPrompted = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!loginPrompted) [self promptLogin:self];
    loginPrompted = YES;
}

- (void)promptLogin:(id)sender
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//    if (storyboard) {
//        UIViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"loginLoading"];
//        [self presentViewController:dest animated:YES completion:nil];
//    }
}

- (void)dismissLogin
{
//    [self dis]
}

@end
