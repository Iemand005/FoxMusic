//
//  FMOpenGLVisualizerView.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 10/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreVideo/CoreVideo.h>

//#import "../FMLib/FMGLUtils.h"

@interface FMDOpenGLVisualizerView : NSOpenGLView
{
    NSTimer *animationTimer;
    CVDisplayLinkRef displayLink;
    GLuint programHandle;
    GLuint _positionSlot;
    
//        GLuint _positionSlot;
//        GLuint _programHandle;
    }

- (void)createDisplayLink;

@end
