//
//  ViewController.m
//  寻路算法demo
//
//  Created by 胡杨林 on 16/11/11.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "MapButton.h"
@interface ViewController ()

@property(nonatomic,strong)NSString *State;
@property(nonatomic,strong)UIView *mapView;
@property(nonatomic, strong)UIButton *startBtn;
@property(nonatomic, strong)UIButton *endBtn;
@property(nonatomic, strong)UIButton *hinderBtn;
@property(nonatomic, strong)MapButton *startPoint;
@property(nonatomic, strong)MapButton *endPoint;
@property(nonatomic,strong)NSMutableArray *startArr;
@property(nonatomic,strong)NSMutableArray *endArr;
@property(nonatomic, assign)BOOL NeedCalculateHagain;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _NeedCalculateHagain = NO;
    [self BuildScreen];
}


-(void)BuildScreen{
    self.startArr = [NSMutableArray array];
    self.endArr = [NSMutableArray array];
    UIView *mapview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
    mapview.backgroundColor = [UIColor blackColor];
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            MapButton *btn = [[MapButton alloc]initWithFrame:CGRectMake(mapview.frame.size.width / 10 * i + 2, mapview.frame.size.width / 10 * j + 2, mapview.frame.size.width / 10 - 4, mapview.frame.size.width / 10 - 4)];
            btn.tag = (i * 10 + j) + 1000;
            btn.backgroundColor = [UIColor whiteColor];
            btn.isStartPoint = NO;
            btn.isEndPoint = NO;
            btn.isHinder = NO;
            btn.G = 0;
            btn.H = 0;
            [btn addTarget:self action:@selector(MapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [mapview addSubview:btn];
        }
    }
    [self.view addSubview:mapview];
    self.mapView = mapview;
    UIView *controlView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width + 64, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.width - 64)];
    UIButton *setStart = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, 100, 40)];
    [setStart setTitle:@"设置起点" forState:UIControlStateNormal];
    [setStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setStart setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [setStart setBackgroundColor:[UIColor blueColor]];
    [setStart addTarget:self action:@selector(SetStartAction) forControlEvents:UIControlEventTouchUpInside];
    self.startBtn = setStart;
    [controlView addSubview:setStart];
    UIButton *setEnd = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 20, 100, 40)];
    [setEnd setTitle:@"设置终点" forState:UIControlStateNormal];
    [setEnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setEnd setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [setEnd setBackgroundColor:[UIColor blueColor]];
    [setEnd addTarget:self action:@selector(SetEndAction) forControlEvents:UIControlEventTouchUpInside];
    self.endBtn = setEnd;
    [controlView addSubview:setEnd];
    UIButton *setHinder = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 140, 20, 100, 40)];
    [setHinder setTitle:@"设置障碍" forState:UIControlStateNormal];
    [setHinder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setHinder setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [setHinder setBackgroundColor:[UIColor blueColor]];
    [setHinder addTarget:self action:@selector(SetHinderAction) forControlEvents:UIControlEventTouchUpInside];
    self.hinderBtn = setHinder;
    [controlView addSubview:setHinder];
    UIButton *Start = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 130, 200, 80)];
    [Start setTitle:@"开始寻路" forState:UIControlStateNormal];
    [Start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Start setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [Start setBackgroundColor:[UIColor blueColor]];
    [Start addTarget:self action:@selector(searchTheWay) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:Start];
    [self.view addSubview:controlView];
    
}

