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

- (GLfloat *)createVerticesForRectangleWithHeight:(GLfloat)top left:(GLfloat)left andRight:(GLfloat)right
{
//    GLfloat top = height;
    GLfloat bottom = -1.0f;
    
    GLfloat *vertices = malloc(18 * sizeof(GLfloat));
    
    vertices[0] =  left;
    vertices[1] =  top;
    vertices[2] =  0.0f;
    
    vertices[3] =  left;
    vertices[4] = bottom;
    vertices[5] =  0.0f;
    
    vertices[6] =  right;
    vertices[7] = bottom;
    vertices[8] =  0.0f;
    
    vertices[9] =  right;
    vertices[10] =  top;
    vertices[11] =  0.0f;
    
    vertices[12] =  left;
    vertices[13] =  top;
    vertices[14] =  0.0f;
    
    vertices[15] =  right;
    vertices[16] = bottom;
    vertices[17] =  0.0f;
    return vertices;
}

- (GLfloat *)createBars:(GLuint)amount withHeights:(GLfloat *)heights
{
    GLuint rectangleVertexCount = 18;
    GLfloat *vertices = malloc(amount * rectangleVertexCount * sizeof(GLfloat));
    
    GLfloat a = 2.0f / amount;
    GLfloat width = a;
    if (width <= 0) width = 2;
    for (GLuint index = 0; index < amount; ++index) {
        
        GLfloat left = width * index - 1;
        GLfloat right = left + width;
        GLfloat height = heights[index];
        GLfloat *rectangle = [self createVerticesForRectangleWithHeight:height left:left andRight:right];
        for (GLuint vertIdx = 0; vertIdx < rectangleVertexCount; ++vertIdx) {
            vertices[index * rectangleVertexCount + vertIdx] = rectangle[vertIdx];
        }
        
    }
    return vertices;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0f, 0.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
//    GLfloat *vertices = [self createVerticesForRectangleWithHeight:0.0f left:-1.0f andRight:0.0f];
    GLfloat heights[] = {1.0, 0.5};
    GLfloat *vertices = [self createBars:2 withHeights:heights];
    
    // Load the vertex data
    //
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw triangle
    //
    glDrawArrays(GL_TRIANGLES, 0, 12);
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
