//
//  API.h
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SAMCache/SAMCache.h>
#import <SimpleAuth/SimpleAuth.h>

@class VenueObject;

extern NSString *const DATA_VERSION_DATE;
extern NSString *const DATA_FORMAT;
extern NSString *const HTTPURLVERSION;

@interface API : NSObject
+ (void)imageForPhoto:(VenueObject *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;
- (void)getLikedVenuesID:(void (^)(NSArray *venuesID))success
                 failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure;
- (void)getVenueFromID:(NSString *)venueID
               success:(void (^)(VenueObject *venue))success
               failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure;
- (void)getTipsFromVenue:(VenueObject *)venue
                 success:(void (^)(NSArray *tips))success
                 failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure;
- (void)getRecommendedVenuesNearby:(void (^)(NSArray *venues))success
                           failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure;

@end
