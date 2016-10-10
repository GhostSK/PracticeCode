//
//  contentView.m
//  三级联动窗口
//
//  Created by 胡杨林 on 16/10/10.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "contentView.h"

@interface contentView()

@property(nonatomic,strong)UILabel *label;

@end

@implementation contentView

-(instancetype)init{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Change:) name:@"cutpageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Change:) name:@"refreshContentView" object:nil];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.text = @"初始化";
    [self addSubview:label];
    self.label = label;
    return self;
}

-(void)Change:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[NSIndexPath class]]) {
        _index = notification.object;
    }else{
        _seg = notification.object;
    }
    NSString *str = [NSString stringWithFormat:@"目前内容为第%ld页第%ld分段",_index.row + 1,_seg.selectedSegmentIndex + 1];
    self.label.text = str;
}

@end
