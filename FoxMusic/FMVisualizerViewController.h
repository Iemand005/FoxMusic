//
//  FMGLVizualizerView.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface FMVisualizerViewController : GLKViewController

@property EAGLContext *context;

@property IBOutlet GLKView *glView;

@end
