//
//  ViewController.m
//  三级联动窗口
//
//  Created by 胡杨林 on 16/10/10.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "contentView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ViewController


#pragma mark UItableView相关方法
//tableview在故事版中建立，所以代码上没有携带建立以及设置代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld页",(long)indexPath.row + 1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cutpageNotification" object:indexPath];
    //在tableviewcell被点击的时候，发送一个广播，广播携带当前被选中cell的indexPath信息
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // 在主容器VC中对tableviewCell被选择的广播添加监控，选择器方法带上一个冒号会将整个广播给传递过去
    //然后在方法中可以通过notification.object拿到广播中携带的indexpath数据然后进行各种工作，其他参数同理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segmentChangeName:) name:@"cutpageNotification" object:nil];
    contentView *view = [[contentView alloc]init];
    view.frame = CGRectMake(150, 150, 200, 200);
    [self.view addSubview:view];
}

-(void)segmentChangeName:(NSNotification *)index{ //注意参数类型要写成NSNotification不然不能.出object
    NSIndexPath *indexpath = index.object;
    for (int i = 0; i < 4; i++) {
        [self.segmentView setTitle:[NSString stringWithFormat:@"%ld-%d",(long)indexpath.row + 1,i + 1] forSegmentAtIndex:i];
    }
    
}

- (IBAction)SegmentAction:(id)sender {
    NSLog(@"目前是第%ld个页签被选中.",(long)_segmentView.selectedSegmentIndex + 1);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshContentView" object:_segmentView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
