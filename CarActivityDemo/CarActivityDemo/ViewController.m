//
//  ViewController.m
//  CarActivityDemo
//
//  Created by 胡杨林 on 2017/8/25.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "ViewController.h"

//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@interface ViewController ()
{
    CAEmitterLayer * _fireEmitter;//发射器对象
    CAEmitterLayer *layer2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    [self anEmitter];
//    [self anotheremitter];
    [self configUI];
}

-(void)configUI{
    NSLog(@"%f",self.view.frame.size.height);
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 500, 100, 30)];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 setTitle:@"一个发射器" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(anEmitter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    UIButton *btn2  = [[UIButton alloc]initWithFrame:CGRectMake(120, 500, 100, 30)];
    [btn2 setBackgroundColor:[UIColor redColor]];
    [btn2 setTitle:@"二个发射器" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(anotheremitter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(220, 500, 80, 40)];
    [btn3 setBackgroundColor:[UIColor redColor]];
    [btn3 setTitle:@"清屏" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(clearLayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}
-(void)anEmitter{
//    UIScrollView *mapview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 414, 736)];
//    [self.view addSubview:mapview];
//    mapview.contentSize = CGSizeMake(414, 2000);
//    mapview.backgroundColor = [UIColor greenColor];
//    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 2000)];
//    [mapview addSubview:backImage];
//    backImage.image = [UIImage imageNamed:@"CCAMAP.jpeg"];
    
    CAEmitterLayer *layer = [[CAEmitterLayer alloc]initWithLayer:self.view.layer];
//    layer.emitterCells = [NSArray arrayWithObject:[UIImage imageNamed:@"火箭.png"]];//该属性用于储存粒子单元数组，
//    在你绘制火焰效果时，可以创建两个单元，一个负责烟雾，一个负责火焰
    layer.birthRate = 10;  //粒子生成速率，默认1/s
    layer.lifetime = 3;//粒子存活时间，默认1s
    layer.emitterPosition = CGPointMake(200, 200); //发射器位置
    layer.zPosition = 0.0; //发射器Z位置
    layer.emitterSize = CGSizeMake(20, 20); //发射器尺寸
    layer.emitterDepth = 1.0; //发射器深度，某些模式下会产生立体效果
    layer.emitterShape = kCAEmitterLayerRectangle;  //发射器形状
    /*
     CA_EXTERN NSString * const kCAEmitterLayerPoint
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0); //点的形状，粒子从一个点发出
     CA_EXTERN NSString * const kCAEmitterLayerLine
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//线的形状，粒子从一条线发出
     CA_EXTERN NSString * const kCAEmitterLayerRectangle
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//矩形形状，粒子从一个矩形中发出
     CA_EXTERN NSString * const kCAEmitterLayerCuboid
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//立方体形状，会影响Z平面的效果
     CA_EXTERN NSString * const kCAEmitterLayerCircle
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//圆形，粒子会在圆形范围发射
     CA_EXTERN NSString * const kCAEmitterLayerSphere
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//球型
     */
    layer.emitterMode = kCAEmitterLayerPoint;  //发射模式
    /*
     CA_EXTERN NSString * const kCAEmitterLayerPoints
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器中发出
     CA_EXTERN NSString * const kCAEmitterLayerOutline
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器边缘发出
     CA_EXTERN NSString * const kCAEmitterLayerSurface
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器表面发出
     CA_EXTERN NSString * const kCAEmitterLayerVolume
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器中点发出
     */
    layer.renderMode = kCAEmitterLayerUnordered;  //发射器渲染模式
    /*
     CA_EXTERN NSString * const kCAEmitterLayerUnordered
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，粒子是无序出现的，多个发射源将混合
     CA_EXTERN NSString * const kCAEmitterLayerOldestFirst
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，声明久的粒子会被渲染在最上层
     CA_EXTERN NSString * const kCAEmitterLayerOldestLast
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，年轻的粒子会被渲染在最上层
     CA_EXTERN NSString * const kCAEmitterLayerBackToFront
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，粒子的渲染按照Z轴的前后顺序进行
     CA_EXTERN NSString * const kCAEmitterLayerAdditive
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式会进行粒子混合
     */
    layer.preservesDepth = FALSE;  //是否开启三维空间效果
    layer.velocity = 5;  //粒子运动速度
    layer.scale = 2.0;  //粒子缩放大小
    layer.spin = 2.0;  //粒子旋转位置
    layer.seed = 99999;  //初始化随机的粒子种子
    
    
#pragma mark 粒子单元
    CAEmitterCell *cell = [CAEmitterCell emitterCell];  //类方法创建发射单元
    cell.name = @"智障";  //设置发射单元的名称
    cell.enabled = true;  //是否允许发射器渲染
    cell.birthRate = 1;  //粒子的创建速率
    cell.lifetime = 3;  //粒子生存时间
    cell.lifetimeRange = 2;  //粒子生存时间容差
    cell.emissionLatitude = 3.0;  //粒子在Z轴方向的发射角度
    cell.emissionLongitude = 3.0;  //粒子在xy平面的发射角度
    cell.emissionRange = 2.0;  //发射角度容差
    cell.velocity = 50.0;  //粒子速度
    cell.velocityRange = 25.0; //粒子速度波动范围
    cell.xAcceleration = 0;
    cell.yAcceleration = 0;
    cell.zAcceleration = 0;  //xyz三个方向的加速度
    cell.scale = 0.3;  //粒子缩放
    cell.scaleRange = 0.2;  //缩放波动范围
    cell.scaleSpeed = 1.0;
    cell.spin = 20;  //旋转度
    cell.spinRange = 20;  //旋转度波动范围
    cell.color = [UIColor redColor].CGColor;  //粒子颜色
    cell.redRange = 0.5;
    cell.greenRange = 0.5;
    cell.blueRange = 0.5;
    cell.alphaRange = 0.5;  //RGBA上的容差
    cell.redSpeed = 1;
    cell.greenSpeed = 1;
    cell.blueSpeed = 1;
    cell.alphaSpeed = 1;  //RGBA的变化速度
    cell.contents = (id)[UIImage imageNamed:@"火箭.png"].CGImage;  //渲染粒子，可以设置一个CGImage对象
    [cell setName:@"智障"];
//    cell.contentsRect = CGRectMake(0, 0, 414, 736);
    
    layer.emitterCells = [NSArray arrayWithObject:cell];
    if (layer2) {  //防止重复点击造成无法清除
        [layer2 removeFromSuperlayer];
    }
    layer2 = layer;
    [self.view.layer addSublayer:layer2];
    //为了更新仓库注释……
    
}

-(void)anotheremitter{
    if (_fireEmitter) {
        [_fireEmitter removeFromSuperlayer];
    }
    //设置发射器
    _fireEmitter=[[CAEmitterLayer alloc]init];
    _fireEmitter.emitterPosition=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-20);
    _fireEmitter.emitterSize=CGSizeMake(self.view.frame.size.width-100, 20);
    _fireEmitter.renderMode = kCAEmitterLayerAdditive;
    //发射单元
    //火焰
    CAEmitterCell * fire = [CAEmitterCell emitterCell];
    fire.birthRate=80;
    fire.lifetime=2.0;
    fire.lifetimeRange=1.5;
    fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
    fire.contents=(id)[[UIImage imageNamed:@"火箭.png"]CGImage];
    [fire setName:@"fire"];
    
    fire.velocity=160;
    fire.velocityRange=80;
    fire.emissionLongitude=M_PI+M_PI_2;
    fire.emissionRange=M_PI_2;
    
    
    
    fire.scaleSpeed=0.3;
    fire.spin=0.2;
    
    //烟雾
    CAEmitterCell * smoke = [CAEmitterCell emitterCell];
    smoke.birthRate=40;
    smoke.lifetime=3.0;
    smoke.lifetimeRange=1.5;
    smoke.color=[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05]CGColor];
    smoke.contents=(id)[[UIImage imageNamed:@"火箭.png"]CGImage];
    [fire setName:@"smoke"];
    
    smoke.velocity=250;
    smoke.velocityRange=100;
    smoke.emissionLongitude=M_PI+M_PI_2;
    smoke.emissionRange=M_PI_2;
    
    _fireEmitter.emitterCells=[NSArray arrayWithObjects:smoke,fire,nil];
    [self.view.layer addSublayer:_fireEmitter];
}
-(void)clearLayer{
    if (_fireEmitter) {
        [_fireEmitter removeFromSuperlayer];
    }
    if (layer2) {
        [layer2 removeFromSuperlayer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
