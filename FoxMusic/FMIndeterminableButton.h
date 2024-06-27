//
//  FMIndeterminableButton.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMIndeterminableButton : UIButton
{
    NSString *text;
    UIActivityIndicatorView *activityIndicator;
}

- (void)setIndeterminate:(BOOL)indeterminate;

@end
