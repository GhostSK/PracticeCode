//
//  ViewController.m
//  正则表达式判断输入
//
//  Created by 胡杨林 on 16/11/2.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "tools.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UILabel *result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)emailbtn:(id)sender {
    [self resultChanges:[tools validateEmail:self.text.text]];
}
- (IBAction)mobilebtn:(id)sender {
[self resultChanges:[tools validateMobile:self.text.text]];
}
- (IBAction)phonebtn:(id)sender {
    [self resultChanges:[tools validatePhone:self.text.text]];
}
- (IBAction)carNo:(id)sender {
    [self resultChanges:[tools validateCarNo:self.text.text]];
}
- (IBAction)cartype:(id)sender {
    [self resultChanges:[tools validateCarType:self.text.text]];
}
- (IBAction)nickNamebtn:(id)sender {
    [self resultChanges:[tools validateNickName:self.text.text]];
}
- (IBAction)identifyNo:(id)sender {
    [self resultChanges:[tools validateIdentityCard:self.text.text]];
}

-(void)resultChanges:(BOOL)result{
    if (result) {
        self.result.text = @"输入是合法的";
    }else{
        self.result.text = @"输入不合法";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
