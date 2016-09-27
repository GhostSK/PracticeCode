//
//  ViewController.m
//  runtimetest
//
//  Created by 胡杨林 on 16/9/27.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+safeObjectAtIndex.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self exchangeMethodTest];
    
}
-(void)exchangeMethodTest{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"111",@"222",@"333",@"444", nil];
    NSLog(@"%@",arr);
    NSString *str = [arr objectAtIndex:5];
    NSLog(@"数组越界测试%@",str);
    NSLog(@"数组非越界测试%@",[arr objectAtIndex:3]);
    NSLog(@"数组越界再次测试%@",[arr objectAtIndex:66]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
