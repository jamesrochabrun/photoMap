//
//  LocationManager.h
//  secretdiary
//
//  Created by James Rochabrun on 10/11/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol LocationManagerDelegate <NSObject>
-(void)displayAlertInVC:(UIAlertController *)alertController;

@end


@interface LocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) id<LocationManagerDelegate>delegate;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) CGFloat latitude;
- (void)updateLocationWithcompletion:(void(^)(CGFloat latitude, CGFloat longitude))completion;
-(void)methodWithDelay:(void(^)(BOOL result))completion;

@end
