//
//  API.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//
#import "API.h"
#import "VenueObject.h"
#import "TipObject.h"
#import "SessionManager.h"



NSString *const DATA_VERSION_DATE = @"20161018";
NSString *const DATA_FORMAT = @"foursquare";
NSString *const HTTPURLVERSION = @"https://api.foursquare.com/v2";
NSString *const ACCESSTOKEN = @"accessToken";

@interface API()
- (NSString *)accessToken;
@end

@implementation API

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)accessToken {
    return [API token];
}

+ (NSString *)token {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults stringForKey:ACCESSTOKEN];
    
    if (!accessToken) {
        //step 3
        //ste 4 log the user info by signing in in the foursquare login view
        [SimpleAuth authorize:@"foursquare-web" completion:^(id responseObject, NSError *error) {
            
            //NSLog(@"response:  %@", responseObject);
            //accessing the token value in the credentials dictionary.
            NSString *token = responseObject[@"credentials"][@"token"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //creating a key value pair for accessToken
            [defaults setObject:token forKey:ACCESSTOKEN];
            [defaults synchronize];
            
            if(token) {
                //go to next VIew
                [[NSNotificationCenter defaultCenter] postNotificationName:@"token" object:nil];
            }
        }];
    }
    return accessToken;
}


+ (void)getLikedVenuesID:(void (^)(NSArray *venuesID))success
                 failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {
    
    
    NSString *urlLikedVenues = [NSString stringWithFormat:@"%@/users/self/venuelikes/?oauth_token=%@&v=%@&m=%@", HTTPURLVERSION, [API token], DATA_VERSION_DATE, DATA_FORMAT];
    
    //NSLog(@"PATH VENUESID %@", urlLikedVenues);

    SessionManager *sessionManager = [SessionManager new];
    
    [sessionManager GET:urlLikedVenues parameters:nil success:^(id responseObject) {
        NSArray *likedVenuesID = [responseObject valueForKeyPath:@"response.venues.items.id"];
        success(likedVenuesID);
    } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
}

+ (void)getVenueFromID:(NSString *)venueID
               success:(void (^)(VenueObject *venue))success
                 failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {
    
    if (!venueID) {
        NSLog( @"PROBLEM : VENUEID :%@", venueID);
        return;
    }
    
    NSString *urlVenueStr = [NSString stringWithFormat:@"%@/venues/%@?oauth_token=%@&v=%@&m=%@", HTTPURLVERSION, venueID, [API token], DATA_VERSION_DATE, DATA_FORMAT];
    
    SessionManager *sessionManager = [SessionManager new];
    [sessionManager GET:urlVenueStr parameters:nil success:^(id responseObject) {
        VenueObject *venue = [VenueObject venueFromDict:responseObject];
        success(venue);
    } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
}

+ (void)getTipsFromVenue:(VenueObject *)venue
                 success:(void (^)(NSArray *tips))success
                 failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {
    
    if(!venue) {
        NSLog(@"PROBLEM: VENUE IS %@", venue);
        return;
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@/venues/%@/tips/?oauth_token=%@&v=%@&m=%@",HTTPURLVERSION, venue.venueID, [API token], DATA_VERSION_DATE, DATA_FORMAT];
    
    //NSLog(@"the urlString %@", urlString);

        NSMutableArray *tips = [NSMutableArray new];
        
        SessionManager *sessionManager = [SessionManager new];
        
        [sessionManager GET:urlString parameters:nil success:^(id responseObject) {
            NSArray *tipsArray = [responseObject valueForKeyPath:@"response.tips.items.text"];
            for (NSString *tipString in tipsArray) {
                TipObject *tipObject = [TipObject tipFromString:tipString];
                [tips addObject:tipObject];
            }
            success((NSArray *)tips);
        } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
        }];
}

+ (void)getRecommendedVenuesInLatitude:(CGFloat)latitude
                          andLongitude:(CGFloat)longitude
                               success:(void (^)(NSArray *venues))success
                           failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {
    
    if (!latitude || !longitude) {
        NSLog(@"PROBLEM : LATITUDE IS % AND LONGITUDE IS %f", latitude, longitude);
        return;
    }

    NSString *string = [NSString stringWithFormat: @"%@/venues/explore?ll=%f,%f&oauth_token=%@&v=%@",HTTPURLVERSION ,latitude, longitude,[API token], DATA_VERSION_DATE];
    //NSLog(@"PATH RECOMMENDED NEARBY %@", string);
    
    SessionManager *sessionManager = [SessionManager new];
    [sessionManager GET:string parameters:nil success:^(id responseObject) {
        NSArray *venues = [responseObject valueForKeyPath:@"response.groups.items.venue.name"];
        success(venues);
    } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
}

+ (void)getTrendingVenuesInLatitude:(CGFloat)latitude
                          andLongitude:(CGFloat)longitude
                               success:(void (^)(NSArray *venues))success
                               failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure {
    
    if (!latitude || !longitude) {
        NSLog(@"PROBLEM : LATITUDE IS % AND LONGITUDE IS %f", latitude, longitude);
        return;
    }
    
    NSString *string = [NSString stringWithFormat: @"%@/venues/trending?ll=%f,%f&oauth_token=%@&v=%@",HTTPURLVERSION ,latitude, longitude,[API token], DATA_VERSION_DATE];
    //NSLog(@"PATH TRENDING venues %@", string);
    
    SessionManager *sessionManager = [SessionManager new];
    [sessionManager GET:string parameters:nil success:^(id responseObject) {
        NSArray *venues = [responseObject valueForKeyPath:@"response.venues.name"];
        success(venues);
    } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];

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
