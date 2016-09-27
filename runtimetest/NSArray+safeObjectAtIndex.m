//
//  NSArray+safeObjectAtIndex.m
//  runtimetest
//
//  Created by 胡杨林 on 16/9/27.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "NSArray+safeObjectAtIndex.h"
#import <objc/runtime.h>

@implementation NSArray (safeObjectAtIndex)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        SEL safeSel=@selector(safeObjectAtIndex:);
        SEL unsafeSel=@selector(objectAtIndex:);
        
        Class myClass = NSClassFromString(@"__NSArrayI");
        Method safeMethod=class_getInstanceMethod (myClass, safeSel);
        Method unsafeMethod=class_getInstanceMethod (myClass, unsafeSel);
        method_exchangeImplementations(unsafeMethod, safeMethod);
        /*
         此处在程序的didFinishLaunchingWithOptions运行前即会先发执行，
         过程中会对safeObjectAtIndex进行调用，因此断点看到的有一段时间传入的index始终是0，
         在你的主页面的viewdidload打上断点，在运行到viewdidload之后再启动safeObjectAtIndex中的断点才能正确观察到运行情况
         */
    });
}
-(id)safeObjectAtIndex:(NSUInteger)index{
    
    if (index>(self.count-1)) {
        NSLog(@"警告：数组已经溢出");
        //当数组越界时，会返回nil但是程序不会崩溃，提高稳定性
        return nil;
    }
    else{
        return [self safeObjectAtIndex:index];
        //由于上文已经对方法 safeObjectAtIndex与objectAtIndex方法进行了交换，因此这里实际调用的是objectAtIndex，即正常调用,
        //不会因此自身调用无限循环而导致内存溢出式崩溃，相反如果此处调用的是[self objectAtIndex:Index]则会产生自身调用
    }
}
@end
