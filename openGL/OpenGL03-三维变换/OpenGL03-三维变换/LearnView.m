//
//  LearnView.m
//  OpenGL03-三维变换
//
//  Created by 胡杨林 on 16/12/26.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "LearnView.h"
#import <OpenGLES/ES2/gl.h>
//#import "GLESUtils.h"
//#import "GLESMath.h"

@interface LearnView()

@property(nonatomic,strong)EAGLContext *myContext;
@property(nonatomic,strong)CAEAGLLayer *myEagLayer;
@property(nonatomic,assign)GLuint myProgram;
@property(nonatomic,assign)GLuint myVertices;


@property(nonatomic,assign)GLuint myColorRenderBuffer;
@property(nonatomic,assign)GLuint myColorFrameBuffer;

-(void)setupLayer;

@end


@implementation LearnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
