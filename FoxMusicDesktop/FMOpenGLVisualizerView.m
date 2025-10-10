//
//  FMOpenGLVisualizerView.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 10/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMOpenGLVisualizerView.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>

@implementation FMOpenGLVisualizerView

- (id)initWithFrame:(NSRect)frameRect
{
    NSOpenGLPixelFormatAttribute attributes[] = {
        NSOpenGLPFAWindow,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, 24,
        NSOpenGLPFAColorSize, 32,
        0
    };
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    
    self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
    if (self) {
        [[self openGLContext] makeCurrentContext];
        
        
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(animate:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}

@end
