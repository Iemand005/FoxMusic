//
//  FMBarVisualizerViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 21/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMBarVisualizerViewController.h"

@interface FMBarVisualizerViewController ()

@end

@implementation FMBarVisualizerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GLKView *view = (GLKView *)self.view;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [view setContext:self.context];
    
    [self setupGL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self setupShader];
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
    
    GLfloat *vertices = malloc(12 * sizeof(GLfloat));
    
    vertices[0] =  left;
    vertices[1] =  top;
    
    vertices[2] =  left;
    vertices[3] = bottom;
    
    vertices[4] =  right;
    vertices[5] = bottom;
    
    vertices[6] =  right;
    vertices[7] =  top;
    
    vertices[8] =  left;
    vertices[9] =  top;
    
    vertices[10] =  right;
    vertices[11] = bottom;
    
    return vertices;
}

- (GLfloat *)createBars:(GLuint)amount withHeights:(GLfloat *)heights
{
    GLuint rectangleVertexCount = 12;
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
    
    
    GLfloat heights[] = {1.0, 0.5, 0.0, -0.5};
    GLfloat amount = 4;
    GLfloat *vertices = [self createBars:amount withHeights:heights];
    
    // Load the vertex data
    //
    glVertexAttribPointer(_positionSlot, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw triangle
    //
    glDrawArrays(GL_TRIANGLES, 0, 6 * amount);
}

@end
