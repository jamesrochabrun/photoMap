//
//  PhotoController.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//
#import "PhotoController.h"
#import "VenueObject.h"

NSString *const DATA_VERSION_DATE = @"20161018";
NSString *const DATA_FORMAT = @"foursquare";
NSString *const HTTPURLVERSION = @"https://api.foursquare.com/v2";
@implementation PhotoController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)accessTokenWithcompletion:(void (^)(BOOL finished))completion {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [defaults stringForKey:@"accessToken"];
    
    if (!self.accessToken) {
        //step 3
        //ste 4 log the user info by signing in in the foursquare login view
        [SimpleAuth authorize:@"foursquare-web" completion:^(id responseObject, NSError *error) {
            
            //NSLog(@"response:  %@", responseObject);
            //accessing the token value in the credentials dictionary.
            NSString *token = responseObject[@"credentials"][@"token"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //creating a key value pair for accessToken
            [defaults setObject:token forKey:@"accessToken"];
            [defaults synchronize];
        }];
    }
}

+ (void)imageForPhoto:(VenueObject *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion {
    
    
    if (!photo  || !size || !completion) {
        NSLog(@"%@, %@, %@", photo, size, completion);
        return;
    };

    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", photo.prefix, size, photo.sufix];
    
    //CACHE
    NSString *key = urlString;
    
    UIImage *cachedPhoto = [[SAMCache sharedCache] imageForKey:key];
    
    if (cachedPhoto) {
       
        completion(cachedPhoto);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //its safer to create a nsdata before
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];
}

//THINK THAT THE COMPLETION IS JUST A METHOD PASSED AS AN ARGUMENT THAT BASICALLY IS LIKE THIS IN THIS CASE IT RETURMS A uiimage

//-(UIImage *)completion {
//    
//}
//+ (void)imageForPhoto:(VenueObject *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion {
//
//}

    
    
    
    
    
    
    
    
@end
