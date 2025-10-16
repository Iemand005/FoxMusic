//
//  FMGLVizualizerView.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMVisualizerViewController.h"

//#import "../FMLib/FMGLUtils.h"

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
    
    [self setupShader];
//    glEnable(GL_DEPTH_TEST);
    
    
    
//    [view setEnableSetNeedsDisplay:YES];
//    
//    [view setNeedsDisplay];
    
    // Setup layer
}

- (void)setupShader
{
    NSString * vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
    
    _programHandle = [FMGLUtils loadProgram:vertexShaderPath withFragmentShaderFilepath:fragmentShaderPath];
    
    glUseProgram(_programHandle);
    
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
}

- (GLfloat *)createVertices
{
    GLfloat *vertices = malloc(18 * sizeof(GLfloat));
    
//    vertices = {
//        -1.0f,  1.0f, 0.0f,
//        -1.0f, -1.0f, 0.0f,
//         1.0f, -1.0f, 0.0f,
//         1.0f,  1.0f, 0.0f,
//    };
    
    vertices[0] = -1.0f;
    vertices[1] =  1.0f;
    vertices[2] =  0.0f;
    
    vertices[3] = -1.0f;
    vertices[4] = -1.0f;
    vertices[5] =  0.0f;
    
    vertices[6] =  1.0f;
    vertices[7] = -1.0f;
    vertices[8] =  0.0f;
    
    vertices[9] = 1.0f;
    vertices[10] =  1.0f;
    vertices[11] =  0.0f;
    
    vertices[12] = -1.0f;
    vertices[13] = -1.0f;
    vertices[14] =  0.0f;
    
    vertices[15] =  1.0f;
    vertices[16] = -1.0f;
    vertices[17] =  0.0f;
    return vertices;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0f, 0.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
//    GLfloat vertices[] = {
//        -1.0f,  1.0f, 0.0f,
//        -1.0f, -1.0f, 0.0f,
//         1.0f,  -1.0f, 0.0f
//    };
    
    GLfloat *vertices = [self createVertices];
//    GLfloat vertices[] = {
//        -1.0f,  1.0f, 0.0f,
//        -1.0f, -1.0f, 0.0f,
//        1.0f, -1.0f, 0.0f,
//        1.0f,  1.0f, 0.0f,
//    };
    
    // Load the vertex data
    //
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw triangle
    //
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)drawRect:(CGRect)rect
{
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLfloat vertices [] = {
        -1.0f, -1.0f, 0.0f,
        0.5f, -0.5f, 0.0f,
        0.5f,  0.5f, 0.0f,
        -1.5f,  0.5f, 0.0f,
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
