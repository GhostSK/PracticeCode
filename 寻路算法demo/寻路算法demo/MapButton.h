//
//  MapButton.h
//  寻路算法demo
//
//  Created by 胡杨林 on 16/11/11.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapButton : UIButton

@property(nonatomic, assign)BOOL isStartPoint;
@property(nonatomic, assign)BOOL isEndPoint;
@property(nonatomic, assign)BOOL isHinder;
@property(nonatomic, assign)CGFloat G;
@property(nonatomic, assign)CGFloat H;
@property(nonatomic, strong)MapButton *fatherPoint;
@end
