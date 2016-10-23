//
// SessionManager.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

- (instancetype)init {
 
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *venueTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (data) {
            success(responseDict);
        } else {
            failure(data, response, error);
        }
    }];
    
    [venueTask resume];
}

@end
