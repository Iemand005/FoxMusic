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
    
    [self createDisplayLink];
}

CVReturn displayCallback(CVDisplayLinkRef displayLink,
                         const CVTimeStamp *inNow,
                         const CVTimeStamp *inOutputTime,
                         CVOptionFlags flagsIn,
                         CVOptionFlags *flagsOut,
                         void *displayLinkContext) {
    FMDOpenGLVisualizerView *view = (FMDOpenGLVisualizerView *)displayLinkContext;
    [view renderForTime:*inOutputTime];
    return kCVReturnSuccess;
}

- (void)renderForTime:(CVTimeStamp)time
{
    @autoreleasepool {
    [[self openGLContext] clearDrawable];
    [[self openGLContext] setView:self];
    [[self openGLContext] makeCurrentContext];
        
    //glClearColor(1.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    GLfloat vertices[] = {
        -1.0f,  1.0f, 0.0f,
        -1.0f, -1.0f, 0.0f,
        1.0f, -1.0f, 0.0f,
        1.0f,  1.0f, 0.0f,
    };
    
    // Load the vertex data
    //
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw triangle
    //
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    GLfloat vertices2 [] = {
        -1.0f, -1.0f, 0.0f,
        0.5f, -0.5f, 0.0f,
        0.5f,  0.5f, 0.0f,
        -1.5f,  0.5f, 0.0f,
    };
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, vertices2);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(0);
    
    [[self openGLContext] flushBuffer];
    }
}

- (BOOL)checkIfShaderLoaded:(GLuint)shader
{
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (compiled) return YES;
    
    GLint infoLen = 0;
    glGetShaderiv ( shader, GL_INFO_LOG_LENGTH, &infoLen );
    
    if (infoLen > 1) {
        char * infoLog = malloc(sizeof(char) * infoLen);
        glGetShaderInfoLog (shader, infoLen, NULL, infoLog);
        NSLog(@"Error compiling shader:\n%s\n", infoLog );
        
        free(infoLog);
    }
    
    glDeleteShader(shader);
    return 0;
}

- (void)setupShader
{
//    NSString * vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
//    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
//    
//    _programHandle = [FMGLUtils loadProgram:vertexShaderPath withFragmentShaderFilepath:fragmentShaderPath];
//    
//    glUseProgram(_programHandle);
//    
//    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
//    GLuint vertexShader;
//    GLuint fragmentShader;
    
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
    
    
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    const char* vertexShaderStr = [[NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    glShaderSource(vertexShader, 1, &vertexShaderStr, NULL);
    
    glCompileShader(vertexShader);
    
    BOOL ok = [self checkIfShaderLoaded:vertexShader];
    
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    const char* fragmentShaderStr = [[NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:nil] UTF8String];;
    glShaderSource(fragmentShader, 1, &fragmentShaderStr, NULL);
    
    glCompileShader(fragmentShader);
    
    ok = [self checkIfShaderLoaded:fragmentShader];
    
    
    
    // Create torprogrq,
    
    programHandle = glCreateProgram();
    
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    
    // Link the program
    glLinkProgram(programHandle);
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    glUseProgram(programHandle);
    
    _positionSlot = glGetAttribLocation(programHandle, "vPosition");
    
//    glUseProgram(<#GLuint program#>)
    
//    vertexShader = [self comp]
}

- (void)createDisplayLink
{
    CGDirectDisplayID displayID = CGMainDisplayID();
    CVReturn error = CVDisplayLinkCreateWithCGDisplay(displayID, &displayLink);
    
    if (error == kCVReturnSuccess) {
        CVDisplayLinkSetOutputCallback(displayLink, displayCallback, self);
        CVDisplayLinkStart(displayLink);
    }
}



- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
    [self setupShader];
    
    //[self setupSquare];
}

//- (void)drawRect:(NSRect)dirtyRect
//{
////    [[self openGLContext] clearDrawable];
////    [[self openGLContext] setView:self];
////    [[self openGLContext] makeCurrentContext];
////    
//////    glClear(GL_COLOR_BUFFER_BIT);
//////    
//////    glBindVertexArray(vao);
//////    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
//////    glBindVertexArray(0);
//////    
//////    GLfloat vertices [] = {
//////        -0.5f, -0.5f, 0.0f,
//////        0.5f, -0.5f, 0.0f,
//////        0.5f,  0.5f, 0.0f,
//////        -0.5f,  0.5f, 0.0f,
//////    };
//////    glEnableVertexAttribArray(0);
//////    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, vertices);
//////    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
//////    glDisableVertexAttribArray(0);
////    
////    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
////    glClear(GL_COLOR_BUFFER_BIT);
////    
////    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
////    
////    
////    
////    [[self openGLContext] flushBuffer];
//}

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
