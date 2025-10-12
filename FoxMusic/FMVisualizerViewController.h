//
//  FMGLVizualizerView.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "../FMLib/FMGLUtils.h"

//#import "FMGLVizualizerView.h"

@interface FMVisualizerViewController : GLKViewController
{
    GLuint _positionSlot;
    GLuint _programHandle;
}

@property EAGLContext *context;

@property IBOutlet GLKView *glView;

@end
