//
//  AspectProxy.h
//  runtimetest
//
//  Created by 胡杨林 on 16/10/8.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Invoker.h"
@interface AspectProxy : NSProxy

//通过NSProxy实例转发消息的真正对象
@property(strong) id proxyTarget;
//能够实现横切功能的类  （遵守Invoker协议）的实例
@property(strong)id<Invoker>invoker;
//定义了那些消息会调用横切功能
@property(readonly)NSMutableArray *selectors;

//AspectProxy类实例的初始化方法
-(id)initWithobject:(id)object andInvoker:(id<Invoker>)invoker;
-(id)initWithObject:(id)object selectors:(NSArray *)selectors andInvoker:(id<Invoker>)invoker;
//向当前的选择器列表中添加选择器
-(void )registerSelector:(SEL)selector;

@end
