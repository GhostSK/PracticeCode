//
//  ViewController.m
//  sudoku
//
//  Created by 胡杨林 on 2017/9/29.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "ViewController.h"

#define kwidth self.view.frame.size.width / 9

@interface ViewController ()

@property(nonatomic, strong)UIButton *nowButton;

@property(nonatomic, strong)NSMutableArray *lineArr;
@property(nonatomic, strong)NSMutableArray *rowArr;
@property(nonatomic, strong)NSMutableArray *blockArr;
@property(nonatomic, strong)NSMutableArray *wholeArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self BuildUI];
}

-(void)BuildUI{
    self.lineArr = [NSMutableArray array];
    self.rowArr = [NSMutableArray array];
    self.blockArr = [NSMutableArray array];
    self.wholeArr = [NSMutableArray array];
    for (int a = 0; a < 3; a++) {
        for (int b = 0; b < 3; b++) {
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(kwidth * a * 3, kwidth * b * 3 + 20, kwidth * 3, kwidth * 3)];
            if ((a + b) % 2 != 0) {
                back.backgroundColor = [UIColor colorWithRed:120.0/255 green:240.0/255 blue:38.0/255 alpha:1.0];
            }else{
                back.backgroundColor = [UIColor colorWithRed:1 green:160.0/255 blue:177.0/255 alpha:1.0];
            }
            [self.view addSubview:back];
        }
    }
    UIView *bottomBack = [[UIView alloc] initWithFrame:CGRectMake(0, kwidth * 9 + 20, kwidth * 9, self.view.frame.size.height - kwidth * 9 - 20)];
    bottomBack.backgroundColor = [UIColor colorWithRed:58.0/255 green:237.0/255 blue:240.0/255 alpha:1.0];
    [self.view addSubview:bottomBack];
    
    //主阵列设置
    for (int i = 0; i < 9; i++) {
        NSMutableArray *linemember = [NSMutableArray array];
        [self.lineArr addObject:linemember];
        for (int j = 0; j < 9; j++) {
            if (i == 0) {
                NSMutableArray *arr = [NSMutableArray array];
                [self.rowArr addObject:arr];
                NSMutableArray *arr2 =[NSMutableArray array];
                [self.blockArr addObject:arr2];
            }
            NSMutableArray *blockMember = self.blockArr[i / 3 * 3 + j / 3];
            NSMutableArray *rowMember = (NSMutableArray *)self.rowArr[j];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kwidth * j, kwidth * i + 20, kwidth, kwidth)];
            btn.tag = i * 10 + j + 1000;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//            [btn setTitle:@"0" forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%d",i * 10 + j] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectBtnWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            [linemember addObject:btn];
            [rowMember addObject:btn];
            [blockMember addObject:btn];
            [self.view addSubview:btn];
        }
    }
    //下方填写按钮设置
    
    UIView *keyBoardBack = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300) / 2, kwidth * 10, 300, 240)];
    keyBoardBack.backgroundColor = [UIColor clearColor];
    [self.view addSubview:keyBoardBack];
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100 * i, 60 * j, 100, 60)];
            btn.tag = 2000 + j * 3 + i;
            [btn addTarget:self action:@selector(keyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            NSString *str = @"";
            int a = 0;
            if ((j * 3 + i) < 9) {
                a = 0;
            }else{
                a = j * 3 + i;
            }
            
            switch (a) {
                case 0:
                    str = [NSString stringWithFormat:@"%d",j * 3 + i + 1];
                    break;
                case 9:
                    str = @"清空";
                    break;
                case 10:
                    str = @"0";
                    break;
                case 11:
                    str = @"计算";
                    break;
                default:
                    break;
            }
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [keyBoardBack addSubview:btn];
        }
    }
    
    
    
}

-(void)selectBtnWithBtn:(UIButton *)btn{
    //按钮选择
    if (self.nowButton) {
        self.nowButton.backgroundColor = [UIColor clearColor];
    }
    if (self.nowButton == btn) {
        self.nowButton = nil;
    }else{
        btn.backgroundColor = [UIColor blackColor];
        self.nowButton = btn;
    }
}

-(void)keyBtnAction:(UIButton *)btn{
    NSInteger a = btn.tag - 2000 + 1;
    if (a < 10 || a == 11) {
        NSInteger b = a;
        if (a == 11) {
            b = 0;
        }
        NSString *number = [NSString stringWithFormat:@"%ld",b];
        if (self.nowButton) {
            [self.nowButton setTitle:number forState:UIControlStateNormal];
        }
    }else if(a == 10){
        [self clearAll];
    }else{
        [self calculate];
    }
    
}

