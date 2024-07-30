//
//  FMIndeterminableButton.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMIndeterminableButton.h"

@implementation FMIndeterminableButton

- (id)init
{
    self = [super init];
    return [self commonInit];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return [self commonInit];
}

- (id)commonInit
{
    if (self) {
        
    }
    return self;
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    if (!activityIndicator) [self createActivityIndicator];
    
    if (indeterminate) {
        text = self.titleLabel.text;
        [self setEnabled:NO];
        [self.titleLabel setText:@""];
        [activityIndicator startAnimating];
        
    } else {
        [activityIndicator stopAnimating];
        [self.titleLabel setText:text];
        [self setEnabled:YES];
    }
}

- (void)createActivityIndicator
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setHidesWhenStopped:YES];
    
    [self addSubview:activityIndicator];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:activityIndicator attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:activityIndicator attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
