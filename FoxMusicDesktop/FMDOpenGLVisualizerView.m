//
//  FMOpenGLVisualizerView.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 10/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMDOpenGLVisualizerView.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>
#import <OpenGL/gl3ext.h>

@implementation FMDOpenGLVisualizerView
{
    GLuint vao, vbo, ebo;
}

- (void)awakeFromNib
{
    NSOpenGLPixelFormatAttribute attributes[] = {
        //        NSOpenGLPFAWindow,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, 24,
        //        NSOpenGLPFAColorSize, 32,
        NSOpenGLPFAOpenGLProfile,
        NSOpenGLProfileVersion3_2Core,
        0
    };
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    
    NSOpenGLContext *context = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
    [self setOpenGLContext:context];
    
    [[self openGLContext] makeCurrentContext];
}

- (id)initWithFrame:(NSRect)frameRect
{
    NSOpenGLPixelFormatAttribute attributes[] = {
//        NSOpenGLPFAWindow,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, 24,
//        NSOpenGLPFAColorSize, 32,
        NSOpenGLPFAOpenGLProfile,
        NSOpenGLProfileVersion3_2Core,
        0
    };
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    
//    self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
    self = [super initWithFrame:frameRect];
    if (self) {
        
        NSOpenGLContext *context = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
        [self setOpenGLContext:context];
        
        [[self openGLContext] makeCurrentContext];
        
        
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(animate:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    
    [self setupSquare];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[self openGLContext] clearDrawable];
    [[self openGLContext] setView:self];
    [[self openGLContext] makeCurrentContext];
    
//    glClear(GL_COLOR_BUFFER_BIT);
//    
//    glBindVertexArray(vao);
//    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
//    glBindVertexArray(0);
//    
//    GLfloat vertices [] = {
//        -0.5f, -0.5f, 0.0f,
//        0.5f, -0.5f, 0.0f,
//        0.5f,  0.5f, 0.0f,
//        -0.5f,  0.5f, 0.0f,
//    };
//    glEnableVertexAttribArray(0);
//    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, vertices);
//    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
//    glDisableVertexAttribArray(0);
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    
    [[self openGLContext] flushBuffer];
}

- (void)setupSquare
{
    GLfloat vertices [] = {
        -0.5f, -0.5f, 0.0f,
         0.5f, -0.5f, 0.0f,
         0.5f,  0.5f, 0.0f,
        -0.5f,  0.5f, 0.0f,
    };
    
    GLfloat colors [] = {
        1.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f,
    };
    
    GLuint indices[] = {
        0, 1, 2,
        2, 3, 0
    };
    
    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glGenBuffers(1, &ebo);
    
    glBindVertexArray(vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    
    glEnableVertexAttribArray(1);
    glBindVertexArray(0);
    
    
}



@end
