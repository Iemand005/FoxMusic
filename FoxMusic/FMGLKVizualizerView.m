//
//  FMGLVizualizerView.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMGLKVizualizerView.h"

@implementation FMGLKVizualizerView

//- (id)init:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//
//    return self;
//}

- (id)init
{
    [self ]
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
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
}

@end
