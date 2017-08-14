//
//  ViewController.m
//  YYdemo
//
//  Created by 胡杨林 on 2017/8/10.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduTraceSDK/BaiduTraceSDK.h>

@interface ViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate, BTKTraceDelegate, BTKTrackDelegate>

@property (nonatomic, strong)BMKMapView *mapview;
@property (nonatomic, strong)BMKLocationService *locationService;
@property (nonatomic, strong)CLLocation *location;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.mapview == nil) {
        self.mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 414, 414)];
    }
    [self.view addSubview:self.mapview];
    _mapview.showsUserLocation = YES;
    _mapview.userTrackingMode = BMKUserTrackingModeFollow;
    if (self.locationService == nil) {
        self.locationService = [[BMKLocationService alloc]init];
        self.locationService.delegate = self;
    }
    [_locationService startUserLocationService];
    
    BTKStartServiceOption *option = [[BTKStartServiceOption alloc]initWithEntityName:@"YYDemo"];
    [[BTKAction sharedInstance] startService:option delegate:self];
    [[BTKAction sharedInstance] startGather:self];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 构造请求对象
    BTKQueryTrackProcessOption *options = [[BTKQueryTrackProcessOption alloc]init];
    options.denoise = true;  //是否降噪
    options.vacuate = true; //是否抽稀
    options.mapMatch = true;  //是否绑路
    options.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING;  //运动模式设定
    
    
    NSUInteger endTime = [[NSDate date] timeIntervalSince1970];  //查询过去24小时的轨迹
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:@"YYDemo" startTime:endTime - 86400 endTime:endTime  isProcessed:TRUE processOption:options supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_RIDING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_DESC pageIndex:1 pageSize:50 serviceID:147404 tag:0];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];

}
-(void)onQueryHistoryTrack:(NSData *)response{

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"track history response: %@", dict);
    NSArray *arr = dict[@"points"];
    CLLocationCoordinate2D paths[arr.count];
    NSMutableArray *colors = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *point = arr[i];
        paths[i] = CLLocationCoordinate2DMake([point[@"latitude"] doubleValue], [point[@"longitude"] doubleValue]);
        UIColor *color = [UIColor redColor];
        [colors addObject:color];
    }
    BMKPolyline *colorfulPloyLine = [BMKPolyline polylineWithCoordinates:paths count:arr.count];
    [_mapview addOverlay:colorfulPloyLine];
    
}
//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 3;
        /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
        polylineView.strokeColor = [UIColor redColor];
        return polylineView;
    }
    return nil;
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_mapview updateLocationData:userLocation];
    self.location = userLocation.location;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapview.delegate = self;
    self.mapview.zoomLevel = 18.5;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mapview.delegate = nil;
    [[BTKAction sharedInstance] stopGather:self];
    [[BTKAction sharedInstance] stopService:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
