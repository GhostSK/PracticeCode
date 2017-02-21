//
//  GLESMath.h
//  OpenGL03-三维变换
//
//  Created by 胡杨林 on 16/12/26.
//  Copyright © 2016年 胡杨林. All rights reserved.
//


#ifndef __GLESMATH_H__
#define __GLESMATH_H__

#import <OpenGLES/ES2/gl.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.1415926535897932384626433832795f
#endif

#define DEG2RAD( a ) (((a) * M_PI) / 180.0f)
#define RAD2DEG( a ) (((a) * 180.f) / M_PI)

// angle indexes
#define	PITCH				0		// up / down
#define	YAW					1		// left / right
#define	ROLL				2		// fall over

typedef unsigned char  byte;

typedef struct{
    GLfloat m[3][3];
}KSMatrix3;

typedef struct {
    GLfloat m[4][4];
}KSMatrix4;
typedef struct KSVec3{
    GLfloat x;
    GLfloat y;
    GLfloat z;
}KSVec3;
typedef struct KSVec4{
    GLfloat x;
    GLfloat y;
    GLfloat z;
    GLfloat w;
}KSVec4;

typedef struct {
    GLfloat r;
    GLfloat g;
    GLfloat b;
}KSColor;

#ifdef __cplusplus
extern "C" {
#endif

unsigned int ksNextPot(unsigned int n);
    
void ksCopyMatrix4(KSMatrix4 *target, const KSMatrix4 *src);
    
void ksMatrix4ToMatrix3(KSMatrix3 *target, const KSMatrix4 *src);
    
void ksScale(KSMatrix4 *result, GLfloat sx, GLfloat sy, GLfloat sz);
    

void ksTranslate(KSMatrix4 *result, GLfloat tx, GLfloat ty, GLfloat tz);
    
void kdRotate(KSMatrix4 *result, GLfloat tx, GLfloat ty, GLfloat tz);
    
void ksMatrixMultiply(KSMatrix4 *result, const KSMatrix4 *srcA, const KSMatrix4 *src8);
    
void ksMatrixLoadIdentity(KSMatrix4 *result);
    
void ksPerspective(KSMatrix4 *result, float fovy, float aspect, float nearZ, float garZ);

void ksOrtho(KSMatrix4 *result, float left, float right, float bottom, float top, float nearZ, float farZ);

void ksFrustum(KSMatrix4 *result, float left, float right, float bottom, float top, float nearZ, float farZ);
    
#ifdef  __cplusplus
}
#endif

    
    

#endif  // __GLESMATH_H__


































