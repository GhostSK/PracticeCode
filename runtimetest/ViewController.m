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
    [self pricediscountLabel];
    
}
-(void)exchangeMethodTest{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"111",@"222",@"333",@"444", nil];
    NSLog(@"%@",arr);
    NSString *str = [arr objectAtIndex:5];
    NSLog(@"数组越界测试%@",str);
    NSLog(@"数组非越界测试%@",[arr objectAtIndex:3]);
    NSLog(@"数组越界再次测试%@",[arr objectAtIndex:66]);
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
