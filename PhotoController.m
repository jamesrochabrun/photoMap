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

@interface PhotoController()
- (NSString *)accessToken;
@end

@implementation PhotoController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)accessToken {
    return [PhotoController token];
}

+ (NSString *)token {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults stringForKey:@"accessToken"];
    
    if (!accessToken) {
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
    NSLog(@"ACCESS TOKEN : %@", accessToken);
    return accessToken;
}




- (void)getLikedVenuesID:(void (^)(NSArray *venuesID))success
                 failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlLikedVenues = [NSString stringWithFormat:@"%@/users/self/venuelikes/?oauth_token=%@&v=%@&m=%@", HTTPURLVERSION, [PhotoController token], DATA_VERSION_DATE, DATA_FORMAT];
    NSLog(@"PATH LIKEDVENUESIDS = %@", urlLikedVenues);
    NSURL *url = [NSURL URLWithString:urlLikedVenues];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSArray *likedVenuesID = [responseDict valueForKeyPath:@"response.venues.items.id"];
        
        //Now get the venue by ID
        if (data) {
            success(likedVenuesID);
        } else {
            failure(data, response, error);
        }
    }];
    
    [task resume];
}

- (void)getVenueFromID:(NSString *)venueID
               success:(void (^)(VenueObject *venue))success
                 failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlVenueStr = [NSString stringWithFormat:@"%@/venues/%@?oauth_token=%@&v=%@&m=%@", HTTPURLVERSION, venueID, [PhotoController token], DATA_VERSION_DATE, DATA_FORMAT];
    NSURL *urlForVenue = [NSURL URLWithString:urlVenueStr];
    NSURLRequest *venueRequest = [NSURLRequest requestWithURL:urlForVenue];
    
    NSURLSessionDownloadTask *venueTask = [session downloadTaskWithRequest:venueRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *venuedictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        VenueObject *venue = [VenueObject venueFromDict:venuedictionary];
        
        if (data) {
            success(venue);
        } else {
            failure(data, response, error);
        }
    }];
    
    [venueTask resume];
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
