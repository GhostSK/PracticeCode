//
//  AuditingInvoker.m
//  runtimetest
//
//  Created by 胡杨林 on 16/10/8.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "AuditingInvoker.h"

@implementation AuditingInvoker

-(void)preInvoke:(NSInvocation *)inv withTarget:(id)target{
     NSLog(@"before sending message with selector %@ to  object", NSStringFromSelector([inv selector]));
}
- (void)postInvoke:(NSInvocation *)inv withTarget:(id)target{
    NSLog(@"after sending message with selector %@ to  object", NSStringFromSelector([inv selector]));
    
}
@end