-(void)SetStartAction{
    self.State = @"setStart";
    self.startBtn.selected = YES;
    self.endBtn.selected = NO;
    self.hinderBtn.selected = NO;
}
-(void)SetEndAction{
    self.State = @"setEnd";
    self.startBtn.selected = NO;
    self.endBtn.selected = YES;
    self.hinderBtn.selected = NO;
}
-(void)SetHinderAction{
    self.State = @"setHinder";
    self.startBtn.selected = NO;
    self.endBtn.selected = NO;
    self.hinderBtn.selected = YES;
}
-(void)searchTheWay{
    //初始化
    if (![self ReStart]) {
        return;
    }
    //开始寻路算法
    [self calculateH];
//    [self findWayOld];
    [self findWayNew];

}
-(void)findWayNew{
    MapButton *currentPoint = self.startPoint; //当前点为起点
    [self.startArr addObject:currentPoint];
    currentPoint.fatherPoint = currentPoint;
    while (self.startArr.count > 0) {
//        NSLog(@"现在开启列表中有%ld个节点",self.startArr.count);
        CGFloat tempG = 20000;
        for (MapButton *btn in self.startArr) {
            if (btn.G + btn.H < tempG) {
                tempG = btn.G + btn.H;
                currentPoint = btn;
            }
        }
        //找出开启列表中G值最低的节点
        [self.startArr removeObject:currentPoint];
        [self.endArr addObject:currentPoint];
        //将G值最低的节点从开启列表中删除，放入关闭列表
        NSInteger currentTag = currentPoint.tag;
        int currentX = currentTag % 100 / 10;
        int currentY = currentTag % 10;
        for (int a = currentX - 1; a < currentX + 2; a++) {
            for (int b = currentY - 1; b < currentY + 2; b++) {
                if ((a == currentX && b == currentY) || a > 9 || a < 0 || b > 9 || b < 0) {
                    continue; //越界或者自身，排除
                }
                NSInteger tempTag = 1000 + a * 10 + b;
                MapButton *tempButton = [_mapView viewWithTag:tempTag];
                if (tempButton.fatherPoint == nil) { //如果没有父节点，将父节点设置为当前节点并加入开始列表
                    tempButton.fatherPoint = currentPoint;
                    [self.startArr addObject:tempButton];
                    if (a == currentX || b == currentY) {
                        tempButton.G = currentPoint.G + 10;
                    }else{
                        tempButton.G = currentPoint.G + 15;
                    }
                    
                    if(tempButton == self.endPoint){ //找到了结束点
                        [self colorTheWay]; //对路径染色，结束
                        return;
                    }
                    
                }else{ //如果已有父节点，检查是否需要更新G值
                    if (a == currentX || b == currentY) {
                        if (tempButton.G > currentPoint.G + 10) {
                            tempButton.G = currentPoint.G + 10;
                            tempButton.fatherPoint = currentPoint;
                        }
                    }else{
                        if (tempButton.G  > currentPoint.G + 15) {
                            tempButton.G = currentPoint.G + 15;
                            tempButton.fatherPoint = currentPoint;
                        }
                    }
                    
                }
            }
        }
        //周围G值更新完毕，准备选择下一个节点
        MapButton *nextbtn;
        CGFloat nextG = 3000000;
        for (MapButton *tempNext in self.startArr) {
                if (tempNext.tag == currentPoint.tag) {
                    continue; //越界或者自身，排除
                }
                if (tempNext.G + tempNext.H < nextG) {
                    nextG = tempNext.G + tempNext.H;
                    nextbtn = tempNext;
                }
        currentPoint = nextbtn;
        }
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry~" message:@"没有找到路径" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"你是智障么?");
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)colorTheWay{
    MapButton *btn = self.endPoint;
    while (btn.fatherPoint != btn) {
        btn = btn.fatherPoint;
        [btn setBackgroundColor:[UIColor orangeColor]];
    }
    [self.startPoint setBackgroundColor:[UIColor redColor]];
}
-(void)findWayOld{
    MapButton *currentPoint = self.startPoint; //设置目前计算位置的点
    //有父节点等价于已经被加入过开始队列
    [self.startArr addObject:currentPoint]; //将起点放入开始队列
    currentPoint.fatherPoint = currentPoint;  //这里只运行一次，后续进入while循环
    MapButton *nextPoint;
    int totalCost;
    while (![self.startArr containsObject:self.endPoint]) {
        int currentX = (int)(currentPoint.tag % 100 / 10);
        int currentY = (int)(currentPoint.tag % 10);
        totalCost = 20000;
        for (MapButton *btn in self.mapView.subviews) {
            if (!btn.isHinder) {
                int X = (int)(btn.tag % 100 / 10);
                int Y = (int)(btn.tag % 10);
                if (btn != currentPoint && abs(currentX - X) <=1 && abs(currentY - Y) <= 1) {
                    //找到相邻接的点
                    
                    //更新G值
                    if (btn.G == 0) {
                        btn.G = abs(currentX - X) * 10 + abs(currentY - Y) * 10 + btn.G;
                    }else if (btn.G > abs(currentX - X) * 10 + abs(currentY - Y) * 10 + currentPoint.G){
                        //如果经由当前点的路径的G消耗小于之前的消耗,就重设G值和父节点
                        btn.G = abs(currentX - X) * 10 + abs(currentY - Y) * 10 + currentPoint.G;
                        btn.fatherPoint = currentPoint;
                    }else{
                        //                        NSLog(@"Do Nothing");
                    }
                    
                    
                    if (!btn.fatherPoint) { //如无父节点——新接触节点，加入开始列表
                        [self.startArr addObject:btn]; //将周围的节点加入开始列表
                        btn.fatherPoint = currentPoint;
                    }
                    if (totalCost > btn.G + btn.H) {
                        nextPoint = btn;
                        totalCost = btn.G + btn.H;   //forin结束后这两个指针指向当前下一个节点和当前G+H
                    }
                }
            }else if(![self.endArr containsObject:btn]){  //防止重复加入关闭列
                [self.endArr addObject:btn];
            }
        }
        [self.startArr removeObject:currentPoint];
        [self.endArr addObject:currentPoint];   //将当前点关闭
        if (!nextPoint.isEndPoint) {
            [nextPoint setBackgroundColor:[UIColor orangeColor]];
        }
        currentPoint = nextPoint;
        
        
    }
    
    NSLog(@"循环结束");
}

-(BOOL)ReStart{
    
    //寻路前期准备
    self.startBtn.selected = NO;
    self.endBtn.selected = NO;
    self.hinderBtn.selected = NO;
    self.State = @"";
    if (self.startPoint == nil || self.startPoint == NULL) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"请选择一个起点" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"你是智障么?");
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (self.endPoint == nil || self.endPoint == NULL) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"请选择一个终点" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"你是智障么?");
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    //非第一次点击初始化
    [self.startArr removeAllObjects];
    [self.endArr removeAllObjects];
    for (MapButton *button in self.mapView.subviews) {
        button.G = 0;
        if (button != self.endPoint) {
            button.H = 20000;
        } //将预到达代价设置较高
        button.fatherPoint = nil;
        [button setTitle:@"" forState:UIControlStateNormal];
        if (!(button.isHinder || button.isEndPoint || button.isStartPoint)) {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return YES;
}

-(void)MapBtnAction:(MapButton *)btn{
    if ([self.State isEqualToString:@"setStart"]) {
        if (self.startPoint) {
            self.startPoint.isStartPoint = NO;
            [self.startPoint setBackgroundColor:[UIColor whiteColor]];
        }
        self.startPoint = btn;
        btn.isStartPoint = YES;
        btn.isEndPoint = NO;
        btn.isHinder = NO;
        [btn setBackgroundColor:[UIColor redColor]];
    }else if ([self.State isEqualToString:@"setEnd"]){
        if (self.endPoint != nil) {
            self.endPoint.isEndPoint = NO;
            self.endPoint.H = 20000;
            [self.endPoint setBackgroundColor:[UIColor whiteColor]];
        }
        self.endPoint = btn;
        btn.isStartPoint = NO;
        btn.isEndPoint = YES;
        btn.isHinder = NO;
        btn.H = 0;
        self.endPoint.H = 0;
        [btn setBackgroundColor:[UIColor blueColor]];
    }else if ([self.State isEqualToString:@"setHinder"]){
        if (btn.isStartPoint) {
            self.startPoint = nil;
            btn.isStartPoint = NO;
        }
        if (btn.isEndPoint) {
            self.endPoint = nil;
            btn.isEndPoint = NO;
            btn.H = 20000;
        }
        if (!btn.isHinder) {
            btn.isHinder = YES;
            [btn setBackgroundColor:[UIColor grayColor]];
        }else{
            btn.isHinder = NO;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}
//计算各方块H值
-(void)calculateH{
    int EndX = (int)((self.endPoint.tag % 100) / 10);
    int EndY = (int)self.endPoint.tag % 10;

    for (int i = 1; i < 10; i++) {  //已终点为圆心连续画方型圈
        for (int x = EndX - i; x <= EndX + i; x++) {
            for (int y = EndY - i; y <= EndY + i; y++) {
                if (x > EndX - i && x < EndX + i && y > EndY - i) {
                    y = EndY + i; //减少循环次数
                }
                if (x > 9 || y > 9 || x < 0 || y < 0) {  //越界跳过
                    continue;
                }
                NSInteger tag = 1000 + x * 10 + y;
                MapButton *button = (MapButton *)[_mapView viewWithTag:tag];
                if (button.isHinder) {button.H = 20000; continue; } //障碍不参与到达代价运算
                else{
                    MapButton *surrounds;
                    int temp = 20000;
                    for (int c = x - 1; c < x + 2; c++) {   //遍历周围八格
                        for (int d = y - 1; d < y + 2; d++) {
                            if (c < 0 || c > 9 || d < 0 || d > 9) {
                                continue;  //防止越界
                            }
                            NSInteger tempTag = 1000 + c * 10 + d;
                            MapButton *btn = [_mapView viewWithTag:tempTag];
                            if (btn.H < temp) {
                                temp = btn.H;
                                surrounds = btn;
                            }
                        }
                    }
                    if (labs(surrounds.tag - button.tag) == 11 || labs(surrounds.tag - button.tag) == 9) {  //
                        button.H = surrounds.H + 15; //鼓励斜线走法,不鼓励斜线走法这里请设置25或者更高但是不要超过100
                    }else if(surrounds != nil){
                        button.H = surrounds.H + 10;
                    }else{
                        _NeedCalculateHagain = YES;  //有方块未能成功计算，等待继续
                    }
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"%.0f",button.H] forState:UIControlStateNormal];
                }
                
            }
        }
    }
    //因为计算周围八格是从左上到右下，如果终点的左上方存在障碍，部分情况下回导致一些格子无法正确给予H值，如出现，进入追加环节
    if (_NeedCalculateHagain) {
        [self supplementCalculateH];
    }
    //对第一轮无法计算H值的方块进行补漏
}
-(void)supplementCalculateH{
    int count = 0;
    NSMutableArray *needs = [NSMutableArray array];
    for (MapButton *btn in [_mapView subviews]) {
        if (btn.H == 20000 && !btn.isHinder) {
            [needs addObject:btn];
        }
    }

    while (needs.count > 0) {
        for (int i = 0; i < needs.count;i++) {
            MapButton *btn = [needs objectAtIndex:i];
                NSInteger tag = btn.tag;
                int x = tag % 100 / 10;
                int y = tag % 10;
                MapButton *tempBtn;
                CGFloat TempH = 20000;
                for (int a = x - 1; a < x + 2; a++) {
                    for (int b = y - 1; b < y + 2; b++) {
                        if ((a == x && b == y) || a > 9 || a < 0 || b > 9 || b < 0 ) {
                            continue;  //排除越界与自身
                        }
                        NSInteger tempTag = 1000 + a * 10 + b;
                        MapButton *temp = (MapButton *)[_mapView viewWithTag:tempTag];
                        if (temp.H < TempH) {
                            TempH = temp.H;
                            tempBtn = temp;
                        }
                    }
                }
                if (labs(btn.tag - tempBtn.tag) == 9 || labs(btn.tag - tempBtn.tag) == 11) {
                    btn.H = tempBtn.H + 15; //是否鼓励斜线走法的这里也需要修改
                    [btn setTitle:[NSString stringWithFormat:@"%f",btn.H] forState:UIControlStateNormal];
                    [needs removeObject:btn];
                }else if(tempBtn != nil){
                    btn.H = tempBtn.H + 10;
                    [needs removeObject:btn];
                    [btn setTitle:[NSString stringWithFormat:@"%f",btn.H] forState:UIControlStateNormal];
                }else{
                    NSLog(@"还剩下%ld个方块的H值未计算",needs.count);
                }
        }
        count++;
        if (count >= 100) {
            _NeedCalculateHagain = NO; //可能存在全封闭的非障碍方块，最多循环100次，100次后，退出循环
            break;
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
