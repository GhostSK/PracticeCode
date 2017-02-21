//
//  ViewController.m
//  OpenGL02
//
//  Created by 胡杨林 on 16/12/16.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "NewView.h"

@interface ViewController ()

@property(nonatomic,strong) NewView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myView = (NewView *)self.view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
