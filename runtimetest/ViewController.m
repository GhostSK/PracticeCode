//
//  ViewController.m
//  runtimetest
//
//  Created by 胡杨林 on 16/9/27.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+safeObjectAtIndex.h"
#import "Student.h"
#import "AuditingInvoker.h"
#import "AspectProxy.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self exchangeMethodTest];
    [self pricediscountLabel];
    
}
-(void)exchangeMethodTest{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"111",@"222",@"333",@"444", nil];
    NSLog(@"%@",arr);
    NSString *str = [arr objectAtIndex:5];
    NSLog(@"数组越界测试%@",str);
    NSLog(@"数组非越界测试%@",[arr objectAtIndex:3]);
    NSLog(@"数组越界再次测试%@",[arr objectAtIndex:66]);
    
    id student = [[Student alloc] init];
    
    // 设置代理中注册的选择器数组
    NSValue *selValue1 = [NSValue valueWithPointer:@selector(study:andRead:)];
    NSArray *selValues = @[selValue1];
    // 创建AuditingInvoker
    AuditingInvoker *invoker = [[AuditingInvoker alloc] init];
    // 创建Student对象的代理studentProxy
    id studentProxy = [[AspectProxy alloc] initWithObject:student selectors:selValues andInvoker:invoker];
    NSLog(@"以下为第一条信息的输出");
    // 使用指定的选择器向该代理发送消息---例子1
    [studentProxy study:@"Computer" andRead:@"Algorithm"];
        NSLog(@"以下为第二条信息的输出");
    // 使用还未注册到代理中的其他选择器，向这个代理发送消息！---例子2
    [studentProxy study:@"mathematics" :@"higher mathematics"];
        NSLog(@"以下为第三条信息的输出");
    // 为这个代理注册一个选择器并再次向其发送消息---例子3
    [studentProxy registerSelector:@selector(study::)];
    [studentProxy study:@"mathematics" :@"higher mathematics"];

}

-(void)pricediscountLabel{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 30)];
    [self.view addSubview:label];
    label.text = @"12.89";
    label.textAlignment = 1;
    label.textColor = [UIColor grayColor];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",label.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    label.attributedText = newPrice;
    /*
     - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
     使用该属性添加横线
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
