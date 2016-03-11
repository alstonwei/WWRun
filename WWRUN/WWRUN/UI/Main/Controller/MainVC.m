//
//  MainVC.m
//  WWRUN
//
//  Created by epailive on 16/3/10.
//  Copyright © 2016年 我就是大强. All rights reserved.
//

#import "MainVC.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainVC ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    
    CLLocation* _location;
   
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mYMapView;

@property(nonatomic,strong) CLLocationManager* locationManager;
@property (weak, nonatomic) IBOutlet UIButton *btnStartRecord;

- (IBAction)startRecord:(id)sender;

@end

@implementation MainVC




- (void)viewDidLoad
{
    [super viewDidLoad];
    _location = [[CLLocation alloc] init];
    
    
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

-(void)postNotification:(NSString*)str
{
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    // 设置触发通知的时间
//    NSDate *fireDate = [self getNowDateFromatAnDate:[NSDate new]];
//    //
//    fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//    NSLog(@"fireDate=%@",fireDate);
//    
//    notification.fireDate = fireDate;
//    // 时区
//    notification.timeZone = [NSTimeZone localTimeZone];
//    // 设置重复的间隔
//    //notification.repeatInterval = kCFCalendarUnitWeek;
//    
//    // 通知内容
//    notification.alertBody =  @"后台在更新...";
//    notification.applicationIconBadgeNumber = 0;
//    // 通知被触发时播放的声音
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    // 通知参数
    
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"位置：%@",str] forKey:@"key"];
    //notification.userInfo = userDict;
    
    UILocalNotification *notificationNow = [[UILocalNotification alloc] init];
    notificationNow.alertBody =  @"后台在更新...";
    notificationNow.userInfo = userDict;
    // 执行通知注册
    [[UIApplication sharedApplication] presentLocalNotificationNow:notificationNow];

}

- (IBAction)startRecord:(id)sender {
    [self postNotification:@"start"];
    //需要主动调用用户授权。
    //[self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        // 创建位置管理者对象
        // 设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >=9.0 ) {
            // iOS0.0：如果当前的授权状态是使用是授权，那么App退到后台后，将不能获取用户位置，即使勾选后台模式：location
            [self.locationManager requestLocation];
            if ([self.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
                self.locationManager.allowsBackgroundLocationUpdates = YES;
            }
        }
        else
        {
            [self.locationManager startUpdatingLocation];
        }
       

        
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"tishi" message:@"你还没有打开位置定位" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}


/*
 *  locationManager:didUpdateToLocation:fromLocation:
 *
 *  Discussion:
 *    Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 *
 *    This method is deprecated. If locationManager:didUpdateLocations: is
 *    implemented, this method will not be called.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"newLocation :%@",newLocation);
}
/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"locations :%@",locations);
    
   [self postNotification:[locations description]];
}
/*
 *  locationManager:didUpdateHeading:
 *
 *  Discussion:
 *    Invoked when a new heading is available.
 */
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    
}
/*
 *  locationManagerShouldDisplayHeadingCalibration:
 *
 *  Discussion:
 *    Invoked when a new heading is available. Return YES to display heading calibration info. The display
 *    will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

/*
 *  locationManager:didDetermineState:forRegion:
 *
 *  Discussion:
 *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
 *    a call to requestStateForRegion:.
 */
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
}

/*
 *  locationManager:didRangeBeacons:inRegion:
 *
 *  Discussion:
 *    Invoked when a new set of beacons are available in the specified region.
 *    beacons is an array of CLBeacon objects.
 *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
 *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
 *    by the device.
 */
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    
}

/*
 *  locationManager:rangingBeaconsDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
    
}

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    
}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region{
    
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}


/** 定位服务状态改变时调用*/
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

#pragma mark gettar

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 0.0001;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // 设置定位精度(精度越高越耗电)
    }
    return _locationManager;
}

@end
