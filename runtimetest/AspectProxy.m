//
//  AspectProxy.m
//  runtimetest
//
//  Created by 胡杨林 on 16/10/8.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "AspectProxy.h"

@implementation AspectProxy

-(id)initWithObject:(id)object selectors:(NSArray *)selectors andInvoker:(id<Invoker>)invoker{
    _proxyTarget = object;
    _invoker = invoker;
    _selectors = [selectors mutableCopy];
    
    return self;
}
-(id)initWithobject:(id)object andInvoker:(id<Invoker>)invoker{
    return [self initWithObject:object selectors:nil andInvoker:invoker];
}
//添加另一个选择器
-(void)registerSelector:(SEL)selector{
    NSValue *selValue = [NSValue valueWithPointer:selector];
    [self.selectors addObject: selValue];
}
//为目标对象中被调用的方法返回一个NSMethodSignnature实例
//运行时系统要求在执行标准转发时实现这个方法
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.proxyTarget methodSignatureForSelector:sel];
}
//当调用目标方法的选择器与在AspectProxy对象中注册的选择器匹配的时候，forwardInvocation:会
//调用目标对象中的方法， 并根据条件语句的判断结果调用AOP（面向切面编程）功能
-(void)forwardInvocation:(NSInvocation *)invocation{
    //在调用目标方法钱执行横切功能
    if ([self.invoker respondsToSelector:@selector(preInvoke:withTarget:)]) {
        if (self.selectors != nil) {
            SEL methodSel = [invocation selector];
            for (NSValue *selValue in self.selectors) {
                if (methodSel == [selValue pointerValue]) {
                    [[self invoker] preInvoke:invocation withTarget:self.proxyTarget];
                    break;
                }
            }
        }else{
            [[self invoker] preInvoke:invocation withTarget:self.proxyTarget];
        }
    }
    //调用目标方法
    [invocation invokeWithTarget:self.proxyTarget];

    //在调用目标方法后执行横切功能
    if ([self.invoker respondsToSelector:@selector(postNotificationName:object:)]) {
        if (self.selectors != nil) {
            SEL methodSel = [invocation selector];
            for (NSValue *selValue in self.selectors) {
                if (methodSel == [selValue pointerValue]) {
                    [[self invoker]postInvoke:invocation withTarget:self.proxyTarget];
                    break;
                }
            }
        }else{
            [[self invoker]postInvoke:invocation withTarget:self.proxyTarget];
        }
    }
}

@end
