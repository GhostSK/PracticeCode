//
//  ViewController.m
//  cell点击展开demo
//
//  Created by 胡杨林 on 17/1/4.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property UITableView *tableview;
@property(nonatomic,strong)MyTableViewCell *lastselected;
@property(nonatomic,strong)NSIndexPath *selectPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.lastselected = nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MyTableViewCell alloc]init];
    }
//     MyTableViewCell *cell = [[MyTableViewCell alloc]init];
    cell.AAA = NO;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 100, 60)];
    btn.tag = indexPath.row + 1000;
    btn.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:btn];
    [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.lastselected != nil && self.selectPath == indexPath) {
        return 600;
    }
    
    
    return 300;
}
-(void)action:(UIButton *)btn{
    MyTableViewCell *cell = (MyTableViewCell *)[[btn superview] superview];
    MyTableViewCell *lastcell;
    if (self.lastselected) {
        lastcell = self.lastselected;
    }
    NSIndexPath *path = [self.tableview indexPathForCell:cell];
    self.selectPath = path;
    if (cell == self.lastselected) {
        self.lastselected = nil;
        cell.AAA = NO;
    }else if (self.lastselected == nil){
        self.lastselected = cell;
        cell.AAA = YES;
        [cell.mytableview reloadData];
    }else{
        self.lastselected.AAA = NO;
        self.lastselected = cell;
        cell.AAA = YES;
        [cell.mytableview reloadData];
    }
    NSLog(@"点击了第%ld个cell",path.row);
    [self.tableview reloadData];
    [lastcell A1];
    [cell A1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
