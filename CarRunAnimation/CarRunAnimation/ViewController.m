//
//  ViewController.m
//  CarRunAnimation
//
//  Created by 胡杨林 on 2017/8/28.
//  Copyright © 2017年 胡杨林. All rights reserved.
// 1552w 2017年08月28日16:59:51

#import "ViewController.h"
#define kwidth self.view.bounds.size.width
#define kheight self.view.bounds.size.height



@interface ViewController () <CAAnimationDelegate>


@property (nonatomic,strong)UIView *animationView;
@property (nonatomic, strong)CAKeyframeAnimation *animation;
@property (nonatomic, strong)CAShapeLayer *AAlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self BuildLines];
//    [self BuildRoad];
}

- (void)BuildRoad{
    
    UIBezierPath *leftpath = [UIBezierPath bezierPath];
    [leftpath moveToPoint:CGPointMake(100, kheight)];
    [leftpath addQuadCurveToPoint:CGPointMake(100, kheight-150)  controlPoint:CGPointMake(200, kheight - 75)];
    self.AAlayer = [self editPath:leftpath];
    UIBezierPath *rightpath = [UIBezierPath bezierPath];
    [rightpath moveToPoint:CGPointMake(200, kheight)];
    [rightpath addQuadCurveToPoint:CGPointMake(200, kheight-150)  controlPoint:CGPointMake(300, kheight - 75)];
    [self editPath:rightpath];


    
}


-(void)BuildLines{
    
    self.animationView = [[UIView alloc]initWithFrame:CGRectMake(50, 00, 50, 20)];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(30, 0, 20, 20)];
    headview.backgroundColor = [UIColor blueColor];
    [self.animationView addSubview:headview];
    self.animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animationView];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 0)];
    [path addQuadCurveToPoint:CGPointMake(50, 100) controlPoint:CGPointMake(100, 75)];
    [path addQuadCurveToPoint:CGPointMake(100, 200) controlPoint:CGPointMake(50, 150)];
//    [path addQuadCurveToPoint:CGPointMake(150, 400) controlPoint:CGPointMake(205, 300)];
//    [path addLineToPoint:CGPointMake(10, 10)];
    [path stroke];
//    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 300, 600)];
////    [path2 stroke];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.duration = 3;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    animation.delegate = self;
    self.animation = animation;

    
}
-(CAShapeLayer *)editPath:(UIBezierPath *)path{
    path.lineWidth = 20;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:layer];
    return layer;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.AAlayer) {
        self.AAlayer.frame = CGRectMake(self.AAlayer.frame.origin.x + 100, self.AAlayer.frame.origin.y, self.AAlayer.frame.size.width, self.AAlayer.frame.size.height);
    }else{
        
        [self.animationView removeFromSuperview];
        self.animationView = [[UIView alloc]initWithFrame:CGRectMake(50, 00, 50, 20)];
        self.animationView.backgroundColor = [UIColor redColor];
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(30, 0, 20, 20)];
        headview.backgroundColor = [UIColor blueColor];
        [self.animationView addSubview:headview];
        [self.view addSubview:self.animationView];
        [self.animationView.layer addAnimation:_animation forKey:nil];
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"代理方法触发");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
