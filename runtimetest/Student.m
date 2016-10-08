//
//  Student.m
//  runtimetest
//
//  Created by 胡杨林 on 16/10/8.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>

@implementation Student

-(void)study:(NSString *)subject :(NSString *)bookName{
    NSLog(@"Invorking method on %@ object with selector %@",[self class],NSStringFromSelector(_cmd));
    NSLog(@"学生类的学习方法被调用");
    
}
-(void)study:(NSString *)subject andRead:(NSString *)bookName{
    NSLog(@"Invorking method on %@ object with selector %@",[self class], NSStringFromSelector(_cmd));
    NSLog(@"学生类的学习并阅读方法被调用");
}


@end
