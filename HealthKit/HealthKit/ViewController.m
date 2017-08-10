//
//  ViewController.m
//  HealthKit
//
//  Created by 胡杨林 on 2017/8/10.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>


@interface ViewController ()

@property (nonatomic, strong)HKHealthStore *HKStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.HKStore = [[HKHealthStore alloc]init];
    HKObjectType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];//步数
    //将你想查询的数据类型各自设置一个HKObjectTyoe，然后放进下面的NSSet中
    NSSet *healthSet = [NSSet setWithObjects:stepType, nil];
    HKObjectType *heartType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    NSSet *readSet = [NSSet setWithObjects:heartType, nil];
    //shareTypesSet设置的是需要写入数据的NSset集合，readTypes设置的是读取数据的NSSet
    //返回结果中，如果success == true，则授权成功，开始进行读取操作
    [self.HKStore requestAuthorizationToShareTypes:readSet readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //这里为授权成功，跳转或者就地执行查询操作
            //APP只需授权一次永久生效
            NSLog(@"授权成功");
            [self requestData];
        }else{
            NSLog(@"授权失败");
        }
    }];
}

-(void)requestData{
    //设置你需要查询的采样信息
    //所有的查询类都是基于抽象类HKQuery，这里我们用查询步数来举例，步数对应的类是HKSample类，所以我们需要实例化一个HKSampleQuery对象
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //NSSortDescriptor类是排序规则描述类,start规则描述了按照HKSample的运动开始时间startTimestamp降序排序
    //同理end描述了按照运动的结束时间endTimestamp降序排序
    //@[start end]的排序描述的规则是：首先按照运动开始时间排序，如果开始时间相同，则按照结束时间降序排序
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    //设置查询期间
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //将当前时间按照上述格式分割成年月日时分秒六个数字，然后提取时分秒
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:now];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    //当前时间点 减去今天已经过去的时分秒 加上东八区时差补偿 = 今天开始的00：00分
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second) + 28800];
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second) + 28800 + 86400];
    //设置查询范围为今天到明天的24小时内
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:today endDate:tomorrow options:HKQueryOptionNone];

    HKSampleQuery *query = [[HKSampleQuery alloc]initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[start, end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (results.count > 0) {
            NSLog(@"查询成功");
            NSInteger count = 0;
            for (int i = 0 ; i < results.count ; i++) {
                HKQuantitySample *result = results[i];
                NSString *str = [NSString stringWithFormat:@"%@",result.quantity];
                NSLog(@"%@",str);
                NSString *str2 = [str componentsSeparatedByString:@" "][0];
                NSInteger step = [str2 integerValue];
                count += step;
            }
            NSLog(@"今天共计走了%ld步。",count);
        }
    }];
    [self.HKStore executeQuery:query];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
