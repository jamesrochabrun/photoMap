//
//  VenueObject.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/21/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "VenueObject.h"
#import "Common.h"

@implementation VenueObject

+ (VenueObject *)venueFromDict:(NSDictionary *)dict {
    
    VenueObject *venue = [VenueObject new];
    venue.sufix = parseStringOrNullFromServer([dict valueForKeyPath:@"response.venue.bestPhoto.suffix"]);
    venue.prefix = parseStringOrNullFromServer([dict valueForKeyPath:@"response.venue.bestPhoto.prefix"]);
    venue.venueID = parseStringOrNullFromServer(dict[@"response"][@"venue"][@"id"]);
    venue.venueName = parseStringOrNullFromServer([dict valueForKeyPath:@"response.venue.name"]);
    return venue;
}

@end
