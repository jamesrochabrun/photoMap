//
//  VenueObject.h
//  photoCollectionView
//
//  Created by James Rochabrun on 10/21/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueObject : NSObject
@property (nonatomic) NSString *prefix;
@property (nonatomic) NSString *sufix;
@property (nonatomic) NSString *venueID;
@property (nonatomic) NSString *venueName;

+ (VenueObject *)venueFromDict:(NSDictionary *)dict;

@end
