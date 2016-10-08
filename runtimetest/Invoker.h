//
//  Invoker.h
//  runtimetest
//
//  Created by 胡杨林 on 16/10/8.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Invoker <NSObject>

@required
// 在调用对象中的方法前执行对功能的横切
- (void)preInvoke:(NSInvocation *)inv withTarget:(id)target;
@optional
// 在调用对象中的方法后执行对功能的横切
- (void)postInvoke:(NSInvocation *)inv withTarget:(id)target;

@end

