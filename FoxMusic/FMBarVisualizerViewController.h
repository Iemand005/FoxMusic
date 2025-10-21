//
//  FMBarVisualizerViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 21/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "../FMLib/FMGLUtils.h"

@interface FMBarVisualizerViewController : GLKViewController
{
    GLuint _positionSlot;
    GLuint _programHandle;
}

@property EAGLContext *context;

@property IBOutlet GLKView *glView;

@end
