//
//  FMGLVizualizerView.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMVisualizerViewController.h"

@implementation FMVisualizerViewController

//- (id)init:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//
//    return self;
//}

//- (void)setupGL;

- (void)viewDidLoad
{
    GLKView *view = (GLKView *)self.view;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [view setContext:self.context];
    
    [self setupGL];
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
//    glEnable(GL_DEPTH_TEST);
    
    
    
//    [view setEnableSetNeedsDisplay:YES];
//    
//    [view setNeedsDisplay];
    
    // Setup layer
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLfloat vertices [] = {
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f,
        0.5f,  0.5f, 0.0f,
        -0.5f,  0.5f, 0.0f,
    };
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(0);
    
    glClearColor(1.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)drawRect:(CGRect)rect
{
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLfloat vertices [] = {
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f,
        0.5f,  0.5f, 0.0f,
        -0.5f,  0.5f, 0.0f,
    };
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(0);
    
    glClearColor(1.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
//    GLKView *view = (GLKView *)self.view;
//    EAGLContext* context;
//    [context pre]
    

}

@end