-(void)clearAll{
    if (self.nowButton) {
        self.nowButton.backgroundColor = [UIColor clearColor];
    }
    self.nowButton = nil;
    for (NSMutableArray *arr in self.rowArr) {
        for (UIButton *btn in arr) {
            [btn setTitle:@"0" forState:UIControlStateNormal];
        }
    }
    [self InputTestData];
}

-(void)calculate{
   //第一步，按逻辑确定只有一种可能的格子，直到无法继续确定为止
    if (self.nowButton) {
        NSArray *arr =[self GetOptionsWithBtn:self.nowButton];
        NSLog(@"当前选中按钮的可能性有%@",arr);
    }else{
        do {
        } while ([self FirstAction]); //无改变则返回false中止循环
    }
}

- (BOOL)FirstAction{
    for (int i = 0; i < 9; i++) {
        NSMutableArray *arr = self.lineArr[i];
        for (int j = 0; j < 9; j++) {
            UIButton *btn = arr[j];
            if ([btn.titleLabel.text isEqualToString:@"0"]) {
                NSArray *result = [self GetOptionsWithBtn:btn];
                if (result.count == 1) {
                    NSString *str = result[0];
                    [btn setTitle:str forState:UIControlStateNormal];
                    return true;
                }
            }
        }
    }
    return false;
}

- (NSArray *)GetOptionsWithBtn:(UIButton *)btn{
    NSInteger tag = btn.tag;
    NSInteger x = (tag - 1000) / 10;
    NSInteger y = tag % 10;
    NSMutableArray *line = self.lineArr[x];
    NSMutableArray *row = self.rowArr[y];
    NSMutableArray *block = self.blockArr[x / 3 * 3 + y / 3];
    NSMutableArray *linemember = [NSMutableArray array];
    NSMutableArray *rowMember = [NSMutableArray array];
    NSMutableArray *blockMember = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        UIButton *linebtn = line[i];
        UIButton *rowbtn = row[i];
        UIButton *blockbtn = block[i];
        [linemember addObject:linebtn.titleLabel.text];
        [rowMember addObject:rowbtn.titleLabel.text];
        [blockMember addObject:blockbtn.titleLabel.text];
    }
    NSMutableSet *lineSet = [NSMutableSet setWithArray:linemember];
    NSMutableSet *rowSet = [NSMutableSet setWithArray:rowMember];
    NSMutableSet *blockSet = [NSMutableSet setWithArray:blockMember];
    [lineSet unionSet:rowSet];
    [lineSet unionSet:blockSet];
    NSMutableSet *wholeSet = [NSMutableSet setWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    [wholeSet minusSet:lineSet];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *str in wholeSet) {
        [result addObject:str];
    }
//    NSLog(@"可以输入的元素有%@",result);  //这里返回一个[String],每一个元素是一个可选输入值
    return result;
}

- (void)InputTestData{
    [self loadData:5 WithTag:2];
    [self loadData:3 WithTag:4];
    [self loadData:7 WithTag:5];
    [self loadData:1 WithTag:8];
    [self loadData:5 WithTag:14];
    [self loadData:6 WithTag:16];
    [self loadData:2 WithTag:17];
    [self loadData:7 WithTag:18];
    [self loadData:6 WithTag:20];
    [self loadData:2 WithTag:25];
    [self loadData:5 WithTag:26];
    [self loadData:3 WithTag:27];
    [self loadData:2 WithTag:31];
    [self loadData:7 WithTag:34];
    [self loadData:1 WithTag:42];
    [self loadData:9 WithTag:43];
    [self loadData:6 WithTag:44];
    [self loadData:8 WithTag:45];
    [self loadData:2 WithTag:46];
    [self loadData:1 WithTag:54];
    [self loadData:9 WithTag:57];
    [self loadData:1 WithTag:61];
    [self loadData:3 WithTag:62];
    [self loadData:7 WithTag:63];
    [self loadData:8 WithTag:68];
    [self loadData:4 WithTag:70];
    [self loadData:8 WithTag:71];
    [self loadData:6 WithTag:72];
    [self loadData:9 WithTag:74];
    [self loadData:7 WithTag:80];
    [self loadData:8 WithTag:83];
    [self loadData:4 WithTag:84];
    [self loadData:1 WithTag:86];
}

-(void)loadData:(NSInteger)data
         WithTag:(NSInteger)tag{
    NSString *str = [NSString stringWithFormat:@"%ld",data];
    UIButton *btn = [self.view viewWithTag:(1000+tag)];
    [btn setTitle:str forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
