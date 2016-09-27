//
//  ViewController.m
//  折线图
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 moon. All rights reserved.
//

#import "ViewController.h"
#import "ZXView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZXView * zx = [[ZXView alloc]initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 250)];
    [self.view addSubview:zx];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end