//
//  ViewController.m
//  Softmax识别数字
//
//  Created by 胡杨林 on 16/10/27.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "MLLoadMNIST.h"
#import "MLSoftMax.h"
#import <Accelerate/Accelerate.h>
//#import "MLDetectViewController.h"
@interface ViewController ()
{
    MLSoftMax *softMax;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)closeKeyboard{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end





















