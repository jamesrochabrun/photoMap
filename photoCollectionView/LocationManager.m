//
//  LocationManager.m
//  photoApp
//
//  Created by James Rochabrun on 10/11/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "LocationManager.h"
#import "Common.h"

@implementation LocationManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation]; //Will update location immediately
        
    }
    return self;
}

- (void)displayAlertAskingforUserPermission {
    
    UIAlertController *a= [UIAlertController alertControllerWithTitle:@"This app needs access to your location"
                                                              message:@"Allow us to access your location to show you the departure point, and the best route to get there"
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Not now"
                                                     style: UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                         //donothing
                                                     }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Go"
                                                 style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     
                                                     if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                                                         [_locationManager requestWhenInUseAuthorization];
                                                     } else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                                                         [_locationManager requestAlwaysAuthorization];
                                                     }
                                                 }];
    [a addAction:cancel];
    [a addAction:ok];
    
    [self.delegate displayAlertInVC:a];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking granting location access!");
            [_locationManager startUpdatingLocation]; // this will access location automatically if user granted access manually. and will not show apple's request alert twice. (Tested)
           // [self displayAlertAskingforUserPermission];
            
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied location access request!!");
            // show text on label
            [self displayAlertIfAuthoriztionIsDenied];
            [_locationManager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            // clear text
            NSLog(@"yes located");
            [_locationManager startUpdatingLocation]; //Will update location immediately
            
        } break;
        default:
            break;
    }
}

- (void)displayAlertIfAuthoriztionIsDenied {
    
    UIAlertController *a= [UIAlertController alertControllerWithTitle: @"This app needs location service enable."
                                                              message: @"Please go to your settings and allow access to your location"
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style: UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                         //donothing
                                                         
                                                     }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Go"
                                                 style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     [Common goToSettings:kAppSettingsLocation];
                                                     
                                                 }];
    [a addAction:cancel];
    [a addAction:ok];
    
    [self.delegate displayAlertInVC:a];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    CLGeocoder *geocoer = [[CLGeocoder alloc]init];
    [geocoer reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        _locationString = placeMark.name;
        _longitude = placeMark.location.coordinate.longitude;
        _latitude = placeMark.location.coordinate.latitude;
        
        NSLog(@"latitude %f", _latitude);
        NSLog(@"longitude %f", _longitude);
    }];
}

- (void)dealloc {
    [_locationManager stopUpdatingLocation];
}






@end
