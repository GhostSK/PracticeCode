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
    
    /*
     //设置需要获取的权限仅设置了步数
     HKObjectType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
     HKObjectType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
     
     NSSet *healthSet = [NSSet setWithObjects:stepType, distanceType, nil];
     //从健康应用中获取数据
     [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
     if (success) {
     //获取步数后我们调用获取步数的方法
     [self readStepCount];
     }
     else
     {
     NSLog(@"获取步数权限失败");
     }
     }];
     */
    
    /*
     主要枚举：HKQuantityTypeIdentifierBodyMassIndex：体重指数
     HKQuantityTypeIdentifierBodyFatPercentage：体脂率
     HKQuantityTypeIdentifierHeight：身高
     HKQuantityTypeIdentifierBodyMass：体重
     HKQuantityTypeIdentifierLeanBodyMass：去脂体重
     HKQuantityTypeIdentifierStepCount：行走步数
     HKQuantityTypeIdentifierDistanceWalkingRunning：走跑距离
     HKQuantityTypeIdentifierDistanceCycling：骑行距离
     HKQuantityTypeIdentifierDistanceWheelchair：轮椅距离（喵喵喵？）
     HKQuantityTypeIdentifierBasalEnergyBurned：基础能量消耗/静息能量消耗
     HKQuantityTypeIdentifierActiveEnergyBurned：活动能量消耗
     HKQuantityTypeIdentifierFlightsClimbed：爬升距离/已爬楼层
     HKQuantityTypeIdentifierAppleExerciseTime：锻炼时间
     HKQuantityTypeIdentifierPushCount：推动次数
     HKQuantityTypeIdentifierDistanceSwimming：游泳距离  （这两项可能要手表数据，水果机不防水的吧
     HKQuantityTypeIdentifierSwimmingStrokeCount：划水次数  
     
     HKQuantityTypeIdentifierHeartRate：心率
     HKQuantityTypeIdentifierBodyTemperature：体温
     HKQuantityTypeIdentifierBasalBodyTemperature 基础体温
     HKQuantityTypeIdentifierBloodPressureSystolic 收缩血压/高压
     HKQuantityTypeIdentifierBloodPressureDiastolic 舒张血压/低压
     HKQuantityTypeIdentifierRespiratoryRate：呼吸频率

     
     */
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


    /*
-(void)readStepCount{
    //查询拆样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //NSSoryDescriptors用来告诉HealthStore排序方式
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];

     查询的基类是HKQuery,这是一个抽象类 能够实现每一种查询目标 这里我们需要查询的步数是一个
     HKSample类所以对应的查询类就是HKSampleQuery
     下面的limit参数传1表示查询最近一条数据，查询多条数据只要设置limit的参数值就可以了

    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc]initWithSampleType:sampleType predicate:[self predicateDorSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[start, end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        int allstepCount = 0;
        for (int i = 0; i <  results.count; i++) {
            //把结果转换为字符串类型
            HKQuantitySample *result = results[i];
            HKQuantity *quantity = result.quantity;
            NSMutableString *StepCount = (NSMutableString *)quantity;
            NSString *StepStr = [NSString stringWithFormat:@"%@",StepCount];
            //获取 51 count此类字符串前面的数字
            NSString *str = [StepStr componentsSeparatedByString:@" "][0];
            int StepNum = [str intValue];
            NSLog(@"%d",StepNum);
            //把一天中所有时间段中的步数加在一起
            allstepCount += StepNum;
        }
        NSLog(@"今天总步数 === %d",allstepCount);
        self.label.text = [NSString stringWithFormat:@"今日已行走%d步。",allstepCount];
    }];
    
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
    
    
    
    
}
     */



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
